import "https://deno.land/x/xhr@0.3.0/mod.ts";
import { serve } from "https://deno.land/std@0.168.0/http/server.ts";
import { CreateCompletionRequest } from "https://esm.sh/openai@3.1.0";

serve(async (req) => {
  const url = new URL(req.url);
  const query = url.searchParams.get("query"); //await req.json();

  console.log("url", url, query);

  if (!query) {
    return Response.json({ error: `Missing query param` }, {
      status: 400,
    });
  }

  const completionConfig: CreateCompletionRequest = {
    model: "text-davinci-003",
    prompt: query,
    max_tokens: 512,
    temperature: 0,
    stream: false,
  };

  const res = await fetch("https://api.openai.com/v1/completions", {
    method: "POST",
    headers: {
      Authorization: `Bearer ${Deno.env.get("OPENAI_API_KEY")}`,
      "Content-Type": "application/json",
    },
    body: JSON.stringify(completionConfig, null, 4),
  });

  const json = await res.json();

  const texts = json.choices.map((c) => c.text);

  return new Response(`${texts.join("\n***\n")}`);
});
