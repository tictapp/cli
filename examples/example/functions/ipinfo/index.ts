import { serve } from "https://deno.land/std@0.131.0/http/server.ts";
import SupabaseClient from "https://esm.sh/v104/@supabase/supabase-js@2.5.0/dist/module/SupabaseClient";

function ips(req: Request) {
  return req.headers.get("x-forwarded-for")?.split(/\s*,\s*/);
}

serve(async (req) => {
  const url = new URL(req.url);
  const toJson = url.pathname === "/json";

  const supabase = new SupabaseClient(
    Deno.env.get("SUPABASE_URL"),
    Deno.env.get("SUPABASE_ANON_KEY"),
  );

  const clientIps = ips(req) || [""];
  const res = await fetch(
    `https://ipinfo.io/${clientIps[0]}?token=${Deno.env.get("IPINFO_TOKEN")}`,
    {
      headers: { "Content-Type": "application/json" },
    },
  );

  const data = await res.json();
  const region = Deno.env.get("DENO_REGION") || "local";
  const deployment_id = Deno.env.get("DENO_DEPLOYMENT_ID") || "dev";

  const { data: logEntry, error: logError } = await supabase.from("fun_logs")
    .insert({
      data: {
        deno: {
          region,
          deployment_id,
        },
        client: data,
      },
      inserted_at: new Date(),
    }).select("*");

  if (toJson) {
    return Response.json({
      deno: {
        region,
        deployment_id,
      },
      client: data,
      logEntry,
      logError,
    });
  }

  return new Response(
    `
    <h1>${data.city}, ${data.country} -> (tictapp.fun) <- ${region}</h1>
  `,
    {
      headers: {
        "Content-Type": "html",
      },
    },
  );
});
