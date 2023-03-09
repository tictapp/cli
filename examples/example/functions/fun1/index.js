import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

console.log("Welcome Function")

serve((req) => {

    const data = {
        url: req.url,
        ENV: Deno.env.toObject(),
    }

    return Response.json(data)
})
    