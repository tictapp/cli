import { serve } from 'https://deno.land/std@0.131.0/http/server.ts'
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.5.0"
import { FunctionsClient } from "https://esm.sh/@supabase/functions-js@2.0.0"

import "https://deno.land/std@0.177.0/dotenv/load.ts";

import { corsHeaders } from '../_shared/cors.ts'

const apiUrl = Deno.env.get('SUPABASE_URL')
const funUrl = apiUrl?.replace('.io', '.fun')
const anonKey = Deno.env.get('SUPABASE_ANON_KEY')

console.log(`Function up and running!`, apiUrl)

serve(async (req: Request) => {

  // This is needed if you're planning to invoke your function from a browser.
  if (req.method === 'OPTIONS') {
    return new Response('ok', { headers: corsHeaders })
  }

  try {

    // Create a Supabase client with the Auth context of the logged in user.
    const supabase = createClient(apiUrl, anonKey, { 
      global: { 
        headers: { 
          Authorization: req.headers.get('Authorization')! 
        } 
      } 
    })

    const functions = new FunctionsClient(funUrl, {
        headers: {
          //Authorization: `Bearer ${anonKey}`,
          Authorization: req.headers.get('Authorization')! 
        },
      })
    //functions.setAuth(anonKey)

    //Now we can get the session or user object
    const {
      data: { user },
    } = await supabase.auth.getUser()
    //const user = {}
    console.log('user', user)

    // And we can run queries in the context of our authenticated user
    // const { data, error } = await supabaseClient.from('countries').select('*')
    // if (error) throw error

    const funres = await functions.invoke('post-body', {
        body: user || {},
        headers: {
          "my-secret": "xxx"
        }
    })

    let data = {}

    if (funres.error) {
      data = { error: {
        name: funres.error.name,
        message: funres.error.message
      } }
    } else {
      data = funres.data
    }

    console.log('funres', funres)

    return new Response(JSON.stringify({
      user,
      funres
    }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: funres.error ? 400 : 200,
    })
  } catch (error) {
    console.error(error)
    return new Response(JSON.stringify({ error: error.message }), {
      headers: { ...corsHeaders, 'Content-Type': 'application/json' },
      status: 400,
    })
  }
}, {
   port: 3009
})

// To invoke:
// curl -i --location --request POST 'http://localhost:54321/functions/v1/select-from-table-with-auth-rls' \
//   --header 'Authorization: Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24ifQ.625_WdcF3KHqz5amU0x2X5WWHP-OEs_4qj0ssLNHzTs' \
//   --header 'Content-Type: application/json' \
//   --data '{"name":"Functions"}'