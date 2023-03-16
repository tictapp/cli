
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

console.log("Welcome Function")

serve((req) => {

    const data = {
        url: req.url,
        message: Deno.env.toObject(),
    }

    return new Response(`

    <h1>WhyNot Video</h1>
    <video preload="auto" src="https://storage.whynot.tictapp.io/videos/294c990b-fa77-4163-93b3-8e4562d31b47/video-1653150431566.mp4#t=0.1" class="w-full h-full object-cover object-center absolute inset-0 z-10" loop="" playsinline="" style="object-fit: cover; background: rgba(0, 0, 0, 0);"><track kind="captions"></video>
   
    `, {
        headers: {
            'Content-Type': 'html'
        }
    })
})
