import { Head } from "$fresh/runtime.ts";
import Auth from "../islands/Auth.tsx";

export default function User() {
  const SUPABASE_URL = Deno.env.get("SUPABASE_URL") || "";
  const SUPABASE_ANON_KEY = Deno.env.get("SUPABASE_ANON_KEY") || "";

  return (
    <>
      <Head>
        <title>Fresh App</title>
      </Head>
      <div class="p-4 mx-auto max-w-screen-md">
        <img
          src="/logo.svg"
          class="w-32 h-32 m-auto"
          alt="the fresh logo: a sliced lemon dripping with juice"
        />
        <Auth env={{ SUPABASE_URL, SUPABASE_ANON_KEY }} />
      </div>
    </>
  );
}
