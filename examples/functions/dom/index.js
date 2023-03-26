import { DOMParser } from "https://deno.land/x/deno_dom/deno-dom-wasm.ts";
import { serve } from "https://deno.land/std@0.168.0/http/server.ts"

console.log("Welcome Function")

async function fetchHtml(url) {
    const res = await fetch(url)
    return await res.text()
}

function createDOM(html) {
    return new DOMParser().parseFromString(html, "text/html")
}



function isTikTokURL(url) {
    const regex = /^https?:\/\/(?:www\.)?tiktok\.com\/@([^\/]+)\/video\/(\d+)/
    return regex.test(url)
}


function isValidVideoID(videoID) {
    const regex = /^\d+$/
    return regex.test(videoID)
}

function getVideoID(url) {
    if (!isTikTokURL(url)) {
        throw new Error('Invalid TikTok URL')
    }

    let parts = url.split('?')
    parts = parts[0].split('/')
    const videoID = parts[parts.length - 1]

    if (!isValidVideoID(videoID)) {
        throw new Error('Invalid video ID')
    }

    return videoID
}

serve(async (req) => {
    const _url = new URL(req.url)
    const url = _url.searchParams.get('url')

    try {
        const videoID = getVideoID(url)

        const data = await fetchHtml(`https://tikwm.com/video/${videoID}.html`)
            .then(createDOM)
            .then(async document => {
                const title = document.querySelector("h1").textContent;
                const url1 = "https://tikwm.com" + document.querySelector(".container.text-center > a:nth-child(2)").getAttribute('href')

                const res = await fetch(url1)
                const url2 = res.url
                const post = `https://whynot.to/add?url=${encodeURIComponent(url2)}&description=${encodeURIComponent(title)}`
                console.log(title, "\n", url1, "\n", url2)

                return { title, url1, url2, post }
            })

        return Response.redirect(data.post, 302)

        // return Response.json({
        //     input: { url: url, videoID },
        //     output: data
        // })

    } catch (e) {
        return Response.json({
            error: e.message,
            url: url
        }, { status: 500 })
    }
})

//javascript: (() => { window.open(`https://tiktak.fun/api/dl2?post=https://demo.tict.app/add&url=${location.href}&description=${encodeURIComponent(document.querySelector("div[data-e2e=%27browse-video-desc%27]").textContent)}`, % 27tictapp % 27) })()
// javascript:(()=>  { window.open(`https://pro1.tictapp.fun/dom?url=${location.href}`) })()