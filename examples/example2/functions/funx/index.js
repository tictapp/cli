
import { serve } from "server"

console.log("Welcome Function")

serve((req) => {

    const data = {
        url: req.url,
        message: Deno.env.toObject(),
    }

    return Response.json(data)
})
