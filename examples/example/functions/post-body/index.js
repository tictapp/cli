// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import {
  getFreePort,
} from 'https://deno.land/x/free_port@v1.2.0/mod.ts'

console.log("Hello from Post Body Function!!!", Deno.env.toObject())

serve(async (req) => {
  const ok = Deno.env.get('MY_SECRET') && req.headers.get('my-secret') === Deno.env.get('MY_SECRET')

  console.log('url', ok, req.url, req.headers.get('my-secret'))

  if (!ok) {
    return Response.json({ error: `Access denied` }, {
      status: 401
    })
  }

  try {
    const payload = await req.json()
    const data = {
      url: req.url,
      payload
    }

    return Response.json(data)

  } catch (e) {
    console.error(e)
    console.log(req)
    return Response.json({ error: `${e}`, method: req.method, ct: req.headers.get('Content-Type') })
  }
}, {
  port: 8002
})

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
