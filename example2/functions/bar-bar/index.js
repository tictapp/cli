
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

console.log("Welcome Function")

serve(async (req) => {
    console.log(req.url)

    const options = {
        method: 'GET',
        headers: { Authorization: 'Bearer ddp_ebahKKeZqiZVeOad7KJRHskLeP79Lf0OJXlj' }
    };

    const res = await fetch('https://dash.deno.com/api/projects/a379eb86-5fd2-4690-9b01-caf793ed5f38/deployments/latest/logs', options)
    // .then(response => response.json())
    // .then(response => console.log(response))
    // .catch(err => console.error(err));

    return new Response(res.body, {
        headers: {
            'Content-Type': 'text/event-stream',
        },
    })

    const data = {
        fun: 'Bar Bar',
        url: req.url,
        env: Deno.env.toObject(),
    }

    return Response.json(data)
})
