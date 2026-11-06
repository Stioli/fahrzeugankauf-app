// Supabase Edge Function: fahrzeugschein-lesen
// Autohaus Stieber GmbH – liest eine Zulassungsbescheinigung Teil I (Fahrzeugschein)
// aus einem Foto oder Scan und gibt die Felder als JSON zurück.
//
// - Aufruf nur mit gültiger Anmeldung (verify_jwt = true).
// - Das Bild wird NICHT gespeichert, nur an Claude geschickt und verworfen.
// - Der API-Key liegt als Secret ANTHROPIC_API_KEY in Supabase, nie im Browser.

import "jsr:@supabase/functions-js/edge-runtime.d.ts";

const ANTHROPIC_API_KEY = Deno.env.get("ANTHROPIC_API_KEY") ?? "";
const MODEL = Deno.env.get("FZS_MODELL") ?? "claude-sonnet-5-5";

const CORS = {
  "Access-Control-Allow-Origin": "*",
  "Access-Control-Allow-Headers": "authorization, x-client-info, apikey, content-type",
  "Access-Control-Allow-Methods": "POST, OPTIONS",
};

function json(body: unknown, status = 200) {
  return new Response(JSON.stringify(body), {
    status,
    headers: { ...CORS, "Content-Type": "application/json" },
  });
}

const SYSTEM_PROMPT = `Du liest deutsche Zulassungsbescheinigungen Teil I (Fahrzeugschein) aus Fotos oder Scans.
Lies nur, was wirklich auf dem Dokument steht. Rate nie. Ist ein Feld nicht lesbar oder nicht vorhanden, gib null zurück.
Antworte AUSSCHLIESSLICH mit einem JSON-Objekt (kein Markdown, kein Text davor oder danach) nach diesem Schema:
{
  "ist_fahrzeugschein": true,
  "kennzeichen": "Feld A, z. B. S-AB 1234 (mit Bindestrich nach dem Ortskürzel, Leerzeichen vor den Ziffern)",
  "erstzulassung": "Feld B als JJJJ-MM-TT",
  "halter_name": "Feld C.1.1 (Name oder Firma)",
  "halter_vorname": "Feld C.1.2",
  "halter_strasse": "Straße und Hausnummer aus C.1.3",
  "halter_plz": "PLZ aus C.1.3",
  "halter_ort": "Ort aus C.1.3",
  "marke": "Feld D.1 in üblicher Schreibweise, z. B. Volkswagen, Mercedes-Benz, Opel, Kia, Hyundai",
  "modell": "Handelsbezeichnung Feld D.3 in üblicher Schreibweise, z. B. Golf, Tucson, A-Klasse",
  "fin": "Feld E, 17 Zeichen, ohne Leerzeichen, Großbuchstaben",
  "hubraum_ccm": 1498,
  "leistung_kw": 110,
  "kraftstoff": "genau einer der Werte: Benzin, Diesel, Hybrid, Plug-in-Hybrid, Elektro, Gas (CNG) – abgeleitet aus P.3 (z. B. 'Hybr.Benzin/E' ohne externe Lademöglichkeit = Hybrid, mit OVC/extern aufladbar = Plug-in-Hybrid)",
  "farbe": "Feld R, z. B. Grau, Schwarz, Weiß",
  "sitzplaetze": 5,
  "hu_monat": "nächste HU als JJJJ-MM, falls auf dem Dokument vermerkt, sonst null",
  "unsicher": ["Liste der Felder (Schlüssel wie oben), die schwer lesbar waren"]
}
Ist das Bild kein Fahrzeugschein, setze "ist_fahrzeugschein": false und alle übrigen Felder auf null.
Zahlen als Zahl, nicht als Text.`;

function extractJson(text: string): any {
  let t = text.trim();
  const fence = t.match(/```(?:json)?\s*([\s\S]*?)```/i);
  if (fence) t = fence[1].trim();
  const s = t.indexOf("{"), e = t.lastIndexOf("}");
  if (s === -1 || e <= s) throw new Error("Kein JSON in der Antwort");
  return JSON.parse(t.slice(s, e + 1));
}

const ERLAUBT = ["image/jpeg", "image/png", "image/webp", "image/gif", "application/pdf"];

Deno.serve(async (req: Request) => {
  if (req.method === "OPTIONS") return new Response("ok", { headers: CORS });
  if (req.method !== "POST") return json({ error: "Nur POST erlaubt" }, 405);
  if (!ANTHROPIC_API_KEY) return json({ error: "ANTHROPIC_API_KEY ist nicht gesetzt." }, 500);

  // Nur angemeldete Benutzer der App (der öffentliche App-Schlüssel allein reicht nicht)
  const token = (req.headers.get("authorization") ?? "").replace(/^Bearer\s+/i, "");
  const SB_URL = Deno.env.get("SUPABASE_URL") ?? "";
  const SB_ANON = Deno.env.get("SUPABASE_ANON_KEY") ?? "";
  if (!token || token.startsWith("sb_")) return json({ error: "Bitte anmelden" }, 401);
  const u = await fetch(`${SB_URL}/auth/v1/user`, { headers: { apikey: SB_ANON, Authorization: `Bearer ${token}` } });
  if (!u.ok) return json({ error: "Bitte anmelden" }, 401);

  let p: any;
  try { p = await req.json(); } catch { return json({ error: "JSON erwartet" }, 400); }

  const daten = String(p.daten ?? "");
  const typ = String(p.typ ?? "");
  if (!daten || !ERLAUBT.includes(typ)) return json({ error: "Bild (JPG/PNG/WEBP) oder PDF erwartet" }, 400);
  if (daten.length > 7_000_000) return json({ error: "Datei zu groß (max. ca. 5 MB)" }, 413);

  const quelle = { type: "base64", media_type: typ, data: daten };
  const block = typ === "application/pdf"
    ? { type: "document", source: quelle }
    : { type: "image", source: quelle };

  let resp: Response;
  try {
    resp = await fetch("https://api.anthropic.com/v1/messages", {
      method: "POST",
      headers: {
        "x-api-key": ANTHROPIC_API_KEY,
        "anthropic-version": "2023-06-01",
        "content-type": "application/json",
      },
      body: JSON.stringify({
        model: MODEL,
        max_tokens: 1500,
        system: SYSTEM_PROMPT,
        messages: [{ role: "user", content: [block, { type: "text", text: "Lies diesen Fahrzeugschein aus." }] }],
      }),
    });
  } catch (e) {
    return json({ error: "Verbindung zur KI fehlgeschlagen", detail: String(e) }, 502);
  }

  if (!resp.ok) {
    const t = await resp.text();
    return json({ error: "KI-Fehler", status: resp.status, detail: t.slice(0, 500) }, 502);
  }

  const data = await resp.json();
  const text = (data.content ?? []).filter((b: any) => b.type === "text").map((b: any) => b.text).join("\n");
  try {
    return json({ ok: true, felder: extractJson(text), modell: MODEL });
  } catch {
    return json({ ok: false, error: "Antwort nicht lesbar" }, 200);
  }
});
