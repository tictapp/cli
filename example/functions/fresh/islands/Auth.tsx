import { useEffect, useState } from "preact/hooks";
import { Button } from "../components/Button.tsx";
import { createClient, User } from "@supabase/supabase-js";
import { IS_BROWSER } from "$fresh/runtime.ts";

interface EnvProps {
  SUPABASE_URL: string;
  SUPABASE_ANON_KEY: string;
}

interface AuthProps {
  env: EnvProps;
}

export default function Auth(props: AuthProps) {
  const [user, setUser] = useState(null);

  useEffect(() => {
    const supabase = createClient(
      props.env.SUPABASE_URL,
      props.env.SUPABASE_ANON_KEY,
    );

    window.supabase = supabase;
    console.log(supabase);

    supabase.auth.getUser().then(({ data }) => {
      setUser(data.user);
    });

    supabase.from("get_secrets").select("*").then((res) => {
      console.log("get_secrets", res);
    });
  }, [props]);

  console.log(`getUser`, user);

  return (
    <div class="flex gap-2 w-full">
      <pre>{JSON.stringify(user, null, 4)}</pre>
    </div>
  );
}
