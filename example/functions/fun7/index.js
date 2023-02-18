// Follow this setup guide to integrate the Deno language server with your editor:
// https://deno.land/manual/getting_started/setup_your_environment
// This enables autocomplete, go to definition, etc.

import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import * as jose from "https://deno.land/x/jose@v4.3.7/index.ts";

function getAuthToken(request) {
  const authHeader = request.headers.get("authorization");
  if (!authHeader) {
    throw ("Missing authorization header");
  }
  const [bearer, token] = authHeader.split(" ");
  if (bearer !== "Bearer") {
    throw (`Auth header is not 'Bearer {token}'`);
  }
  return token;
}

async function verifyJWT(jwt) {
  const encoder = new TextEncoder();
  const secretKey = encoder.encode(Deno.env.get("JWT_SECRET"));
  try {
    await jose.jwtVerify(jwt, secretKey);
  } catch (err) {
    console.error(err);
    return false;
  }
  return true;
}

console.log("Hello from fun7!!!")

serve(async (req, connInfo) => {
  const addr = connInfo.remoteAddr
  const ip = addr.hostname;

  console.log('url', ip, req.url)

  const VERIFY_JWT = Deno.env.get("VERIFY_JWT") === "true";

  if (req.method !== "OPTIONS" && VERIFY_JWT) {
    try {
      const token = getAuthToken(req);
      const isValidJWT = await verifyJWT(token);

      if (!isValidJWT) {
        return new Response(
          JSON.stringify({ error: `Invalid Auth Token` }),
          {
            headers: {
              "Content-Type": "application/json",
              "X-Relay-Error": true
            }, status: 401
          },
        )
      }
    } catch (e) {
      return new Response(
        JSON.stringify({ error: e }),
        {
          headers: {
            "Content-Type": "application/json",
            "X-Relay-Error": true
          }, status: 401
        },
      )
    }
  }
  const headers = {}
  // Print the headers of the headers object.
  for (const [key, value] of req.headers.entries()) {
    headers[key] = value
  }

  const data = {
    name: 'fun7',
    ip,
    addr,
    url: req.url,
    headers,
    message: Deno.env.toObject(),
  }

  return new Response(
    JSON.stringify(data),
    { headers: { "Content-Type": "application/json" } },
  )
})

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_I0' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'
