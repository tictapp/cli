import { useEffect, useState } from "preact/hooks";
import { createClient } from "@supabase/supabase-js";

interface EnvProps {
  SUPABASE_URL: string;
  SUPABASE_ANON_KEY: string;
}

interface AuthProps {
  env: EnvProps;
}

interface LoginForm {
  id: string;
  password: string;
}

interface SignupForm {
  id: string;
  password: string;
}

let supabase;

export default function Auth(props: AuthProps) {
  //const [supabase, setSupabase] = useState(null);
  const [error, setError] = useState<any>();
  const [message, setMessage] = useState<any>();

  useEffect(() => {
    supabase = createClient(
      props.env.SUPABASE_URL,
      props.env.SUPABASE_ANON_KEY,
    );

    const { data: { subscription } } = supabase.auth.onAuthStateChange(
      (event, session) => {
        console.log(event, session);
        setMessage({ __AuthChangeEvent__: event, ...session });
      },
    );

    window.supabase = supabase;
    console.debug(supabase);

    //setSupabase(supabase);

    // supabase.auth.getUser().then(({ data }) => {
    //   setMessage(data);
    // });

    // supabase.from("get_secrets").select("*").then((res) => {
    //   console.log("get_secrets", res);
    // });

    return () => {
      subscription.unsubscribe();
    };
  }, [props.env]);

  async function _github() {
    const { data, error } = await supabase.auth.signInWithOAuth({
      provider: "github",
    });
  }

  async function _google() {
    const { data, error } = await supabase.auth.signInWithOAuth({
      provider: "google",
    });
  }

  let box = <div></div>;

  let user = message?.user;

  if (user && user?.user_metadata.avatar_url) {
    box = (
      <div>
        <img
          src={user.user_metadata.avatar_url}
          class="w-16 h-16 rounded-full"
        />
        <h1 class="font-bold mt-2">{user.user_metadata.name}</h1>
        <h1 class="font-light mt-1">{user.email}</h1>
      </div>
    );
  }

  let errorBox = "";
  if (error) {
    errorBox = (
      <pre class="text-red-500 my-2 text-xs font-mono">{JSON.stringify(error, null, 2)}</pre>
    );
  }

  let msgBox = "";
  if (message) {
    msgBox = (
      <pre class="text-blue-500 my-2 text-xs font-mono">{JSON.stringify(message, null, 2)}</pre>
    );
  }

  async function signIn(params: LoginForm) {
    const { id, password } = params;

    if (!supabase) {
      setError({ message: `Supabase client error` });
      return;
    }

    let res;
    if (!id.includes("@")) {
      res = await supabase.auth.signInWithPassword({
        phone: id,
        password,
      });
    } else {
      res = await supabase.auth.signInWithPassword({
        email: id,
        password,
      });
    }

    if (res.error) {
      setError(res.error);
      setMessage(null);
    } else {
      setError(null);
      setMessage(res.data);
    }
  }

  return (
    <div class="flex flex-col gap-4 w-full">
      <div class="flex gap-2">
        <button class="bg-gray-200 px-4 py-2" onClick={() => _github()}>
          GitHub
        </button>
        <button class="bg-gray-200 px-4 py-2" onClick={() => _google()}>
          Google
        </button>
      </div>

      <form
        method="POST"
        class="flex gap-2"
        onSubmit={async (e) => {
          e.preventDefault();
          const form = new FormData(e.target);
          const id = String(form.get("id"));
          const password = String(form.get("password"));

          await signIn({ id, password });
        }}
      >
        <input
          class="bg-gray-100 px-4 py-2"
          type="text"
          name="id"
          placeholder="Phone or Email"
        />
        <input
          class="bg-gray-100 px-4 py-2"
          type="password"
          name="password"
          placeholder="Password"
        />

        <button
          class="bg-gray-500 text-white px-4 py-2"
          type="submit"
        >
          SignIn
        </button>
      </form>

      <div>------ OR ------</div>

      <form
        method="POST"
        class="flex gap-2"
        onSubmit={async (e) => {
          e.stopPropagation();
          e.preventDefault();

          const form = new FormData(e.target);
          const id = form.get("id");
          const password = form.get("password");

          let res;
          if (!id.includes("@")) {
            res = await supabase.auth.signUp({
              phone: id,
              password,
            });
          } else {
            res = await supabase.auth.signUp({
              email: id,
              password,
            });
          }

          if (res.error) {
            setError(res.error);
            setMessage(null);
          } else {
            setError(null);
            setMessage(res.data);
          }

          window._f = form;
          console.log("e", res);

          //supabase.auth.signInWithPassword({  })
        }}
      >
        <input
          class="bg-gray-100 px-4 py-2"
          type="text"
          name="id"
          placeholder="Phone or Email"
        />
        <input
          class="bg-gray-100 px-4 py-2"
          type="password"
          name="password"
          placeholder="Password"
        />

        <button
          class="bg-gray-500 text-white px-4 py-2"
          type="submit"
        >
          SignUp
        </button>
      </form>

      {errorBox}

      {box}

      {msgBox}

      {/* <pre>{JSON.stringify(user, null, 4)}</pre> */}
    </div>
  );
}
