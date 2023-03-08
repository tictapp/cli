import { Head } from "$fresh/runtime.ts";
import Counter from "../islands/Counter.tsx";
import { createClient } from "@supabase/supabase-js";
import { IS_BROWSER } from "$fresh/runtime.ts";
import Auth from "../islands/Auth.tsx";

export default function Home() {
  // if (IS_BROWSER) {
  //   const url = new URL(window.location.href);
  //   console.log(url);
  //   const supabase = createClient(
  //     Deno.env.get("SUPABASE_URL"),
  //     Deno.env.get("SUPABASE_ANON_KEY"),
  //   );
  //   window.supabase = supabase;
  //   console.log(supabase);
  // }

  const SUPABASE_URL = Deno.env.get("SUPABASE_URL") || "";
  const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY") || "";
  const SUPABASE_SERVICE_KEY = Deno.env.get("SUPABASE_SERVICE_KEY") || "";

  const _env = Deno.env.toObject();

  return (
    <>
      <Head>
        <title>{SUPABASE_URL}</title>
      </Head>
      <div class="p-4 mx-auto max-w-screen-md">
        <img
          src="logo.svg"
          class="w-32 h-32"
          alt="the fresh logo: a sliced lemon dripping with juice"
        />

        <h1 class="text-orange-500 font-extrabold">{SUPABASE_URL}</h1>

        <Auth env={{ SUPABASE_URL, SUPABASE_ANON_KEY, SUPABASE_SERVICE_KEY }} />
      </div>
    </>
  );
}
