--
-- PostgreSQL database cluster dump
--

SET default_transaction_read_only = off;

SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;

--
-- Roles
--

CREATE ROLE anon;
ALTER ROLE anon WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE authenticated;
ALTER ROLE authenticated WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE authenticator;
ALTER ROLE authenticator WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:ojzuIYXwIyNYXZD1AEAfYQ==$yXJ7aP0t/3KnNMHqgVGQy/TQMFPAt7+uKECuoeiwl00=:nM58pT5oxxJfNqHGWTfnFMXhfNxS2eEzLS9X8ocacII=';
CREATE ROLE dashboard_user;
ALTER ROLE dashboard_user WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB NOLOGIN REPLICATION NOBYPASSRLS;
CREATE ROLE pgbouncer;
ALTER ROLE pgbouncer WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:+0rGYbdoVF2a7E/7QZmVXw==$WSEFzGaN+U4lktADK/w5pxPLETB5AX5+TnyuvS7hqJ4=:mi+P3nVGV8cbV0o4v+wgakVMv2oR43moJSt/D/zTFoA=';
CREATE ROLE pgsodium_keyholder;
ALTER ROLE pgsodium_keyholder WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE pgsodium_keyiduser;
ALTER ROLE pgsodium_keyiduser WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE pgsodium_keymaker;
ALTER ROLE pgsodium_keymaker WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE postgres;
ALTER ROLE postgres WITH NOSUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:KiRnZMhc+S9eGiXnETFiKw==$GFroUZIQhSvKCTr4oX7gZfwg7RQ6PTIK+2+YMRgBXsc=:iC4Q20ehK/e6W8hlxFk64fTE84ensOzBNltOl9egsdM=';
CREATE ROLE service_role;
ALTER ROLE service_role WITH NOSUPERUSER NOINHERIT NOCREATEROLE NOCREATEDB NOLOGIN NOREPLICATION BYPASSRLS;
CREATE ROLE supabase_admin;
ALTER ROLE supabase_admin WITH SUPERUSER INHERIT CREATEROLE CREATEDB LOGIN REPLICATION BYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:rc4mj3JxJ8g+qnDP6zjwxg==$U35GHZRBvTJBFjwh8Mdn+QiMYzKvynLnKVS6rW0l/Jk=:X25LCaQa/lo9DYP1cQoCvHb0MmY3QEUtA21H+JpjLQg=';
CREATE ROLE supabase_auth_admin;
ALTER ROLE supabase_auth_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:y5Je/YpEcDBJApmMhrXjfw==$q8NAhF3o7UJOMbKWS6NcSeqW0osCmXgsujst3Wcx+sY=:BJ1m2FjLFwxfZqBKbgZEwtfW48OHzVx81/vyrjdWfpo=';
CREATE ROLE supabase_functions_admin;
ALTER ROLE supabase_functions_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS;
CREATE ROLE supabase_replication_admin;
ALTER ROLE supabase_replication_admin WITH NOSUPERUSER INHERIT NOCREATEROLE NOCREATEDB LOGIN REPLICATION NOBYPASSRLS;
CREATE ROLE supabase_storage_admin;
ALTER ROLE supabase_storage_admin WITH NOSUPERUSER NOINHERIT CREATEROLE NOCREATEDB LOGIN NOREPLICATION NOBYPASSRLS PASSWORD 'SCRAM-SHA-256$4096:ooFZqpLGzvzfFqBQXoCqwg==$i6KR9h/EBuVk/HkO2yjhXf7Pyrzrt2L+YNNENXPfbHE=:WxsIkSGCAfk9Jrv/QfiYKxuAIeSyIQlIUKxCptM559I=';

--
-- User Configurations
--

--
-- User Config "anon"
--

ALTER ROLE anon SET statement_timeout TO '3s';

--
-- User Config "authenticated"
--

ALTER ROLE authenticated SET statement_timeout TO '8s';

--
-- User Config "authenticator"
--

ALTER ROLE authenticator SET session_preload_libraries TO 'safeupdate';
ALTER ROLE authenticator SET statement_timeout TO '8s';

--
-- User Config "postgres"
--

ALTER ROLE postgres SET search_path TO E'\\$user', 'public', 'extensions';

--
-- User Config "supabase_admin"
--

ALTER ROLE supabase_admin SET search_path TO E'\\$user', 'public', 'auth', 'extensions';

--
-- User Config "supabase_auth_admin"
--

ALTER ROLE supabase_auth_admin SET search_path TO 'auth';
ALTER ROLE supabase_auth_admin SET idle_in_transaction_session_timeout TO '60000';

--
-- User Config "supabase_functions_admin"
--

ALTER ROLE supabase_functions_admin SET search_path TO 'supabase_functions';

--
-- User Config "supabase_storage_admin"
--

ALTER ROLE supabase_storage_admin SET search_path TO 'storage';


--
-- Role memberships
--

GRANT anon TO authenticator GRANTED BY postgres;
GRANT anon TO postgres GRANTED BY supabase_admin;
GRANT authenticated TO authenticator GRANTED BY postgres;
GRANT authenticated TO postgres GRANTED BY supabase_admin;
GRANT pgsodium_keyholder TO pgsodium_keymaker GRANTED BY supabase_admin;
GRANT pgsodium_keyholder TO postgres WITH ADMIN OPTION GRANTED BY supabase_admin;
GRANT pgsodium_keyiduser TO pgsodium_keyholder GRANTED BY supabase_admin;
GRANT pgsodium_keyiduser TO pgsodium_keymaker GRANTED BY supabase_admin;
GRANT pgsodium_keyiduser TO postgres WITH ADMIN OPTION GRANTED BY supabase_admin;
GRANT pgsodium_keymaker TO postgres WITH ADMIN OPTION GRANTED BY supabase_admin;
GRANT service_role TO authenticator GRANTED BY postgres;
GRANT service_role TO postgres GRANTED BY supabase_admin;
GRANT supabase_auth_admin TO postgres GRANTED BY supabase_admin;
GRANT supabase_functions_admin TO postgres GRANTED BY supabase_admin;
GRANT supabase_storage_admin TO postgres GRANTED BY supabase_admin;






--
-- Databases
--

--
-- Database "template1" dump
--

\connect template1

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Debian 15.1-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- PostgreSQL database dump complete
--

--
-- Database "postgres" dump
--

\connect postgres

--
-- PostgreSQL database dump
--

-- Dumped from database version 15.1 (Debian 15.1-1.pgdg110+1)
-- Dumped by pg_dump version 15.2 (Homebrew)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: _realtime; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA _realtime;


ALTER SCHEMA _realtime OWNER TO postgres;

--
-- Name: auth; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA auth;


ALTER SCHEMA auth OWNER TO supabase_admin;

--
-- Name: extensions; Type: SCHEMA; Schema: -; Owner: postgres
--

CREATE SCHEMA extensions;


ALTER SCHEMA extensions OWNER TO postgres;

--
-- Name: graphql; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql;


ALTER SCHEMA graphql OWNER TO supabase_admin;

--
-- Name: graphql_public; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA graphql_public;


ALTER SCHEMA graphql_public OWNER TO supabase_admin;

--
-- Name: pg_net; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_net WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_net; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_net IS 'Async HTTP';


--
-- Name: pgbouncer; Type: SCHEMA; Schema: -; Owner: pgbouncer
--

CREATE SCHEMA pgbouncer;


ALTER SCHEMA pgbouncer OWNER TO pgbouncer;

--
-- Name: pgsodium; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA pgsodium;


ALTER SCHEMA pgsodium OWNER TO supabase_admin;

--
-- Name: pgsodium; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgsodium WITH SCHEMA pgsodium;


--
-- Name: EXTENSION pgsodium; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgsodium IS 'Pgsodium is a modern cryptography library for Postgres.';


--
-- Name: realtime; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA realtime;


ALTER SCHEMA realtime OWNER TO supabase_admin;

--
-- Name: storage; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA storage;


ALTER SCHEMA storage OWNER TO supabase_admin;

--
-- Name: supabase_functions; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA supabase_functions;


ALTER SCHEMA supabase_functions OWNER TO supabase_admin;

--
-- Name: vault; Type: SCHEMA; Schema: -; Owner: supabase_admin
--

CREATE SCHEMA vault;


ALTER SCHEMA vault OWNER TO supabase_admin;

--
-- Name: pg_graphql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_graphql WITH SCHEMA graphql;


--
-- Name: EXTENSION pg_graphql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_graphql IS 'pg_graphql: GraphQL support';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA extensions;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pg_stat_statements IS 'track planning and execution statistics of all SQL statements executed';


--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA extensions;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: pgjwt; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgjwt WITH SCHEMA extensions;


--
-- Name: EXTENSION pgjwt; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgjwt IS 'JSON Web Token API for Postgresql';


--
-- Name: supabase_vault; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS supabase_vault WITH SCHEMA vault;


--
-- Name: EXTENSION supabase_vault; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION supabase_vault IS 'Supabase Vault Extension';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA extensions;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: aal_level; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.aal_level AS ENUM (
    'aal1',
    'aal2',
    'aal3'
);


ALTER TYPE auth.aal_level OWNER TO supabase_auth_admin;

--
-- Name: factor_status; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_status AS ENUM (
    'unverified',
    'verified'
);


ALTER TYPE auth.factor_status OWNER TO supabase_auth_admin;

--
-- Name: factor_type; Type: TYPE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TYPE auth.factor_type AS ENUM (
    'totp',
    'webauthn'
);


ALTER TYPE auth.factor_type OWNER TO supabase_auth_admin;

--
-- Name: email(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.email() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.email', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'email')
  )::text
$$;


ALTER FUNCTION auth.email() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION email(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.email() IS 'Deprecated. Use auth.jwt() -> ''email'' instead.';


--
-- Name: jwt(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.jwt() RETURNS jsonb
    LANGUAGE sql STABLE
    AS $$
  select 
    coalesce(
        nullif(current_setting('request.jwt.claim', true), ''),
        nullif(current_setting('request.jwt.claims', true), '')
    )::jsonb
$$;


ALTER FUNCTION auth.jwt() OWNER TO supabase_auth_admin;

--
-- Name: role(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.role() RETURNS text
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.role', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'role')
  )::text
$$;


ALTER FUNCTION auth.role() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION role(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.role() IS 'Deprecated. Use auth.jwt() -> ''role'' instead.';


--
-- Name: uid(); Type: FUNCTION; Schema: auth; Owner: supabase_auth_admin
--

CREATE FUNCTION auth.uid() RETURNS uuid
    LANGUAGE sql STABLE
    AS $$
  select 
  coalesce(
    nullif(current_setting('request.jwt.claim.sub', true), ''),
    (nullif(current_setting('request.jwt.claims', true), '')::jsonb ->> 'sub')
  )::uuid
$$;


ALTER FUNCTION auth.uid() OWNER TO supabase_auth_admin;

--
-- Name: FUNCTION uid(); Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON FUNCTION auth.uid() IS 'Deprecated. Use auth.jwt() -> ''sub'' instead.';


--
-- Name: grant_pg_cron_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_cron_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  schema_is_cron bool;
BEGIN
  schema_is_cron = (
    SELECT n.nspname = 'cron'
    FROM pg_event_trigger_ddl_commands() AS ev
    LEFT JOIN pg_catalog.pg_namespace AS n
      ON ev.objid = n.oid
  );

  IF schema_is_cron
  THEN
    grant usage on schema cron to postgres with grant option;

    alter default privileges in schema cron grant all on tables to postgres with grant option;
    alter default privileges in schema cron grant all on functions to postgres with grant option;
    alter default privileges in schema cron grant all on sequences to postgres with grant option;

    alter default privileges for user supabase_admin in schema cron grant all
        on sequences to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on tables to postgres with grant option;
    alter default privileges for user supabase_admin in schema cron grant all
        on functions to postgres with grant option;

    grant all privileges on all tables in schema cron to postgres with grant option;

  END IF;

END;
$$;


ALTER FUNCTION extensions.grant_pg_cron_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_cron_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_cron_access() IS 'Grants access to pg_cron';


--
-- Name: grant_pg_graphql_access(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.grant_pg_graphql_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
DECLARE
    func_is_graphql_resolve bool;
BEGIN
    func_is_graphql_resolve = (
        SELECT n.proname = 'resolve'
        FROM pg_event_trigger_ddl_commands() AS ev
        LEFT JOIN pg_catalog.pg_proc AS n
        ON ev.objid = n.oid
    );

    IF func_is_graphql_resolve
    THEN
        -- Update public wrapper to pass all arguments through to the pg_graphql resolve func
        DROP FUNCTION IF EXISTS graphql_public.graphql;
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language sql
        as $$
            select graphql.resolve(
                query := query,
                variables := coalesce(variables, '{}'),
                "operationName" := "operationName",
                extensions := extensions
            );
        $$;

        -- This hook executes when `graphql.resolve` is created. That is not necessarily the last
        -- function in the extension so we need to grant permissions on existing entities AND
        -- update default permissions to any others that are created after `graphql.resolve`
        grant usage on schema graphql to postgres, anon, authenticated, service_role;
        grant select on all tables in schema graphql to postgres, anon, authenticated, service_role;
        grant execute on all functions in schema graphql to postgres, anon, authenticated, service_role;
        grant all on all sequences in schema graphql to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on tables to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on functions to postgres, anon, authenticated, service_role;
        alter default privileges in schema graphql grant all on sequences to postgres, anon, authenticated, service_role;
    END IF;

END;
$_$;


ALTER FUNCTION extensions.grant_pg_graphql_access() OWNER TO supabase_admin;

--
-- Name: FUNCTION grant_pg_graphql_access(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.grant_pg_graphql_access() IS 'Grants access to pg_graphql';


--
-- Name: grant_pg_net_access(); Type: FUNCTION; Schema: extensions; Owner: postgres
--

CREATE FUNCTION extensions.grant_pg_net_access() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
  BEGIN
    IF EXISTS (
      SELECT 1
      FROM pg_event_trigger_ddl_commands() AS ev
      JOIN pg_extension AS ext
      ON ev.objid = ext.oid
      WHERE ext.extname = 'pg_net'
    )
    THEN
      GRANT USAGE ON SCHEMA net TO supabase_functions_admin, postgres;
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SECURITY DEFINER;
      ALTER function net.http_collect_response(request_id bigint, async boolean) SECURITY DEFINER;
      ALTER function net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) SET search_path = net;
      ALTER function net.http_collect_response(request_id bigint, async boolean) SET search_path = net;
      REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
      REVOKE ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) FROM PUBLIC;
      GRANT EXECUTE ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres;
      GRANT EXECUTE ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin, postgres;
      GRANT EXECUTE ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO supabase_functions_admin, postgres;
    END IF;
  END;
  $$;


ALTER FUNCTION extensions.grant_pg_net_access() OWNER TO postgres;

--
-- Name: FUNCTION grant_pg_net_access(); Type: COMMENT; Schema: extensions; Owner: postgres
--

COMMENT ON FUNCTION extensions.grant_pg_net_access() IS 'Grants access to pg_net';


--
-- Name: pgrst_ddl_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_ddl_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  cmd record;
BEGIN
  FOR cmd IN SELECT * FROM pg_event_trigger_ddl_commands()
  LOOP
    IF cmd.command_tag IN (
      'CREATE SCHEMA', 'ALTER SCHEMA'
    , 'CREATE TABLE', 'CREATE TABLE AS', 'SELECT INTO', 'ALTER TABLE'
    , 'CREATE FOREIGN TABLE', 'ALTER FOREIGN TABLE'
    , 'CREATE VIEW', 'ALTER VIEW'
    , 'CREATE MATERIALIZED VIEW', 'ALTER MATERIALIZED VIEW'
    , 'CREATE FUNCTION', 'ALTER FUNCTION'
    , 'CREATE TRIGGER'
    , 'CREATE TYPE', 'ALTER TYPE'
    , 'CREATE RULE'
    , 'COMMENT'
    )
    -- don't notify in case of CREATE TEMP table or other objects created on pg_temp
    AND cmd.schema_name is distinct from 'pg_temp'
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_ddl_watch() OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.pgrst_drop_watch() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $$
DECLARE
  obj record;
BEGIN
  FOR obj IN SELECT * FROM pg_event_trigger_dropped_objects()
  LOOP
    IF obj.object_type IN (
      'schema'
    , 'table'
    , 'foreign table'
    , 'view'
    , 'materialized view'
    , 'function'
    , 'trigger'
    , 'type'
    , 'rule'
    )
    AND obj.is_temporary IS false -- no pg_temp objects
    THEN
      NOTIFY pgrst, 'reload schema';
    END IF;
  END LOOP;
END; $$;


ALTER FUNCTION extensions.pgrst_drop_watch() OWNER TO supabase_admin;

--
-- Name: set_graphql_placeholder(); Type: FUNCTION; Schema: extensions; Owner: supabase_admin
--

CREATE FUNCTION extensions.set_graphql_placeholder() RETURNS event_trigger
    LANGUAGE plpgsql
    AS $_$
    DECLARE
    graphql_is_dropped bool;
    BEGIN
    graphql_is_dropped = (
        SELECT ev.schema_name = 'graphql_public'
        FROM pg_event_trigger_dropped_objects() AS ev
        WHERE ev.schema_name = 'graphql_public'
    );

    IF graphql_is_dropped
    THEN
        create or replace function graphql_public.graphql(
            "operationName" text default null,
            query text default null,
            variables jsonb default null,
            extensions jsonb default null
        )
            returns jsonb
            language plpgsql
        as $$
            DECLARE
                server_version float;
            BEGIN
                server_version = (SELECT (SPLIT_PART((select version()), ' ', 2))::float);

                IF server_version >= 14 THEN
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql extension is not enabled.'
                            )
                        )
                    );
                ELSE
                    RETURN jsonb_build_object(
                        'errors', jsonb_build_array(
                            jsonb_build_object(
                                'message', 'pg_graphql is only available on projects running Postgres 14 onwards.'
                            )
                        )
                    );
                END IF;
            END;
        $$;
    END IF;

    END;
$_$;


ALTER FUNCTION extensions.set_graphql_placeholder() OWNER TO supabase_admin;

--
-- Name: FUNCTION set_graphql_placeholder(); Type: COMMENT; Schema: extensions; Owner: supabase_admin
--

COMMENT ON FUNCTION extensions.set_graphql_placeholder() IS 'Reintroduces placeholder function for graphql_public.graphql';


--
-- Name: get_auth(text); Type: FUNCTION; Schema: pgbouncer; Owner: postgres
--

CREATE FUNCTION pgbouncer.get_auth(p_usename text) RETURNS TABLE(username text, password text)
    LANGUAGE plpgsql SECURITY DEFINER
    AS $$
BEGIN
    RAISE WARNING 'PgBouncer auth request: %', p_usename;

    RETURN QUERY
    SELECT usename::TEXT, passwd::TEXT FROM pg_catalog.pg_shadow
    WHERE usename = p_usename;
END;
$$;


ALTER FUNCTION pgbouncer.get_auth(p_usename text) OWNER TO postgres;

--
-- Name: extension(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.extension(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
_filename text;
BEGIN
    select string_to_array(name, '/') into _parts;
    select _parts[array_length(_parts,1)] into _filename;
    -- @todo return the last part instead of 2
    return split_part(_filename, '.', 2);
END
$$;


ALTER FUNCTION storage.extension(name text) OWNER TO supabase_storage_admin;

--
-- Name: filename(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.filename(name text) RETURNS text
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[array_length(_parts,1)];
END
$$;


ALTER FUNCTION storage.filename(name text) OWNER TO supabase_storage_admin;

--
-- Name: foldername(text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.foldername(name text) RETURNS text[]
    LANGUAGE plpgsql
    AS $$
DECLARE
_parts text[];
BEGIN
    select string_to_array(name, '/') into _parts;
    return _parts[1:array_length(_parts,1)-1];
END
$$;


ALTER FUNCTION storage.foldername(name text) OWNER TO supabase_storage_admin;

--
-- Name: get_size_by_bucket(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.get_size_by_bucket() RETURNS TABLE(size bigint, bucket_id text)
    LANGUAGE plpgsql
    AS $$
BEGIN
    return query
        select sum((metadata->>'size')::int) as size, obj.bucket_id
        from "storage".objects as obj
        group by obj.bucket_id;
END
$$;


ALTER FUNCTION storage.get_size_by_bucket() OWNER TO supabase_storage_admin;

--
-- Name: search(text, text, integer, integer, integer, text, text, text); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.search(prefix text, bucketname text, limits integer DEFAULT 100, levels integer DEFAULT 1, offsets integer DEFAULT 0, search text DEFAULT ''::text, sortcolumn text DEFAULT 'name'::text, sortorder text DEFAULT 'asc'::text) RETURNS TABLE(name text, id uuid, updated_at timestamp with time zone, created_at timestamp with time zone, last_accessed_at timestamp with time zone, metadata jsonb)
    LANGUAGE plpgsql STABLE
    AS $_$
declare
  v_order_by text;
  v_sort_order text;
begin
  case
    when sortcolumn = 'name' then
      v_order_by = 'name';
    when sortcolumn = 'updated_at' then
      v_order_by = 'updated_at';
    when sortcolumn = 'created_at' then
      v_order_by = 'created_at';
    when sortcolumn = 'last_accessed_at' then
      v_order_by = 'last_accessed_at';
    else
      v_order_by = 'name';
  end case;

  case
    when sortorder = 'asc' then
      v_sort_order = 'asc';
    when sortorder = 'desc' then
      v_sort_order = 'desc';
    else
      v_sort_order = 'asc';
  end case;

  v_order_by = v_order_by || ' ' || v_sort_order;

  return query execute
    'with folders as (
       select path_tokens[$1] as folder
       from storage.objects
         where objects.name ilike $2 || $3 || ''%''
           and bucket_id = $4
           and array_length(regexp_split_to_array(objects.name, ''/''), 1) <> $1
       group by folder
       order by folder ' || v_sort_order || '
     )
     (select folder as "name",
            null as id,
            null as updated_at,
            null as created_at,
            null as last_accessed_at,
            null as metadata from folders)
     union all
     (select path_tokens[$1] as "name",
            id,
            updated_at,
            created_at,
            last_accessed_at,
            metadata
     from storage.objects
     where objects.name ilike $2 || $3 || ''%''
       and bucket_id = $4
       and array_length(regexp_split_to_array(objects.name, ''/''), 1) = $1
     order by ' || v_order_by || ')
     limit $5
     offset $6' using levels, prefix, search, bucketname, limits, offsets;
end;
$_$;


ALTER FUNCTION storage.search(prefix text, bucketname text, limits integer, levels integer, offsets integer, search text, sortcolumn text, sortorder text) OWNER TO supabase_storage_admin;

--
-- Name: update_updated_at_column(); Type: FUNCTION; Schema: storage; Owner: supabase_storage_admin
--

CREATE FUNCTION storage.update_updated_at_column() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW; 
END;
$$;


ALTER FUNCTION storage.update_updated_at_column() OWNER TO supabase_storage_admin;

--
-- Name: http_request(); Type: FUNCTION; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE FUNCTION supabase_functions.http_request() RETURNS trigger
    LANGUAGE plpgsql SECURITY DEFINER
    SET search_path TO 'supabase_functions'
    AS $$
    DECLARE
      request_id bigint;
      payload jsonb;
      url text := TG_ARGV[0]::text;
      method text := TG_ARGV[1]::text;
      headers jsonb DEFAULT '{}'::jsonb;
      params jsonb DEFAULT '{}'::jsonb;
      timeout_ms integer DEFAULT 1000;
    BEGIN
      IF url IS NULL OR url = 'null' THEN
        RAISE EXCEPTION 'url argument is missing';
      END IF;
  
      IF method IS NULL OR method = 'null' THEN
        RAISE EXCEPTION 'method argument is missing';
      END IF;
  
      IF TG_ARGV[2] IS NULL OR TG_ARGV[2] = 'null' THEN
        headers = '{"Content-Type": "application/json"}'::jsonb;
      ELSE
        headers = TG_ARGV[2]::jsonb;
      END IF;
  
      IF TG_ARGV[3] IS NULL OR TG_ARGV[3] = 'null' THEN
        params = '{}'::jsonb;
      ELSE
        params = TG_ARGV[3]::jsonb;
      END IF;
  
      IF TG_ARGV[4] IS NULL OR TG_ARGV[4] = 'null' THEN
        timeout_ms = 1000;
      ELSE
        timeout_ms = TG_ARGV[4]::integer;
      END IF;
  
      CASE
        WHEN method = 'GET' THEN
          SELECT http_get INTO request_id FROM net.http_get(
            url,
            params,
            headers,
            timeout_ms
          );
        WHEN method = 'POST' THEN
          payload = jsonb_build_object(
            'old_record', OLD, 
            'record', NEW, 
            'type', TG_OP,
            'table', TG_TABLE_NAME,
            'schema', TG_TABLE_SCHEMA
          );
  
          SELECT http_post INTO request_id FROM net.http_post(
            url,
            payload,
            params,
            headers,
            timeout_ms
          );
        ELSE
          RAISE EXCEPTION 'method argument % is invalid', method;
      END CASE;
  
      INSERT INTO supabase_functions.hooks
        (hook_table_id, hook_name, request_id)
      VALUES
        (TG_RELID, TG_NAME, request_id);
  
      RETURN NEW;
    END
  $$;


ALTER FUNCTION supabase_functions.http_request() OWNER TO supabase_functions_admin;

--
-- Name: secrets_encrypt_secret_secret(); Type: FUNCTION; Schema: vault; Owner: supabase_admin
--

CREATE FUNCTION vault.secrets_encrypt_secret_secret() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
		BEGIN
		        new.secret = CASE WHEN new.secret IS NULL THEN NULL ELSE
			CASE WHEN new.key_id IS NULL THEN NULL ELSE pg_catalog.encode(
			  pgsodium.crypto_aead_det_encrypt(
				pg_catalog.convert_to(new.secret, 'utf8'),
				pg_catalog.convert_to((new.id::text || new.description::text || new.created_at::text || new.updated_at::text)::text, 'utf8'),
				new.key_id::uuid,
				new.nonce
			  ),
				'base64') END END;
		RETURN new;
		END;
		$$;


ALTER FUNCTION vault.secrets_encrypt_secret_secret() OWNER TO supabase_admin;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: extensions; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.extensions (
    id uuid NOT NULL,
    type character varying(255),
    settings jsonb,
    tenant_external_id character varying(255),
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL
);


ALTER TABLE _realtime.extensions OWNER TO supabase_admin;

--
-- Name: schema_migrations; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.schema_migrations (
    version bigint NOT NULL,
    inserted_at timestamp(0) without time zone
);


ALTER TABLE _realtime.schema_migrations OWNER TO supabase_admin;

--
-- Name: tenants; Type: TABLE; Schema: _realtime; Owner: supabase_admin
--

CREATE TABLE _realtime.tenants (
    id uuid NOT NULL,
    name character varying(255),
    external_id character varying(255),
    jwt_secret character varying(500),
    max_concurrent_users integer DEFAULT 200 NOT NULL,
    inserted_at timestamp(0) without time zone NOT NULL,
    updated_at timestamp(0) without time zone NOT NULL,
    max_events_per_second integer DEFAULT 100 NOT NULL,
    postgres_cdc_default character varying(255) DEFAULT 'postgres_cdc_rls'::character varying,
    max_bytes_per_second integer DEFAULT 100000 NOT NULL,
    max_channels_per_client integer DEFAULT 100 NOT NULL,
    max_joins_per_second integer DEFAULT 500 NOT NULL
);


ALTER TABLE _realtime.tenants OWNER TO supabase_admin;

--
-- Name: audit_log_entries; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.audit_log_entries (
    instance_id uuid,
    id uuid NOT NULL,
    payload json,
    created_at timestamp with time zone,
    ip_address character varying(64) DEFAULT ''::character varying NOT NULL
);


ALTER TABLE auth.audit_log_entries OWNER TO supabase_auth_admin;

--
-- Name: TABLE audit_log_entries; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.audit_log_entries IS 'Auth: Audit trail for user actions.';


--
-- Name: identities; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.identities (
    id text NOT NULL,
    user_id uuid NOT NULL,
    identity_data jsonb NOT NULL,
    provider text NOT NULL,
    last_sign_in_at timestamp with time zone,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    email text GENERATED ALWAYS AS (lower((identity_data ->> 'email'::text))) STORED
);


ALTER TABLE auth.identities OWNER TO supabase_auth_admin;

--
-- Name: TABLE identities; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.identities IS 'Auth: Stores identities associated to a user.';


--
-- Name: COLUMN identities.email; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.identities.email IS 'Auth: Email is a generated column that references the optional email property in the identity_data';


--
-- Name: instances; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.instances (
    id uuid NOT NULL,
    uuid uuid,
    raw_base_config text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone
);


ALTER TABLE auth.instances OWNER TO supabase_auth_admin;

--
-- Name: TABLE instances; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.instances IS 'Auth: Manages users across multiple sites.';


--
-- Name: mfa_amr_claims; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_amr_claims (
    session_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    authentication_method text NOT NULL,
    id uuid NOT NULL
);


ALTER TABLE auth.mfa_amr_claims OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_amr_claims; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_amr_claims IS 'auth: stores authenticator method reference claims for multi factor authentication';


--
-- Name: mfa_challenges; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_challenges (
    id uuid NOT NULL,
    factor_id uuid NOT NULL,
    created_at timestamp with time zone NOT NULL,
    verified_at timestamp with time zone,
    ip_address inet NOT NULL
);


ALTER TABLE auth.mfa_challenges OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_challenges; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_challenges IS 'auth: stores metadata about challenge requests made';


--
-- Name: mfa_factors; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.mfa_factors (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    friendly_name text,
    factor_type auth.factor_type NOT NULL,
    status auth.factor_status NOT NULL,
    created_at timestamp with time zone NOT NULL,
    updated_at timestamp with time zone NOT NULL,
    secret text
);


ALTER TABLE auth.mfa_factors OWNER TO supabase_auth_admin;

--
-- Name: TABLE mfa_factors; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.mfa_factors IS 'auth: stores metadata about factors';


--
-- Name: refresh_tokens; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.refresh_tokens (
    instance_id uuid,
    id bigint NOT NULL,
    token character varying(255),
    user_id character varying(255),
    revoked boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    parent character varying(255),
    session_id uuid
);


ALTER TABLE auth.refresh_tokens OWNER TO supabase_auth_admin;

--
-- Name: TABLE refresh_tokens; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.refresh_tokens IS 'Auth: Store of tokens used to refresh JWT tokens once they expire.';


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE; Schema: auth; Owner: supabase_auth_admin
--

CREATE SEQUENCE auth.refresh_tokens_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE auth.refresh_tokens_id_seq OWNER TO supabase_auth_admin;

--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE OWNED BY; Schema: auth; Owner: supabase_auth_admin
--

ALTER SEQUENCE auth.refresh_tokens_id_seq OWNED BY auth.refresh_tokens.id;


--
-- Name: saml_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_providers (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    entity_id text NOT NULL,
    metadata_xml text NOT NULL,
    metadata_url text,
    attribute_mapping jsonb,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "entity_id not empty" CHECK ((char_length(entity_id) > 0)),
    CONSTRAINT "metadata_url not empty" CHECK (((metadata_url = NULL::text) OR (char_length(metadata_url) > 0))),
    CONSTRAINT "metadata_xml not empty" CHECK ((char_length(metadata_xml) > 0))
);


ALTER TABLE auth.saml_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_providers IS 'Auth: Manages SAML Identity Provider connections.';


--
-- Name: saml_relay_states; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.saml_relay_states (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    request_id text NOT NULL,
    for_email text,
    redirect_to text,
    from_ip_address inet,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "request_id not empty" CHECK ((char_length(request_id) > 0))
);


ALTER TABLE auth.saml_relay_states OWNER TO supabase_auth_admin;

--
-- Name: TABLE saml_relay_states; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.saml_relay_states IS 'Auth: Contains SAML Relay State information for each Service Provider initiated login.';


--
-- Name: schema_migrations; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.schema_migrations (
    version character varying(255) NOT NULL
);


ALTER TABLE auth.schema_migrations OWNER TO supabase_auth_admin;

--
-- Name: TABLE schema_migrations; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.schema_migrations IS 'Auth: Manages updates to the auth system.';


--
-- Name: sessions; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sessions (
    id uuid NOT NULL,
    user_id uuid NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    factor_id uuid,
    aal auth.aal_level,
    not_after timestamp with time zone
);


ALTER TABLE auth.sessions OWNER TO supabase_auth_admin;

--
-- Name: TABLE sessions; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sessions IS 'Auth: Stores session data associated to a user.';


--
-- Name: COLUMN sessions.not_after; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sessions.not_after IS 'Auth: Not after is a nullable column that contains a timestamp after which the session should be regarded as expired.';


--
-- Name: sso_domains; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_domains (
    id uuid NOT NULL,
    sso_provider_id uuid NOT NULL,
    domain text NOT NULL,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "domain not empty" CHECK ((char_length(domain) > 0))
);


ALTER TABLE auth.sso_domains OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_domains; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_domains IS 'Auth: Manages SSO email address domain mapping to an SSO Identity Provider.';


--
-- Name: sso_providers; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.sso_providers (
    id uuid NOT NULL,
    resource_id text,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    CONSTRAINT "resource_id not empty" CHECK (((resource_id = NULL::text) OR (char_length(resource_id) > 0)))
);


ALTER TABLE auth.sso_providers OWNER TO supabase_auth_admin;

--
-- Name: TABLE sso_providers; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.sso_providers IS 'Auth: Manages SSO identity provider information; see saml_providers for SAML.';


--
-- Name: COLUMN sso_providers.resource_id; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.sso_providers.resource_id IS 'Auth: Uniquely identifies a SSO provider according to a user-chosen resource ID (case insensitive), useful in infrastructure as code.';


--
-- Name: users; Type: TABLE; Schema: auth; Owner: supabase_auth_admin
--

CREATE TABLE auth.users (
    instance_id uuid,
    id uuid NOT NULL,
    aud character varying(255),
    role character varying(255),
    email character varying(255),
    encrypted_password character varying(255),
    email_confirmed_at timestamp with time zone,
    invited_at timestamp with time zone,
    confirmation_token character varying(255),
    confirmation_sent_at timestamp with time zone,
    recovery_token character varying(255),
    recovery_sent_at timestamp with time zone,
    email_change_token_new character varying(255),
    email_change character varying(255),
    email_change_sent_at timestamp with time zone,
    last_sign_in_at timestamp with time zone,
    raw_app_meta_data jsonb,
    raw_user_meta_data jsonb,
    is_super_admin boolean,
    created_at timestamp with time zone,
    updated_at timestamp with time zone,
    phone text DEFAULT NULL::character varying,
    phone_confirmed_at timestamp with time zone,
    phone_change text DEFAULT ''::character varying,
    phone_change_token character varying(255) DEFAULT ''::character varying,
    phone_change_sent_at timestamp with time zone,
    confirmed_at timestamp with time zone GENERATED ALWAYS AS (LEAST(email_confirmed_at, phone_confirmed_at)) STORED,
    email_change_token_current character varying(255) DEFAULT ''::character varying,
    email_change_confirm_status smallint DEFAULT 0,
    banned_until timestamp with time zone,
    reauthentication_token character varying(255) DEFAULT ''::character varying,
    reauthentication_sent_at timestamp with time zone,
    is_sso_user boolean DEFAULT false NOT NULL,
    deleted_at timestamp with time zone,
    CONSTRAINT users_email_change_confirm_status_check CHECK (((email_change_confirm_status >= 0) AND (email_change_confirm_status <= 2)))
);


ALTER TABLE auth.users OWNER TO supabase_auth_admin;

--
-- Name: TABLE users; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON TABLE auth.users IS 'Auth: Stores user login data within a secure schema.';


--
-- Name: COLUMN users.is_sso_user; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON COLUMN auth.users.is_sso_user IS 'Auth: Set this column to true when the account comes from SSO. These accounts can have duplicate emails.';


--
-- Name: decrypted_secrets; Type: VIEW; Schema: vault; Owner: supabase_admin
--

CREATE VIEW vault.decrypted_secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
        CASE
            WHEN (secrets.secret IS NULL) THEN NULL::text
            ELSE
            CASE
                WHEN (secrets.key_id IS NULL) THEN NULL::text
                ELSE convert_from(pgsodium.crypto_aead_det_decrypt(decode(secrets.secret, 'base64'::text), convert_to(((((secrets.id)::text || secrets.description) || (secrets.created_at)::text) || (secrets.updated_at)::text), 'utf8'::name), secrets.key_id, secrets.nonce), 'utf8'::name)
            END
        END AS decrypted_secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


ALTER TABLE vault.decrypted_secrets OWNER TO supabase_admin;

--
-- Name: decrypted_secrets; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.decrypted_secrets AS
 SELECT decrypted_secrets.id,
    decrypted_secrets.name,
    decrypted_secrets.description,
    decrypted_secrets.secret,
    decrypted_secrets.decrypted_secret,
    decrypted_secrets.key_id,
    decrypted_secrets.nonce,
    decrypted_secrets.created_at,
    decrypted_secrets.updated_at
   FROM vault.decrypted_secrets;


ALTER TABLE public.decrypted_secrets OWNER TO supabase_admin;

--
-- Name: fun_logs; Type: TABLE; Schema: public; Owner: supabase_admin
--

CREATE TABLE public.fun_logs (
    id bigint NOT NULL,
    inserted_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
    data jsonb
);


ALTER TABLE public.fun_logs OWNER TO supabase_admin;

--
-- Name: fun_logs_id_seq; Type: SEQUENCE; Schema: public; Owner: supabase_admin
--

ALTER TABLE public.fun_logs ALTER COLUMN id ADD GENERATED BY DEFAULT AS IDENTITY (
    SEQUENCE NAME public.fun_logs_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1
);


--
-- Name: get_secrets; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.get_secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


ALTER TABLE public.get_secrets OWNER TO supabase_admin;

--
-- Name: secrets; Type: VIEW; Schema: public; Owner: supabase_admin
--

CREATE VIEW public.secrets AS
 SELECT secrets.id,
    secrets.name,
    secrets.description,
    secrets.secret,
    secrets.key_id,
    secrets.nonce,
    secrets.created_at,
    secrets.updated_at
   FROM vault.secrets;


ALTER TABLE public.secrets OWNER TO supabase_admin;

--
-- Name: buckets; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.buckets (
    id text NOT NULL,
    name text NOT NULL,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    public boolean DEFAULT false
);


ALTER TABLE storage.buckets OWNER TO supabase_storage_admin;

--
-- Name: migrations; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.migrations (
    id integer NOT NULL,
    name character varying(100) NOT NULL,
    hash character varying(40) NOT NULL,
    executed_at timestamp without time zone DEFAULT CURRENT_TIMESTAMP
);


ALTER TABLE storage.migrations OWNER TO supabase_storage_admin;

--
-- Name: objects; Type: TABLE; Schema: storage; Owner: supabase_storage_admin
--

CREATE TABLE storage.objects (
    id uuid DEFAULT extensions.uuid_generate_v4() NOT NULL,
    bucket_id text,
    name text,
    owner uuid,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now(),
    last_accessed_at timestamp with time zone DEFAULT now(),
    metadata jsonb,
    path_tokens text[] GENERATED ALWAYS AS (string_to_array(name, '/'::text)) STORED
);


ALTER TABLE storage.objects OWNER TO supabase_storage_admin;

--
-- Name: hooks; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.hooks (
    id bigint NOT NULL,
    hook_table_id integer NOT NULL,
    hook_name text NOT NULL,
    created_at timestamp with time zone DEFAULT now() NOT NULL,
    request_id bigint
);


ALTER TABLE supabase_functions.hooks OWNER TO supabase_functions_admin;

--
-- Name: TABLE hooks; Type: COMMENT; Schema: supabase_functions; Owner: supabase_functions_admin
--

COMMENT ON TABLE supabase_functions.hooks IS 'Supabase Functions Hooks: Audit trail for triggered hooks.';


--
-- Name: hooks_id_seq; Type: SEQUENCE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE SEQUENCE supabase_functions.hooks_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE supabase_functions.hooks_id_seq OWNER TO supabase_functions_admin;

--
-- Name: hooks_id_seq; Type: SEQUENCE OWNED BY; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER SEQUENCE supabase_functions.hooks_id_seq OWNED BY supabase_functions.hooks.id;


--
-- Name: migrations; Type: TABLE; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE TABLE supabase_functions.migrations (
    version text NOT NULL,
    inserted_at timestamp with time zone DEFAULT now() NOT NULL
);


ALTER TABLE supabase_functions.migrations OWNER TO supabase_functions_admin;

--
-- Name: refresh_tokens id; Type: DEFAULT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens ALTER COLUMN id SET DEFAULT nextval('auth.refresh_tokens_id_seq'::regclass);


--
-- Name: hooks id; Type: DEFAULT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks ALTER COLUMN id SET DEFAULT nextval('supabase_functions.hooks_id_seq'::regclass);


--
-- Data for Name: extensions; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.extensions (id, type, settings, tenant_external_id, inserted_at, updated_at) FROM stdin;
e92fb57b-3de4-4be6-b040-2bc19797833e	postgres_cdc_rls	{"region": "us-east-1", "db_host": "QkOt9CmEKA5aWmQKhyKgag==", "db_name": "sWBpZNdjggEPTQVlI52Zfw==", "db_port": "+enMDFi1J/3IrrquHHwUmA==", "db_user": "uxbEq/zz8DXVD53TOI1zmw==", "slot_name": "supabase_realtime_replication_slot", "ip_version": 4, "db_password": "3JLa5g3a2eEJLlV9iGYRAE82uuGZrojyd3by3+a2jj8=", "publication": "supabase_realtime", "poll_interval_ms": 100, "poll_max_changes": 100, "poll_max_record_bytes": 1048576}	realtime-dev	2023-03-04 14:48:42	2023-03-04 14:48:42
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.schema_migrations (version, inserted_at) FROM stdin;
20210706140551	2023-02-24 14:36:18
20220329161857	2023-02-24 14:36:18
20220410212326	2023-02-24 14:36:18
20220506102948	2023-02-24 14:36:18
20220527210857	2023-02-24 14:36:18
20220815211129	2023-02-24 14:36:18
20220815215024	2023-02-24 14:36:18
20220818141501	2023-02-24 14:36:18
20221018173709	2023-02-24 14:36:18
20221102172703	2023-02-24 14:36:18
20221223010058	2023-02-24 14:36:18
20230110180046	2023-02-24 14:36:18
\.


--
-- Data for Name: tenants; Type: TABLE DATA; Schema: _realtime; Owner: supabase_admin
--

COPY _realtime.tenants (id, name, external_id, jwt_secret, max_concurrent_users, inserted_at, updated_at, max_events_per_second, postgres_cdc_default, max_bytes_per_second, max_channels_per_client, max_joins_per_second) FROM stdin;
3078d112-ba7a-4816-a86c-a95719b49e6c	realtime-dev	realtime-dev	E3ZwsWLADg/tXxsvSDcuVTKCurpB/6QTI3N0lqlnIrBT0T16UqtKSBrFU2HE4Ds4	200	2023-03-04 14:48:42	2023-03-04 14:48:42	100	postgres_cdc_rls	100000	100	500
\.


--
-- Data for Name: audit_log_entries; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.audit_log_entries (instance_id, id, payload, created_at, ip_address) FROM stdin;
00000000-0000-0000-0000-000000000000	5a70478d-4a62-4a57-9c52-62ab294dc9bc	{"action":"user_invited","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"ion@tict.app","user_id":"0ca80e2a-9a01-477a-8900-8d9f483e76a1"}}	2023-02-24 15:45:37.967408+00	
00000000-0000-0000-0000-000000000000	c3347032-c44b-42f5-9c2a-cd72a971866c	{"action":"user_confirmation_requested","actor_id":"0ca80e2a-9a01-477a-8900-8d9f483e76a1","actor_username":"ion@tict.app","log_type":"user","traits":{"provider":"email"}}	2023-02-24 15:46:59.377079+00	
00000000-0000-0000-0000-000000000000	968c061a-79a1-4f9d-a093-9c072590c4be	{"action":"user_signedup","actor_id":"0ca80e2a-9a01-477a-8900-8d9f483e76a1","actor_username":"ion@tict.app","log_type":"team"}	2023-02-24 15:47:16.157051+00	
00000000-0000-0000-0000-000000000000	373ffe06-dcae-47bf-a1ba-48e9e6fbeb98	{"action":"user_invited","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"vasile@tict.app","user_id":"9200dab3-1c2c-40a2-9e95-4024d23dd6c3"}}	2023-02-24 16:23:18.102462+00	
00000000-0000-0000-0000-000000000000	9a8c8a4b-30d4-4718-ac7b-6b8121d954cc	{"action":"user_signedup","actor_id":"9200dab3-1c2c-40a2-9e95-4024d23dd6c3","actor_username":"vasile@tict.app","log_type":"team"}	2023-02-24 16:24:03.71903+00	
00000000-0000-0000-0000-000000000000	9624f601-a41d-47b4-82af-21c5fcae5134	{"action":"user_recovery_requested","actor_id":"0ca80e2a-9a01-477a-8900-8d9f483e76a1","actor_username":"ion@tict.app","log_type":"user"}	2023-02-24 17:08:41.663169+00	
00000000-0000-0000-0000-000000000000	afd418e8-3f11-4667-a910-d58c7e175037	{"action":"login","actor_id":"0ca80e2a-9a01-477a-8900-8d9f483e76a1","actor_username":"ion@tict.app","log_type":"account"}	2023-02-24 17:08:54.511152+00	
00000000-0000-0000-0000-000000000000	7e673cf2-4995-441b-b91f-1916760bbc82	{"action":"user_recovery_requested","actor_id":"9200dab3-1c2c-40a2-9e95-4024d23dd6c3","actor_username":"vasile@tict.app","log_type":"user"}	2023-02-24 17:18:42.295536+00	
00000000-0000-0000-0000-000000000000	8810c7ea-9c76-4ba4-8252-defe72f14327	{"action":"login","actor_id":"9200dab3-1c2c-40a2-9e95-4024d23dd6c3","actor_username":"vasile@tict.app","log_type":"account"}	2023-02-24 17:18:57.458653+00	
00000000-0000-0000-0000-000000000000	a139a544-5a94-47d2-8d8d-b96c9eefbce2	{"action":"user_invited","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"ana@tict.app","user_id":"8ea9a6fb-6cb4-4728-baca-105af32f69cf"}}	2023-02-24 17:23:13.375556+00	
00000000-0000-0000-0000-000000000000	ed218316-5799-4885-b386-38858d41c182	{"action":"user_signedup","actor_id":"8ea9a6fb-6cb4-4728-baca-105af32f69cf","actor_username":"ana@tict.app","log_type":"team"}	2023-02-24 17:23:29.190997+00	
00000000-0000-0000-0000-000000000000	d8760fe8-fb29-4fb7-a163-db2bf3a830f8	{"action":"user_recovery_requested","actor_id":"9200dab3-1c2c-40a2-9e95-4024d23dd6c3","actor_username":"vasile@tict.app","log_type":"user"}	2023-03-04 15:09:01.238286+00	
00000000-0000-0000-0000-000000000000	013f0b0b-38e2-4151-85bd-604da1f25ad4	{"action":"login","actor_id":"9200dab3-1c2c-40a2-9e95-4024d23dd6c3","actor_username":"vasile@tict.app","log_type":"account"}	2023-03-04 15:11:36.145481+00	
00000000-0000-0000-0000-000000000000	6dd95cad-ecae-4846-858c-e1030b2764f1	{"action":"user_signedup","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"team","traits":{"provider":"github"}}	2023-03-04 17:37:17.474277+00	
00000000-0000-0000-0000-000000000000	3cbf677f-edd7-4acd-94c4-c0e71a0ca20b	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 17:57:22.467349+00	
00000000-0000-0000-0000-000000000000	82419956-d119-46d8-bba5-6c75d777f9a2	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-04 18:33:15.671691+00	
00000000-0000-0000-0000-000000000000	d6688730-eb2f-4023-89e6-c56734d22386	{"action":"user_invited","actor_id":"00000000-0000-0000-0000-000000000000","actor_username":"service_role","log_type":"team","traits":{"user_email":"aa@tict.app","user_id":"71494f6d-cccc-4c64-b88b-8c645fa56480"}}	2023-03-04 18:43:36.477656+00	
00000000-0000-0000-0000-000000000000	ef85ae5d-a3bd-4e04-ab95-1d47922de28b	{"action":"user_confirmation_requested","actor_id":"71494f6d-cccc-4c64-b88b-8c645fa56480","actor_username":"aa@tict.app","log_type":"user","traits":{"provider":"email"}}	2023-03-04 18:45:17.357034+00	
00000000-0000-0000-0000-000000000000	98276298-a876-444a-8d7b-b9d77b5ba52f	{"action":"user_signedup","actor_id":"71494f6d-cccc-4c64-b88b-8c645fa56480","actor_username":"aa@tict.app","log_type":"team"}	2023-03-04 18:45:34.8739+00	
00000000-0000-0000-0000-000000000000	6cb48ace-9bcf-4e0e-b465-751417ba91c4	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-04 18:46:04.412344+00	
00000000-0000-0000-0000-000000000000	11949386-1596-4260-9240-c644908d279a	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 18:46:29.832022+00	
00000000-0000-0000-0000-000000000000	b46d451c-0213-4a96-ab88-154a196ebf87	{"action":"user_recovery_requested","actor_id":"71494f6d-cccc-4c64-b88b-8c645fa56480","actor_username":"aa@tict.app","log_type":"user"}	2023-03-04 19:06:42.08584+00	
00000000-0000-0000-0000-000000000000	71878c03-60f6-4013-9176-eee74de5838d	{"action":"login","actor_id":"71494f6d-cccc-4c64-b88b-8c645fa56480","actor_username":"aa@tict.app","log_type":"account"}	2023-03-04 19:07:08.714857+00	
00000000-0000-0000-0000-000000000000	319c6bd5-3dd8-42f2-a995-2c4abe292fa8	{"action":"user_recovery_requested","actor_id":"71494f6d-cccc-4c64-b88b-8c645fa56480","actor_username":"aa@tict.app","log_type":"user"}	2023-03-04 19:10:50.323493+00	
00000000-0000-0000-0000-000000000000	16b2d78b-0631-4eb0-9e93-e02c9b19cd53	{"action":"user_recovery_requested","actor_id":"71494f6d-cccc-4c64-b88b-8c645fa56480","actor_username":"aa@tict.app","log_type":"user"}	2023-03-04 19:14:14.081565+00	
00000000-0000-0000-0000-000000000000	ae2a038f-0a07-4c9e-b5bc-7cee2044112b	{"action":"user_recovery_requested","actor_id":"71494f6d-cccc-4c64-b88b-8c645fa56480","actor_username":"aa@tict.app","log_type":"user"}	2023-03-04 19:14:52.795278+00	
00000000-0000-0000-0000-000000000000	e63677b6-2f6e-48f1-a96a-a2b9b36545f2	{"action":"login","actor_id":"71494f6d-cccc-4c64-b88b-8c645fa56480","actor_username":"aa@tict.app","log_type":"account"}	2023-03-04 19:15:57.699107+00	
00000000-0000-0000-0000-000000000000	7e5b1804-c23c-44ad-ade6-2c5e7f270cb4	{"action":"user_confirmation_requested","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"user","traits":{"provider":"email"}}	2023-03-04 19:17:56.895415+00	
00000000-0000-0000-0000-000000000000	65252e1d-01d5-482e-99f1-e664b850e5fc	{"action":"user_signedup","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"team"}	2023-03-04 19:24:43.440774+00	
00000000-0000-0000-0000-000000000000	5ada8941-6a94-4c8e-a2cf-7d8a691cb23a	{"action":"login","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-04 19:25:33.49555+00	
00000000-0000-0000-0000-000000000000	f399afed-0a3c-466f-b7e4-c0a19aa16612	{"action":"user_signedup","actor_id":"63b8784a-74af-4bc2-ba5d-43caf224fae9","actor_name":"Miafosh","actor_username":"miafosh007@gmail.com","log_type":"team","traits":{"provider":"google"}}	2023-03-04 19:26:56.307288+00	
00000000-0000-0000-0000-000000000000	f9cfe6bf-ce94-4647-87ed-5927fd9305ea	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 19:31:38.597069+00	
00000000-0000-0000-0000-000000000000	5228b25e-c2f2-46f8-b1f7-1919f8487c93	{"action":"user_signedup","actor_id":"ea531554-9713-44cb-ac70-2204e9b2b03d","actor_name":"Sergiu Toderascu","actor_username":"sergiu.toderascu@gmail.com","log_type":"team","traits":{"provider":"google"}}	2023-03-04 19:32:01.708226+00	
00000000-0000-0000-0000-000000000000	e3ec9f46-95f6-4550-9a34-683e7d7df046	{"action":"user_confirmation_requested","actor_id":"4665d433-68e0-4c07-ba43-2d2fa0ac0366","actor_username":"40739740662","log_type":"user","traits":{"provider":"phone"}}	2023-03-04 20:45:07.172882+00	
00000000-0000-0000-0000-000000000000	16c4873d-2e27-4906-bd93-4011f3518865	{"action":"user_confirmation_requested","actor_id":"49b20c48-d956-457e-bfbc-bcdbc3d0f0ac","actor_username":"40726398472","log_type":"user","traits":{"provider":"phone"}}	2023-03-04 20:52:59.962275+00	
00000000-0000-0000-0000-000000000000	cb686a37-f02d-40a5-9d88-99b874ef85fb	{"action":"user_confirmation_requested","actor_id":"4665d433-68e0-4c07-ba43-2d2fa0ac0366","actor_username":"40739740662","log_type":"user","traits":{"provider":"phone"}}	2023-03-04 20:54:41.439612+00	
00000000-0000-0000-0000-000000000000	8de71169-07da-4926-be98-1f1ce976a6ee	{"action":"user_confirmation_requested","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"user","traits":{"provider":"phone"}}	2023-03-04 20:56:12.33206+00	
00000000-0000-0000-0000-000000000000	0735d8c4-fd44-4218-994e-fd081fb80405	{"action":"user_signedup","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"team"}	2023-03-04 20:56:40.567257+00	
00000000-0000-0000-0000-000000000000	8a5518d3-50f5-4ec5-b62b-2fa72705293e	{"action":"user_recovery_requested","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"user"}	2023-03-04 20:58:18.284373+00	
00000000-0000-0000-0000-000000000000	857a3fd5-9e42-48f8-b312-f277d50860ff	{"action":"user_signedup","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"team"}	2023-03-04 20:58:58.38576+00	
00000000-0000-0000-0000-000000000000	2ffac95e-97bd-4823-88d7-bc3034b5ab62	{"action":"login","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"account","traits":{"provider":"phone"}}	2023-03-04 21:00:02.432071+00	
00000000-0000-0000-0000-000000000000	5ade19c3-0cb0-4399-82c4-b383439ad4dd	{"action":"login","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"account","traits":{"provider":"phone"}}	2023-03-04 21:04:49.154228+00	
00000000-0000-0000-0000-000000000000	9cf2aa08-98ed-49df-90b7-f93c5b6c3b09	{"action":"login","actor_id":"63b8784a-74af-4bc2-ba5d-43caf224fae9","actor_name":"Miafosh","actor_username":"miafosh007@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-04 21:05:17.145163+00	
00000000-0000-0000-0000-000000000000	640fde55-3e2c-488c-8a4c-ac0f872a5ee4	{"action":"login","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"account","traits":{"provider":"phone"}}	2023-03-04 21:05:33.239934+00	
00000000-0000-0000-0000-000000000000	c7bd83d6-e3ab-4dac-8624-bd55d35a8f35	{"action":"login","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"account","traits":{"provider":"phone"}}	2023-03-04 21:06:35.191817+00	
00000000-0000-0000-0000-000000000000	313c630a-7dbe-4953-906d-99866eb36d82	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:12:17.042663+00	
00000000-0000-0000-0000-000000000000	9cf40171-1ab3-478a-b220-9db34b962d6f	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:12:18.112579+00	
00000000-0000-0000-0000-000000000000	73b6c6dd-0134-4522-ae7e-5f88f6a6cef2	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:12:19.272011+00	
00000000-0000-0000-0000-000000000000	9db93c2d-24e8-46ea-a1d8-131cdbc1292d	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:12:20.39439+00	
00000000-0000-0000-0000-000000000000	697eede4-4d9d-40a7-a300-ae2e2f7829d0	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:12:21.386751+00	
00000000-0000-0000-0000-000000000000	dd138253-85fe-4b45-a224-4316bb16dd69	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:12:22.453089+00	
00000000-0000-0000-0000-000000000000	9dbe28cf-e6b2-4853-be1c-0ffccefcb29c	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:12:23.531864+00	
00000000-0000-0000-0000-000000000000	f52c61af-f108-42e2-bcce-8284df60e5ed	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:12:24.63504+00	
00000000-0000-0000-0000-000000000000	903a13c0-9b00-472d-873a-b55bf4f07bfa	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:12:25.735246+00	
00000000-0000-0000-0000-000000000000	c6b92ac5-5e75-4e18-bb9a-b0588bf72f62	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:13:11.100717+00	
00000000-0000-0000-0000-000000000000	05122a3b-bcdb-4bcb-9532-a4d3a29bcaa5	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:28:42.939883+00	
00000000-0000-0000-0000-000000000000	e4faa37b-880e-466f-87e6-4b86274dab22	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:28:52.948699+00	
00000000-0000-0000-0000-000000000000	2abe25ad-812a-490e-92c5-a889624e64e2	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-04 21:29:50.650451+00	
00000000-0000-0000-0000-000000000000	4cae08d1-a736-43c1-a24a-d3312850c535	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 21:30:19.54109+00	
00000000-0000-0000-0000-000000000000	e4ab305b-d39b-4783-8fb1-7b288958263d	{"action":"login","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-04 22:18:17.118445+00	
00000000-0000-0000-0000-000000000000	3e839afc-6192-4b44-b728-50f42cd6598c	{"action":"login","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"account","traits":{"provider":"phone"}}	2023-03-04 22:22:51.542253+00	
00000000-0000-0000-0000-000000000000	ba451a89-c65d-4cd5-8e86-779a361146fb	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-04 22:24:45.611466+00	
00000000-0000-0000-0000-000000000000	cb80745d-1a40-44bf-8af6-8b20a7d0864f	{"action":"login","actor_id":"63b8784a-74af-4bc2-ba5d-43caf224fae9","actor_name":"Miafosh","actor_username":"miafosh007@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-04 22:31:16.071055+00	
00000000-0000-0000-0000-000000000000	046c521b-ac71-4103-8d92-6a0c97815a80	{"action":"login","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-04 22:31:44.058309+00	
00000000-0000-0000-0000-000000000000	6130c914-9052-4e2a-a200-149d517ed175	{"action":"login","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-04 22:32:13.708449+00	
00000000-0000-0000-0000-000000000000	b83afbe7-8bb1-4af4-868a-a629b64aad19	{"action":"login","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-04 22:32:15.034627+00	
00000000-0000-0000-0000-000000000000	16a09c57-fbe7-4fa3-b044-4c08022dc835	{"action":"user_repeated_signup","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"user","traits":{"provider":"email"}}	2023-03-04 22:40:05.480112+00	
00000000-0000-0000-0000-000000000000	2b57469f-87a7-49e9-bdf9-b392ce594bef	{"action":"user_confirmation_requested","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"user","traits":{"provider":"email"}}	2023-03-04 22:40:39.532785+00	
00000000-0000-0000-0000-000000000000	91d9cacf-7503-4064-b6bd-8fcbb1baeb84	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-04 22:41:50.154377+00	
00000000-0000-0000-0000-000000000000	50a68c41-241f-49f0-b559-2952a6717cea	{"action":"user_signedup","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"team"}	2023-03-04 22:42:45.718645+00	
00000000-0000-0000-0000-000000000000	33180c27-9443-4770-9682-391d2615575b	{"action":"token_refreshed","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"token"}	2023-03-04 22:43:03.540181+00	
00000000-0000-0000-0000-000000000000	0d79ffe0-7e45-4beb-ba8f-c54c9145abdf	{"action":"token_revoked","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"token"}	2023-03-04 22:43:03.541182+00	
00000000-0000-0000-0000-000000000000	da6907a2-6d14-4e5d-9e61-acf460c98d7d	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 22:43:11.823873+00	
00000000-0000-0000-0000-000000000000	f145e124-bfc3-454a-b57a-57ab007e4192	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-04 22:44:20.347349+00	
00000000-0000-0000-0000-000000000000	63317ba3-1709-48b6-b5d9-6ca4b0e9be59	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-04 22:44:27.193369+00	
00000000-0000-0000-0000-000000000000	a77d24e1-4dbc-4090-a975-aae44e95649d	{"action":"login","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-04 22:44:40.944815+00	
00000000-0000-0000-0000-000000000000	24795d1c-02f8-4a12-bb61-ae2b3cab09e7	{"action":"user_confirmation_requested","actor_id":"d147b95f-17a0-4d18-b481-d1d53a67500a","actor_username":"w@tict.app","log_type":"user","traits":{"provider":"email"}}	2023-03-04 22:44:57.42355+00	
00000000-0000-0000-0000-000000000000	7b943729-1623-48f2-a506-898ae5562b96	{"action":"user_signedup","actor_id":"d147b95f-17a0-4d18-b481-d1d53a67500a","actor_username":"w@tict.app","log_type":"team"}	2023-03-04 22:45:15.50516+00	
00000000-0000-0000-0000-000000000000	7eea1c43-305d-46be-9d05-65c68eedd0ed	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-04 22:45:26.476212+00	
00000000-0000-0000-0000-000000000000	86723c67-6837-4d15-b3cb-41f48f87920e	{"action":"token_refreshed","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-04 23:44:57.474066+00	
00000000-0000-0000-0000-000000000000	66a49f21-4116-4f69-af9c-f6cfa764de45	{"action":"token_revoked","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-04 23:44:57.474548+00	
00000000-0000-0000-0000-000000000000	dcf6a83e-76ed-4b9f-b136-7a7dfdd75f27	{"action":"token_refreshed","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-04 23:55:39.882727+00	
00000000-0000-0000-0000-000000000000	8c90af04-27f1-49ef-9fc3-c1ef5182d30b	{"action":"token_revoked","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-04 23:55:39.884008+00	
00000000-0000-0000-0000-000000000000	555afa87-f2af-40ea-b180-fc655bbb04e5	{"action":"token_refreshed","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-05 00:48:17.68349+00	
00000000-0000-0000-0000-000000000000	c157f481-6888-4d84-b143-13fc8f4cf6d3	{"action":"token_revoked","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-05 00:48:17.684393+00	
00000000-0000-0000-0000-000000000000	7a0d1821-2ee5-4523-a7f0-d82deb4ba4da	{"action":"login","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-05 00:51:02.460944+00	
00000000-0000-0000-0000-000000000000	f7e87a71-55e4-453a-bd65-b8b3aba352c0	{"action":"user_modified","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"user"}	2023-03-05 00:53:01.453316+00	
00000000-0000-0000-0000-000000000000	0e0f064f-6e24-4dc5-b2d0-89caa2521706	{"action":"user_modified","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"user"}	2023-03-05 01:00:43.764077+00	
00000000-0000-0000-0000-000000000000	544d49e3-3e20-48fc-b85b-139b84a3e788	{"action":"token_refreshed","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-05 04:07:18.883686+00	
00000000-0000-0000-0000-000000000000	b160d4f4-0934-4e26-88ca-92a8807741aa	{"action":"token_revoked","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-05 04:07:18.884128+00	
00000000-0000-0000-0000-000000000000	53dcb317-a3d5-4f2f-8dc3-5369a01aa5fc	{"action":"token_refreshed","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"token"}	2023-03-05 04:07:32.983294+00	
00000000-0000-0000-0000-000000000000	f707dff2-36be-46c6-976f-7993446a0914	{"action":"token_revoked","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"token"}	2023-03-05 04:07:32.984476+00	
00000000-0000-0000-0000-000000000000	245e633a-bff5-4cd4-aa26-8a47ed03a9b3	{"action":"login","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-05 04:09:10.739717+00	
00000000-0000-0000-0000-000000000000	ea8073fa-7638-4d2d-9850-274ecbf760dd	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-05 04:09:17.085054+00	
00000000-0000-0000-0000-000000000000	921d180f-8ee4-4ca6-bb91-f28d0984d13b	{"action":"login","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-05 04:18:24.9028+00	
00000000-0000-0000-0000-000000000000	b174cd74-00b6-4ef0-bbef-cc16ecee21d0	{"action":"user_modified","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"user"}	2023-03-05 04:19:04.956651+00	
00000000-0000-0000-0000-000000000000	c2d7f896-b4be-41c9-b7df-a4abf9175592	{"action":"login","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-05 04:19:25.067024+00	
00000000-0000-0000-0000-000000000000	e89c08f3-0529-4f97-9a77-8a5dd1131bf7	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-05 04:19:38.279089+00	
00000000-0000-0000-0000-000000000000	cfd6a763-3159-4aff-98d7-63a3a2dae7e0	{"action":"login","actor_id":"63b8784a-74af-4bc2-ba5d-43caf224fae9","actor_name":"Miafosh","actor_username":"miafosh007@gmail.com","log_type":"account","traits":{"provider":"google"}}	2023-03-05 04:19:58.896864+00	
00000000-0000-0000-0000-000000000000	498bbba3-102e-49f9-ba6d-8e866ce0b148	{"action":"login","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"account","traits":{"provider":"email"}}	2023-03-05 04:20:01.312764+00	
00000000-0000-0000-0000-000000000000	45f3bbcc-4a6c-441c-9240-353cfb8d4c89	{"action":"user_modified","actor_id":"985ea5d5-bdcf-480e-aa62-a35f09268c00","actor_username":"y@tict.app","log_type":"user"}	2023-03-05 04:20:28.967648+00	
00000000-0000-0000-0000-000000000000	c2dcab2c-b99f-4e60-8ba8-7308c060655c	{"action":"login","actor_id":"c1136610-2233-4623-a9db-a9976d8d6726","actor_username":"40739740662","log_type":"account","traits":{"provider":"phone"}}	2023-03-05 04:23:55.42758+00	
00000000-0000-0000-0000-000000000000	e80df2d9-2b6d-4944-a0aa-422e6fbae0d6	{"action":"login","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"account","traits":{"provider":"github"}}	2023-03-05 04:24:30.388917+00	
00000000-0000-0000-0000-000000000000	8e0734fe-4eab-4542-9499-84e2834cb8b4	{"action":"token_refreshed","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-05 05:43:18.913841+00	
00000000-0000-0000-0000-000000000000	c97ed9fe-ca9b-4dcd-8062-04ab77b19509	{"action":"token_revoked","actor_id":"404180d2-0f86-498b-b57f-77740b09d684","actor_name":"Mr Serebano","actor_username":"mr.serebano@gmail.com","log_type":"token"}	2023-03-05 05:43:18.914351+00	
00000000-0000-0000-0000-000000000000	3faa77af-2d62-4e31-8cff-7336b9bf2a44	{"action":"token_refreshed","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"token"}	2023-03-05 11:56:10.285451+00	
00000000-0000-0000-0000-000000000000	1bffab74-53ad-47b1-90ff-66c43e40c363	{"action":"token_revoked","actor_id":"5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1","actor_username":"z@tict.app","log_type":"token"}	2023-03-05 11:56:10.285938+00	
\.


--
-- Data for Name: identities; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.identities (id, user_id, identity_data, provider, last_sign_in_at, created_at, updated_at) FROM stdin;
0ca80e2a-9a01-477a-8900-8d9f483e76a1	0ca80e2a-9a01-477a-8900-8d9f483e76a1	{"sub": "0ca80e2a-9a01-477a-8900-8d9f483e76a1", "email": "ion@tict.app"}	email	2023-02-24 15:45:37.966388+00	2023-02-24 15:45:37.966408+00	2023-02-24 15:45:37.966408+00
9200dab3-1c2c-40a2-9e95-4024d23dd6c3	9200dab3-1c2c-40a2-9e95-4024d23dd6c3	{"sub": "9200dab3-1c2c-40a2-9e95-4024d23dd6c3", "email": "vasile@tict.app"}	email	2023-02-24 16:23:18.101776+00	2023-02-24 16:23:18.101804+00	2023-02-24 16:23:18.101804+00
71494f6d-cccc-4c64-b88b-8c645fa56480	71494f6d-cccc-4c64-b88b-8c645fa56480	{"sub": "71494f6d-cccc-4c64-b88b-8c645fa56480", "email": "aa@tict.app"}	email	2023-03-04 18:43:36.477115+00	2023-03-04 18:43:36.477135+00	2023-03-04 18:43:36.477135+00
d147b95f-17a0-4d18-b481-d1d53a67500a	d147b95f-17a0-4d18-b481-d1d53a67500a	{"sub": "d147b95f-17a0-4d18-b481-d1d53a67500a", "email": "w@tict.app"}	email	2023-03-04 22:44:57.422779+00	2023-03-04 22:44:57.42281+00	2023-03-04 22:44:57.42281+00
5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	{"sub": "5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1", "email": "z@tict.app"}	email	2023-03-04 19:17:56.894682+00	2023-03-04 19:17:56.894707+00	2023-03-04 19:17:56.894707+00
106676535335197892675	ea531554-9713-44cb-ac70-2204e9b2b03d	{"iss": "https://www.googleapis.com/userinfo/v2/me", "sub": "106676535335197892675", "name": "Sergiu Toderascu", "email": "sergiu.toderascu@gmail.com", "picture": "https://lh3.googleusercontent.com/a/AGNmyxYdn5xxMS1ZtijeAuOL2f5Kx30vo108sfD99ougPk8=s96-c", "full_name": "Sergiu Toderascu", "avatar_url": "https://lh3.googleusercontent.com/a/AGNmyxYdn5xxMS1ZtijeAuOL2f5Kx30vo108sfD99ougPk8=s96-c", "provider_id": "106676535335197892675", "email_verified": true}	google	2023-03-04 19:32:01.706858+00	2023-03-04 19:32:01.706879+00	2023-03-04 19:32:01.706879+00
c1136610-2233-4623-a9db-a9976d8d6726	c1136610-2233-4623-a9db-a9976d8d6726	{"sub": "c1136610-2233-4623-a9db-a9976d8d6726"}	phone	2023-03-04 20:56:12.331245+00	2023-03-04 20:56:12.331284+00	2023-03-04 20:56:12.331284+00
110271665939628471920	404180d2-0f86-498b-b57f-77740b09d684	{"iss": "https://www.googleapis.com/userinfo/v2/me", "sub": "110271665939628471920", "name": "Mr Serebano", "email": "mr.serebano@gmail.com", "picture": "https://lh3.googleusercontent.com/a/AGNmyxYvINb-8pzHefrEdZizNfFIXQZ64h0niZH-wKGZkmU=s96-c", "full_name": "Mr Serebano", "avatar_url": "https://lh3.googleusercontent.com/a/AGNmyxYvINb-8pzHefrEdZizNfFIXQZ64h0niZH-wKGZkmU=s96-c", "provider_id": "110271665939628471920", "email_verified": true}	google	2023-03-04 18:33:15.66984+00	2023-03-04 18:33:15.669862+00	2023-03-05 04:19:38.276614+00
985ea5d5-bdcf-480e-aa62-a35f09268c00	985ea5d5-bdcf-480e-aa62-a35f09268c00	{"sub": "985ea5d5-bdcf-480e-aa62-a35f09268c00", "email": "y@tict.app"}	email	2023-03-04 22:40:39.53213+00	2023-03-04 22:40:39.532151+00	2023-03-04 22:40:39.532151+00
100196046488372331425	63b8784a-74af-4bc2-ba5d-43caf224fae9	{"iss": "https://www.googleapis.com/userinfo/v2/me", "sub": "100196046488372331425", "name": "Miafosh", "email": "miafosh007@gmail.com", "picture": "https://lh3.googleusercontent.com/a/AGNmyxZf8KL_FBnazJ871-HibgjFqc9PvXrhVg5OwtYd=s96-c", "full_name": "Miafosh", "avatar_url": "https://lh3.googleusercontent.com/a/AGNmyxZf8KL_FBnazJ871-HibgjFqc9PvXrhVg5OwtYd=s96-c", "provider_id": "100196046488372331425", "email_verified": true}	google	2023-03-04 19:26:56.305924+00	2023-03-04 19:26:56.305951+00	2023-03-05 04:19:58.896027+00
1105775	404180d2-0f86-498b-b57f-77740b09d684	{"iss": "https://api.github.com", "sub": "1105775", "name": "Mr Serebano", "email": "mr.serebano@gmail.com", "full_name": "Mr Serebano", "user_name": "serebano", "avatar_url": "https://avatars.githubusercontent.com/u/1105775?v=4", "provider_id": "1105775", "email_verified": true, "preferred_username": "serebano"}	github	2023-03-04 17:37:17.466634+00	2023-03-04 17:37:17.466677+00	2023-03-05 04:24:30.387722+00
\.


--
-- Data for Name: instances; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.instances (id, uuid, raw_base_config, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: mfa_amr_claims; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_amr_claims (session_id, created_at, updated_at, authentication_method, id) FROM stdin;
5b66ab6e-77ba-428b-8ad7-654356f2af38	2023-02-24 15:47:16.163048+00	2023-02-24 15:47:16.163048+00	otp	c85b7b70-d5cb-4a20-b8a9-3aa935315b4a
e4233cbe-a263-4763-b889-ad84d92b8788	2023-02-24 16:24:03.722936+00	2023-02-24 16:24:03.722936+00	otp	03a9ee92-64c8-4537-9963-a47b0031520f
abe4e181-3a83-406b-825d-8242d72be95f	2023-02-24 17:08:54.5193+00	2023-02-24 17:08:54.5193+00	otp	18f7a0b9-f11c-42eb-be10-08be2180c9c0
8067cbb0-87db-4f31-9460-0b0cf6d8d0ac	2023-02-24 17:18:57.466557+00	2023-02-24 17:18:57.466557+00	otp	9d988c9c-ec0a-49b4-8a68-c5ffd661d6cd
59b9f3a7-3f39-4640-a184-72844529c312	2023-03-04 15:11:36.162694+00	2023-03-04 15:11:36.162694+00	otp	649d40a5-10ea-4e68-9667-b8b58c18a872
05af2f9f-5908-43e1-b66f-dc446e623fa9	2023-03-04 17:37:17.479173+00	2023-03-04 17:37:17.479173+00	oauth	a9a12f14-3610-4fbf-8a30-9f8834985b65
7e6d9c2b-4d1e-450e-b69b-4c3c6707d1d3	2023-03-04 17:57:22.474879+00	2023-03-04 17:57:22.474879+00	oauth	bed5a7a4-110f-4a4f-be4f-c822f6a405d3
5ceebd34-453b-4fc9-a31d-0aae5fbdd0ec	2023-03-04 18:33:15.674746+00	2023-03-04 18:33:15.674746+00	oauth	2d5c5dc3-6cff-42ba-807b-fbe079e2632d
e91faf8e-c2cf-40bd-a8da-eb8aea163306	2023-03-04 18:45:34.877224+00	2023-03-04 18:45:34.877224+00	otp	608585ba-f55d-4872-8360-4e1e8fee6318
4172dfa0-6c56-48e2-bf51-6c4c5c9406cd	2023-03-04 18:46:04.418159+00	2023-03-04 18:46:04.418159+00	oauth	6df37a6c-461d-44ec-bf4d-360e60c9ddd2
3df498ba-dfcf-4fd8-a6c9-16eec6b12f6d	2023-03-04 18:46:29.837053+00	2023-03-04 18:46:29.837053+00	oauth	e05ee444-26d6-49e1-802d-8f9bbbd02264
d66208aa-524e-458d-89f0-68aa9b8f7a91	2023-03-04 19:07:08.717064+00	2023-03-04 19:07:08.717064+00	otp	c0102865-475f-4a33-8de1-0161465e49bb
41c2b47f-38b0-43e2-b9a4-67ed2249c689	2023-03-04 19:15:57.702761+00	2023-03-04 19:15:57.702761+00	otp	6892d26b-f5f6-47ae-8db5-52cc7e6fdd1c
3cb7b467-9597-4c1d-8d5a-1e41b8d18fd6	2023-03-04 19:24:43.447233+00	2023-03-04 19:24:43.447233+00	otp	bdf44eb3-d548-426d-9046-cee9fa60212d
fb3181b1-14ca-447a-bb4a-89ececcc45e1	2023-03-04 19:25:33.498074+00	2023-03-04 19:25:33.498074+00	password	91f8a7a6-6361-4928-9d09-057ad8a2e5b1
f56fa1d6-defe-4ca8-9ba0-dcf2c05d4e6d	2023-03-04 19:26:56.318315+00	2023-03-04 19:26:56.318315+00	oauth	bd5562d3-fbed-4545-9f1b-99df4c4c0352
82f49001-546b-4593-8515-e2b4249fded6	2023-03-04 19:31:38.601936+00	2023-03-04 19:31:38.601936+00	oauth	ed8f951c-92ae-49ac-9c25-feb30e3f4755
687aed6f-1923-49cc-a4d1-ace9fde0e5c1	2023-03-04 19:32:01.710777+00	2023-03-04 19:32:01.710777+00	oauth	59c969e3-443a-466e-9d4c-e4ec2f7085ab
202d5555-58c1-4e72-b69c-301419ad1c5d	2023-03-04 20:56:40.577501+00	2023-03-04 20:56:40.577501+00	otp	dacd9c6a-4f39-40e1-b0c8-9daae9890b60
4833e51c-0ff3-42d2-b984-015b1647f81b	2023-03-04 20:58:58.391695+00	2023-03-04 20:58:58.391695+00	otp	6bbe8e3d-00ec-40de-8229-4f09c289f734
6b21357c-0c5c-4e8a-834e-11134b9c671e	2023-03-04 21:00:02.434066+00	2023-03-04 21:00:02.434066+00	password	4de88ad2-938e-4226-8566-2d2949467b34
e4fade3d-8507-46f0-9be8-870b73a7ceb8	2023-03-04 21:04:49.157595+00	2023-03-04 21:04:49.157595+00	password	8cb1a72d-19ec-4cff-88aa-142843aab7f3
819ec7a1-2b16-4a6c-b90f-cad7f42550a8	2023-03-04 21:05:17.150708+00	2023-03-04 21:05:17.150708+00	oauth	7e019762-3e20-4675-9390-61de61a0e298
75ae2d9e-809f-4dd0-be49-eb41c2a10950	2023-03-04 21:05:33.243341+00	2023-03-04 21:05:33.243341+00	password	24bcd94b-2795-446d-b8d9-f09bda53d47d
d5a986d7-f295-4281-a3c8-d388c5d8ed97	2023-03-04 21:06:35.195221+00	2023-03-04 21:06:35.195221+00	password	10106fbc-e9b6-43d2-ada3-1a71d56964c7
0f2bf2f2-747b-4a8c-8684-9179089beaae	2023-03-04 21:12:17.046794+00	2023-03-04 21:12:17.046794+00	oauth	72b013ff-bb60-4563-a351-8c1c6c2b0bf8
dab685fe-7819-49df-b25d-e4c3ac5ef859	2023-03-04 21:12:18.11559+00	2023-03-04 21:12:18.11559+00	oauth	89b2bcbe-037a-4bc3-844c-1dc8a789dc6c
fdf345b7-a012-48de-88d5-582ce5de2620	2023-03-04 21:12:19.27714+00	2023-03-04 21:12:19.27714+00	oauth	88b88b45-fbc7-4879-a766-067f8286b47b
d28ad8e3-09a5-48b2-8654-6a54020c072c	2023-03-04 21:12:20.396906+00	2023-03-04 21:12:20.396906+00	oauth	03c57432-f3ca-4b1a-be5c-b0e9f4386b6f
07d93b68-48c5-412f-8e2e-c4654030960e	2023-03-04 21:12:21.391573+00	2023-03-04 21:12:21.391573+00	oauth	aa5ec7b8-2ed1-4d55-bc25-4398d6d0d495
17585296-2a9d-4722-a70d-0bd28f25e197	2023-03-04 21:12:22.457534+00	2023-03-04 21:12:22.457534+00	oauth	24a4002d-23b7-4f19-b6bd-bfe3a50db131
5f7053ff-d508-4f76-a358-ee27303995bf	2023-03-04 21:12:23.536381+00	2023-03-04 21:12:23.536381+00	oauth	47eb283b-59b6-4d0e-a960-1ec41b49f48d
b9af0799-6282-4c0b-9a8f-2becd6797524	2023-03-04 21:12:24.639076+00	2023-03-04 21:12:24.639076+00	oauth	c44b12fb-3d84-4d03-a13a-bfbd099d0c2c
ffc4f04b-41b1-46f5-b679-db119ba4eb24	2023-03-04 21:12:25.739979+00	2023-03-04 21:12:25.739979+00	oauth	2e4fdd37-5ba6-41c8-bf65-a95fa2e14281
e62c98b6-a344-4749-926c-aeeab646a864	2023-03-04 21:13:11.106114+00	2023-03-04 21:13:11.106114+00	oauth	9eaa700a-6163-4c92-a15d-24f16dfd5b1b
1766f376-fc69-4335-9fe8-71bd9ebd71cc	2023-03-04 21:28:42.945004+00	2023-03-04 21:28:42.945004+00	oauth	b228965e-033f-48da-9c1c-e4eccaccb4dd
c6fc9754-7c75-49a7-bb88-ed84e1e707c1	2023-03-04 21:28:52.954266+00	2023-03-04 21:28:52.954266+00	oauth	7c09c3b8-2a16-4c94-b280-1b75e2107b6a
acdd3ea8-191b-4101-99c8-f99bc4fa8dab	2023-03-04 21:29:50.657456+00	2023-03-04 21:29:50.657456+00	oauth	a837bb80-5aa9-4ced-98bd-d2c73f9d16b2
8a2eded7-1b4d-4cd6-bf3f-f69741f80dcb	2023-03-04 21:30:19.544002+00	2023-03-04 21:30:19.544002+00	oauth	739556ed-646c-45ed-be54-ae64810862d5
d62127aa-0364-43fe-bbf5-54a8a3d7cd76	2023-03-04 22:18:17.120499+00	2023-03-04 22:18:17.120499+00	password	c83a006d-7804-4ac8-97b2-b3b7ce75e3cc
8c1687f3-6122-416d-80b3-2753261c47d9	2023-03-04 22:22:51.544875+00	2023-03-04 22:22:51.544875+00	password	5f4a7949-737b-4f00-bc65-d1d62c152897
e4a11ff6-1100-4381-ae25-d194e9e6d509	2023-03-04 22:24:45.616369+00	2023-03-04 22:24:45.616369+00	oauth	82feaca0-76f0-462c-a453-8a915ecc88f0
66c006bc-a8e5-43ac-8946-235e7c70557e	2023-03-04 22:31:16.075897+00	2023-03-04 22:31:16.075897+00	oauth	7fdf712a-feec-40bd-acd6-79e06204a268
6bab8cfe-d22e-4514-95a8-5b202a32a0f1	2023-03-04 22:31:44.060481+00	2023-03-04 22:31:44.060481+00	password	aa45c94a-3188-4e6a-8bf8-4614578e04df
eafd5cca-a38a-4e93-b893-c8c58551f5c9	2023-03-04 22:32:13.711217+00	2023-03-04 22:32:13.711217+00	password	d702ee8c-c650-4f3f-9dca-f743defdeeca
fb80f883-666c-49a8-aa6d-e3fc70a7b1bb	2023-03-04 22:32:15.03764+00	2023-03-04 22:32:15.03764+00	password	d34e9503-bc62-4465-932d-4a94463da8be
5cd9a52c-138c-4f52-8ec4-2c107f83695c	2023-03-04 22:41:50.158165+00	2023-03-04 22:41:50.158165+00	oauth	bb371ff4-f95e-4b33-afb3-d742cc1fe3bf
a3059898-06e3-4baf-acac-256a41a9e159	2023-03-04 22:42:45.724741+00	2023-03-04 22:42:45.724741+00	otp	524f0a1f-8740-4d5d-8a9d-b0a2b57e3ca1
103f2074-fdd9-4499-a35f-9505ecf2a81f	2023-03-04 22:43:11.827264+00	2023-03-04 22:43:11.827264+00	oauth	41630026-f9be-4ce2-bfd0-f4d9e683ed32
00344e57-8d30-4a3d-858d-bf12c3982585	2023-03-04 22:44:20.353645+00	2023-03-04 22:44:20.353645+00	oauth	5a678311-e4d5-476d-89ec-ee65d5bfe92c
5913fad4-f7fb-456b-8daf-bfa2cf87800a	2023-03-04 22:44:27.195167+00	2023-03-04 22:44:27.195167+00	oauth	8f033248-db7f-490c-85e6-7b9b6dc71388
4f8e6f98-2d60-4aaf-8d59-2d2aefaf8926	2023-03-04 22:44:40.94731+00	2023-03-04 22:44:40.94731+00	password	74fc0de1-98ae-4493-b9d1-da9953b7011b
af6ffaba-7cee-4185-baee-4bc37b73aad4	2023-03-04 22:45:15.507734+00	2023-03-04 22:45:15.507734+00	otp	1b93adc1-b670-406a-8097-907f3493d16d
5f4810de-a455-430c-9e11-4e26cd03e7a0	2023-03-04 22:45:26.481535+00	2023-03-04 22:45:26.481535+00	oauth	fe5efe0d-8db0-4e52-a139-e9ee97ff494b
6386ee01-2a73-4e37-b145-8609e3a57a4b	2023-03-05 00:51:02.462889+00	2023-03-05 00:51:02.462889+00	password	a326f0c0-90c3-48cb-a712-a6992533a6bf
9a6e1dc4-9b3f-4095-b718-60ac4c7c393e	2023-03-05 04:09:10.741993+00	2023-03-05 04:09:10.741993+00	password	c7ce8e41-a899-46f0-ada1-886d08d263f0
37bf6806-c076-45be-83d2-b1512cdcfbb0	2023-03-05 04:09:17.086954+00	2023-03-05 04:09:17.086954+00	oauth	46388e24-7d0f-4232-a3a4-bde1d82bbd37
575260f4-6efb-4cff-93b0-629bf34bf5b3	2023-03-05 04:18:24.904994+00	2023-03-05 04:18:24.904994+00	password	faea2d13-0add-4a4e-8a2d-e462359679e7
6e928f5e-d47f-4b6c-b83d-b83345a264c3	2023-03-05 04:19:25.069553+00	2023-03-05 04:19:25.069553+00	password	e7fbf6e6-cdc3-4c74-8629-599d92d93e56
004b3692-49d0-4830-b3a1-c83d3f49bf50	2023-03-05 04:19:38.283824+00	2023-03-05 04:19:38.283824+00	oauth	28fbdbbc-45ba-49a3-882f-041b20a4211d
f6833906-5db9-4731-8c0d-7faef363ff49	2023-03-05 04:19:58.898512+00	2023-03-05 04:19:58.898512+00	oauth	0fca1a61-5f37-4c19-9322-ddda0fb58ae6
3e482f3c-f159-4c53-ad1f-9337df7a9aa5	2023-03-05 04:20:01.314789+00	2023-03-05 04:20:01.314789+00	password	8a14abc6-a004-44d0-8ade-1e42166015b2
13a634d5-dea4-44ff-b119-ed6a9c73c3ba	2023-03-05 04:23:55.430079+00	2023-03-05 04:23:55.430079+00	password	935eec6c-4a1b-4ec6-8784-2128de178087
550bae05-3874-4cb1-b45e-a88472238f16	2023-03-05 04:24:30.390655+00	2023-03-05 04:24:30.390655+00	oauth	2a60cf20-e0da-4830-a7c9-9f6fa5098254
\.


--
-- Data for Name: mfa_challenges; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_challenges (id, factor_id, created_at, verified_at, ip_address) FROM stdin;
\.


--
-- Data for Name: mfa_factors; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.mfa_factors (id, user_id, friendly_name, factor_type, status, created_at, updated_at, secret) FROM stdin;
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.refresh_tokens (instance_id, id, token, user_id, revoked, created_at, updated_at, parent, session_id) FROM stdin;
00000000-0000-0000-0000-000000000000	1	uBSAD2i2oYSxY9nz0ygQ9A	0ca80e2a-9a01-477a-8900-8d9f483e76a1	f	2023-02-24 15:47:16.159989+00	2023-02-24 15:47:16.159989+00	\N	5b66ab6e-77ba-428b-8ad7-654356f2af38
00000000-0000-0000-0000-000000000000	2	3fOf0k5hiIC2hizsKz6sSA	9200dab3-1c2c-40a2-9e95-4024d23dd6c3	f	2023-02-24 16:24:03.720831+00	2023-02-24 16:24:03.720831+00	\N	e4233cbe-a263-4763-b889-ad84d92b8788
00000000-0000-0000-0000-000000000000	3	FnPy8wp_YNMPed22QSN_jg	0ca80e2a-9a01-477a-8900-8d9f483e76a1	f	2023-02-24 17:08:54.515362+00	2023-02-24 17:08:54.515362+00	\N	abe4e181-3a83-406b-825d-8242d72be95f
00000000-0000-0000-0000-000000000000	4	zbAZCMRtmxMGbKLIMcRk0Q	9200dab3-1c2c-40a2-9e95-4024d23dd6c3	f	2023-02-24 17:18:57.461505+00	2023-02-24 17:18:57.461505+00	\N	8067cbb0-87db-4f31-9460-0b0cf6d8d0ac
00000000-0000-0000-0000-000000000000	6	xb2ciYwgTV_2u2PfqrDCqg	9200dab3-1c2c-40a2-9e95-4024d23dd6c3	f	2023-03-04 15:11:36.15273+00	2023-03-04 15:11:36.15273+00	\N	59b9f3a7-3f39-4640-a184-72844529c312
00000000-0000-0000-0000-000000000000	7	JybL625eBK-G9DlZ0GFlZQ	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 17:37:17.477077+00	2023-03-04 17:37:17.477077+00	\N	05af2f9f-5908-43e1-b66f-dc446e623fa9
00000000-0000-0000-0000-000000000000	8	CK_A2LFNDG67bMzdE48Jpw	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 17:57:22.470163+00	2023-03-04 17:57:22.470163+00	\N	7e6d9c2b-4d1e-450e-b69b-4c3c6707d1d3
00000000-0000-0000-0000-000000000000	9	e1-duNe7ktNrTpxTIjPi6g	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 18:33:15.672944+00	2023-03-04 18:33:15.672944+00	\N	5ceebd34-453b-4fc9-a31d-0aae5fbdd0ec
00000000-0000-0000-0000-000000000000	10	RIgQeKLe9hNk8mjYf1tryw	71494f6d-cccc-4c64-b88b-8c645fa56480	f	2023-03-04 18:45:34.875422+00	2023-03-04 18:45:34.875422+00	\N	e91faf8e-c2cf-40bd-a8da-eb8aea163306
00000000-0000-0000-0000-000000000000	11	gp-yVsjVEfqj3fa94TP8mQ	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 18:46:04.414487+00	2023-03-04 18:46:04.414487+00	\N	4172dfa0-6c56-48e2-bf51-6c4c5c9406cd
00000000-0000-0000-0000-000000000000	12	SWY4jlkVmxi9ItDaw6kkaQ	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 18:46:29.834203+00	2023-03-04 18:46:29.834203+00	\N	3df498ba-dfcf-4fd8-a6c9-16eec6b12f6d
00000000-0000-0000-0000-000000000000	13	YKWrPqBCX9jqji1DHet6yw	71494f6d-cccc-4c64-b88b-8c645fa56480	f	2023-03-04 19:07:08.715846+00	2023-03-04 19:07:08.715846+00	\N	d66208aa-524e-458d-89f0-68aa9b8f7a91
00000000-0000-0000-0000-000000000000	14	3Mr2P3kw8diw_qSAkliD7A	71494f6d-cccc-4c64-b88b-8c645fa56480	f	2023-03-04 19:15:57.700107+00	2023-03-04 19:15:57.700107+00	\N	41c2b47f-38b0-43e2-b9a4-67ed2249c689
00000000-0000-0000-0000-000000000000	16	stnPrnsfIw0Y4GMDLJJSSQ	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	f	2023-03-04 19:25:33.496677+00	2023-03-04 19:25:33.496677+00	\N	fb3181b1-14ca-447a-bb4a-89ececcc45e1
00000000-0000-0000-0000-000000000000	17	xiSr6La3qIX94YLn4bUaTw	63b8784a-74af-4bc2-ba5d-43caf224fae9	f	2023-03-04 19:26:56.308577+00	2023-03-04 19:26:56.308577+00	\N	f56fa1d6-defe-4ca8-9ba0-dcf2c05d4e6d
00000000-0000-0000-0000-000000000000	18	zdybNBsoxqQ_8ZUSEZxVUg	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 19:31:38.599211+00	2023-03-04 19:31:38.599211+00	\N	82f49001-546b-4593-8515-e2b4249fded6
00000000-0000-0000-0000-000000000000	19	qzK9_QA6Gn8VbCVfn-bEZA	ea531554-9713-44cb-ac70-2204e9b2b03d	f	2023-03-04 19:32:01.709491+00	2023-03-04 19:32:01.709491+00	\N	687aed6f-1923-49cc-a4d1-ace9fde0e5c1
00000000-0000-0000-0000-000000000000	20	USqVtOXTvCfpnXTpZBd3Iw	c1136610-2233-4623-a9db-a9976d8d6726	f	2023-03-04 20:56:40.57171+00	2023-03-04 20:56:40.57171+00	\N	202d5555-58c1-4e72-b69c-301419ad1c5d
00000000-0000-0000-0000-000000000000	21	AeV41LfmMF4X_dyzY0tDAg	c1136610-2233-4623-a9db-a9976d8d6726	f	2023-03-04 20:58:58.388906+00	2023-03-04 20:58:58.388906+00	\N	4833e51c-0ff3-42d2-b984-015b1647f81b
00000000-0000-0000-0000-000000000000	22	IN-_nV8nEbbsTRNVIsnIhA	c1136610-2233-4623-a9db-a9976d8d6726	f	2023-03-04 21:00:02.432984+00	2023-03-04 21:00:02.432984+00	\N	6b21357c-0c5c-4e8a-834e-11134b9c671e
00000000-0000-0000-0000-000000000000	23	nItZ7ZiExtwKCtICVHOeMA	c1136610-2233-4623-a9db-a9976d8d6726	f	2023-03-04 21:04:49.156132+00	2023-03-04 21:04:49.156132+00	\N	e4fade3d-8507-46f0-9be8-870b73a7ceb8
00000000-0000-0000-0000-000000000000	24	CT9zWCMHtsYZeS1seCr75A	63b8784a-74af-4bc2-ba5d-43caf224fae9	f	2023-03-04 21:05:17.147447+00	2023-03-04 21:05:17.147447+00	\N	819ec7a1-2b16-4a6c-b90f-cad7f42550a8
00000000-0000-0000-0000-000000000000	26	1Nui-58aDeZ1yOyj06Z7hw	c1136610-2233-4623-a9db-a9976d8d6726	f	2023-03-04 21:06:35.193265+00	2023-03-04 21:06:35.193265+00	\N	d5a986d7-f295-4281-a3c8-d388c5d8ed97
00000000-0000-0000-0000-000000000000	27	fJL0Ms3_xa1Athyp8yaksw	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:12:17.044354+00	2023-03-04 21:12:17.044354+00	\N	0f2bf2f2-747b-4a8c-8684-9179089beaae
00000000-0000-0000-0000-000000000000	28	kzu7YsVTiJHQQa97A2hpcw	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:12:18.113746+00	2023-03-04 21:12:18.113746+00	\N	dab685fe-7819-49df-b25d-e4c3ac5ef859
00000000-0000-0000-0000-000000000000	29	8ZB05Saa4vI89a2gsu0tkA	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:12:19.274321+00	2023-03-04 21:12:19.274321+00	\N	fdf345b7-a012-48de-88d5-582ce5de2620
00000000-0000-0000-0000-000000000000	30	J12dUucFMVZ39a3gcssNfA	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:12:20.395694+00	2023-03-04 21:12:20.395694+00	\N	d28ad8e3-09a5-48b2-8654-6a54020c072c
00000000-0000-0000-0000-000000000000	31	TVJ7zZoCuownsN86c4colw	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:12:21.388884+00	2023-03-04 21:12:21.388884+00	\N	07d93b68-48c5-412f-8e2e-c4654030960e
00000000-0000-0000-0000-000000000000	32	G_rvHm5jejmsXa3ew3TT_Q	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:12:22.454748+00	2023-03-04 21:12:22.454748+00	\N	17585296-2a9d-4722-a70d-0bd28f25e197
00000000-0000-0000-0000-000000000000	33	uvitzyUBKSYEZ-Dq4NsKEg	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:12:23.533836+00	2023-03-04 21:12:23.533836+00	\N	5f7053ff-d508-4f76-a358-ee27303995bf
00000000-0000-0000-0000-000000000000	34	6fIkYDZexrYOADOigAbUrQ	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:12:24.636824+00	2023-03-04 21:12:24.636824+00	\N	b9af0799-6282-4c0b-9a8f-2becd6797524
00000000-0000-0000-0000-000000000000	35	ryYqCHhT3mlTE5_AreAEAQ	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:12:25.737324+00	2023-03-04 21:12:25.737324+00	\N	ffc4f04b-41b1-46f5-b679-db119ba4eb24
00000000-0000-0000-0000-000000000000	36	jFygu7YTYFgLImB-2H9H1w	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:13:11.10325+00	2023-03-04 21:13:11.10325+00	\N	e62c98b6-a344-4749-926c-aeeab646a864
00000000-0000-0000-0000-000000000000	37	Nh7dZkfoo2KBum4S4KHXnQ	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:28:42.942198+00	2023-03-04 21:28:42.942198+00	\N	1766f376-fc69-4335-9fe8-71bd9ebd71cc
00000000-0000-0000-0000-000000000000	38	9IKbixejBhTkQ-WXBHXM0w	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:28:52.951394+00	2023-03-04 21:28:52.951394+00	\N	c6fc9754-7c75-49a7-bb88-ed84e1e707c1
00000000-0000-0000-0000-000000000000	39	0DA8umgqfhzjWL_Pw1PLsA	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:29:50.653754+00	2023-03-04 21:29:50.653754+00	\N	acdd3ea8-191b-4101-99c8-f99bc4fa8dab
00000000-0000-0000-0000-000000000000	40	5IEdhYq2OO4KhXoXuJXleg	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 21:30:19.542335+00	2023-03-04 21:30:19.542335+00	\N	8a2eded7-1b4d-4cd6-bf3f-f69741f80dcb
00000000-0000-0000-0000-000000000000	41	fmGHYFNwD10kGc_x5EDdkw	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	f	2023-03-04 22:18:17.119544+00	2023-03-04 22:18:17.119544+00	\N	d62127aa-0364-43fe-bbf5-54a8a3d7cd76
00000000-0000-0000-0000-000000000000	42	WnK36cEXv_5ut6N0QpcRSg	c1136610-2233-4623-a9db-a9976d8d6726	f	2023-03-04 22:22:51.54357+00	2023-03-04 22:22:51.54357+00	\N	8c1687f3-6122-416d-80b3-2753261c47d9
00000000-0000-0000-0000-000000000000	43	Qv9jJblhu16Y4A_I0atBmQ	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 22:24:45.613436+00	2023-03-04 22:24:45.613436+00	\N	e4a11ff6-1100-4381-ae25-d194e9e6d509
00000000-0000-0000-0000-000000000000	44	1e4c4JrMKEYNo1xsgONXoQ	63b8784a-74af-4bc2-ba5d-43caf224fae9	f	2023-03-04 22:31:16.073202+00	2023-03-04 22:31:16.073202+00	\N	66c006bc-a8e5-43ac-8946-235e7c70557e
00000000-0000-0000-0000-000000000000	45	ISjOSyNs7UyE3_0JP7fH8w	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	f	2023-03-04 22:31:44.059337+00	2023-03-04 22:31:44.059337+00	\N	6bab8cfe-d22e-4514-95a8-5b202a32a0f1
00000000-0000-0000-0000-000000000000	46	vhUGDiXv-P2wAQmBkaj6qg	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	f	2023-03-04 22:32:13.70979+00	2023-03-04 22:32:13.70979+00	\N	eafd5cca-a38a-4e93-b893-c8c58551f5c9
00000000-0000-0000-0000-000000000000	47	tgBhTZgsP4lftAIsN-ASJg	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	f	2023-03-04 22:32:15.035915+00	2023-03-04 22:32:15.035915+00	\N	fb80f883-666c-49a8-aa6d-e3fc70a7b1bb
00000000-0000-0000-0000-000000000000	49	z5H2lqa0EwYNwF1y_Pj2Lw	985ea5d5-bdcf-480e-aa62-a35f09268c00	f	2023-03-04 22:42:45.722081+00	2023-03-04 22:42:45.722081+00	\N	a3059898-06e3-4baf-acac-256a41a9e159
00000000-0000-0000-0000-000000000000	25	psCiFyiVk84Nlp0VhwHLfA	c1136610-2233-4623-a9db-a9976d8d6726	t	2023-03-04 21:05:33.2413+00	2023-03-04 22:43:03.542199+00	\N	75ae2d9e-809f-4dd0-be49-eb41c2a10950
00000000-0000-0000-0000-000000000000	50	H849X_WJMfVo1SodldV20A	c1136610-2233-4623-a9db-a9976d8d6726	f	2023-03-04 22:43:03.544262+00	2023-03-04 22:43:03.544262+00	psCiFyiVk84Nlp0VhwHLfA	75ae2d9e-809f-4dd0-be49-eb41c2a10950
00000000-0000-0000-0000-000000000000	51	M89oW_Uo3Jh6Nu3AHvPHtw	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 22:43:11.825438+00	2023-03-04 22:43:11.825438+00	\N	103f2074-fdd9-4499-a35f-9505ecf2a81f
00000000-0000-0000-0000-000000000000	52	hetiG9VqYM4HJR0EYbv30Q	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 22:44:20.349437+00	2023-03-04 22:44:20.349437+00	\N	00344e57-8d30-4a3d-858d-bf12c3982585
00000000-0000-0000-0000-000000000000	48	XVingVjRSQdGlZKv-9okAA	404180d2-0f86-498b-b57f-77740b09d684	t	2023-03-04 22:41:50.156068+00	2023-03-04 23:55:39.885446+00	\N	5cd9a52c-138c-4f52-8ec4-2c107f83695c
00000000-0000-0000-0000-000000000000	15	223eDRrJBOOKVgYAahreHA	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	t	2023-03-04 19:24:43.444338+00	2023-03-05 11:56:10.286356+00	\N	3cb7b467-9597-4c1d-8d5a-1e41b8d18fd6
00000000-0000-0000-0000-000000000000	53	gCBWObPJNiRKntwHnjOKcg	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 22:44:27.194153+00	2023-03-04 22:44:27.194153+00	\N	5913fad4-f7fb-456b-8daf-bfa2cf87800a
00000000-0000-0000-0000-000000000000	54	kDplXZiSsoitfW-qm9kPLg	985ea5d5-bdcf-480e-aa62-a35f09268c00	f	2023-03-04 22:44:40.946018+00	2023-03-04 22:44:40.946018+00	\N	4f8e6f98-2d60-4aaf-8d59-2d2aefaf8926
00000000-0000-0000-0000-000000000000	55	okjtmG7lROvB7_t1x5bMyQ	d147b95f-17a0-4d18-b481-d1d53a67500a	f	2023-03-04 22:45:15.506462+00	2023-03-04 22:45:15.506462+00	\N	af6ffaba-7cee-4185-baee-4bc37b73aad4
00000000-0000-0000-0000-000000000000	56	23Yabshc-AQABqdQeKOVNw	404180d2-0f86-498b-b57f-77740b09d684	t	2023-03-04 22:45:26.47828+00	2023-03-04 23:44:57.474926+00	\N	5f4810de-a455-430c-9e11-4e26cd03e7a0
00000000-0000-0000-0000-000000000000	58	mal12AIYUGRSMcCh65fGhQ	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-04 23:55:39.886244+00	2023-03-04 23:55:39.886244+00	XVingVjRSQdGlZKv-9okAA	5cd9a52c-138c-4f52-8ec4-2c107f83695c
00000000-0000-0000-0000-000000000000	57	n-ZfR1eydvtMlKbGBCKCOA	404180d2-0f86-498b-b57f-77740b09d684	t	2023-03-04 23:44:57.475313+00	2023-03-05 00:48:17.685359+00	23Yabshc-AQABqdQeKOVNw	5f4810de-a455-430c-9e11-4e26cd03e7a0
00000000-0000-0000-0000-000000000000	59	5tj3o2CDtNWOsmmMGkMFBg	404180d2-0f86-498b-b57f-77740b09d684	t	2023-03-05 00:48:17.685908+00	2023-03-05 04:07:18.884531+00	n-ZfR1eydvtMlKbGBCKCOA	5f4810de-a455-430c-9e11-4e26cd03e7a0
00000000-0000-0000-0000-000000000000	60	bLEEnWz1PR8XiifeD5riwA	985ea5d5-bdcf-480e-aa62-a35f09268c00	t	2023-03-05 00:51:02.461799+00	2023-03-05 04:07:32.985498+00	\N	6386ee01-2a73-4e37-b145-8609e3a57a4b
00000000-0000-0000-0000-000000000000	62	2VUsLbqJhWnfkbwyYRaPnw	985ea5d5-bdcf-480e-aa62-a35f09268c00	f	2023-03-05 04:07:32.986094+00	2023-03-05 04:07:32.986094+00	bLEEnWz1PR8XiifeD5riwA	6386ee01-2a73-4e37-b145-8609e3a57a4b
00000000-0000-0000-0000-000000000000	63	LD7Oojd9feG2-Ms2smXYPg	985ea5d5-bdcf-480e-aa62-a35f09268c00	f	2023-03-05 04:09:10.74074+00	2023-03-05 04:09:10.74074+00	\N	9a6e1dc4-9b3f-4095-b718-60ac4c7c393e
00000000-0000-0000-0000-000000000000	64	8zhBeNaerQ5Bx6vGlRCpJA	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-05 04:09:17.08599+00	2023-03-05 04:09:17.08599+00	\N	37bf6806-c076-45be-83d2-b1512cdcfbb0
00000000-0000-0000-0000-000000000000	65	RKMMgy14kaq4VYH1vG0Vrg	985ea5d5-bdcf-480e-aa62-a35f09268c00	f	2023-03-05 04:18:24.90374+00	2023-03-05 04:18:24.90374+00	\N	575260f4-6efb-4cff-93b0-629bf34bf5b3
00000000-0000-0000-0000-000000000000	66	Xum9HYhR8JR024Kmry6Fqg	985ea5d5-bdcf-480e-aa62-a35f09268c00	f	2023-03-05 04:19:25.068176+00	2023-03-05 04:19:25.068176+00	\N	6e928f5e-d47f-4b6c-b83d-b83345a264c3
00000000-0000-0000-0000-000000000000	67	uvInOIlng31CAfNUgpnEhQ	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-05 04:19:38.281316+00	2023-03-05 04:19:38.281316+00	\N	004b3692-49d0-4830-b3a1-c83d3f49bf50
00000000-0000-0000-0000-000000000000	68	Xjb-lE8DKbzL5vMWkeg2Tw	63b8784a-74af-4bc2-ba5d-43caf224fae9	f	2023-03-05 04:19:58.897699+00	2023-03-05 04:19:58.897699+00	\N	f6833906-5db9-4731-8c0d-7faef363ff49
00000000-0000-0000-0000-000000000000	69	2QKZV2XpRBxHe69ohpjKPA	985ea5d5-bdcf-480e-aa62-a35f09268c00	f	2023-03-05 04:20:01.3138+00	2023-03-05 04:20:01.3138+00	\N	3e482f3c-f159-4c53-ad1f-9337df7a9aa5
00000000-0000-0000-0000-000000000000	70	z6FTs90dKW1bzz92azN6yg	c1136610-2233-4623-a9db-a9976d8d6726	f	2023-03-05 04:23:55.428799+00	2023-03-05 04:23:55.428799+00	\N	13a634d5-dea4-44ff-b119-ed6a9c73c3ba
00000000-0000-0000-0000-000000000000	71	GHTpvd-4yr1AfoC5ZunCpg	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-05 04:24:30.389768+00	2023-03-05 04:24:30.389768+00	\N	550bae05-3874-4cb1-b45e-a88472238f16
00000000-0000-0000-0000-000000000000	61	pE8XYXTB80peRm1mN92rqQ	404180d2-0f86-498b-b57f-77740b09d684	t	2023-03-05 04:07:18.884816+00	2023-03-05 05:43:18.9148+00	5tj3o2CDtNWOsmmMGkMFBg	5f4810de-a455-430c-9e11-4e26cd03e7a0
00000000-0000-0000-0000-000000000000	72	5JqW1zzjPIJJQxtyMkOhhA	404180d2-0f86-498b-b57f-77740b09d684	f	2023-03-05 05:43:18.915089+00	2023-03-05 05:43:18.915089+00	pE8XYXTB80peRm1mN92rqQ	5f4810de-a455-430c-9e11-4e26cd03e7a0
00000000-0000-0000-0000-000000000000	73	Ro7hLKb4tYcBU2yuIxfb2g	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	f	2023-03-05 11:56:10.286656+00	2023-03-05 11:56:10.286656+00	223eDRrJBOOKVgYAahreHA	3cb7b467-9597-4c1d-8d5a-1e41b8d18fd6
\.


--
-- Data for Name: saml_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_providers (id, sso_provider_id, entity_id, metadata_xml, metadata_url, attribute_mapping, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: saml_relay_states; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.saml_relay_states (id, sso_provider_id, request_id, for_email, redirect_to, from_ip_address, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: schema_migrations; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.schema_migrations (version) FROM stdin;
20171026211738
20171026211808
20171026211834
20180103212743
20180108183307
20180119214651
20180125194653
00
20210710035447
20210722035447
20210730183235
20210909172000
20210927181326
20211122151130
20211124214934
20211202183645
20220114185221
20220114185340
20220224000811
20220323170000
20220429102000
20220531120530
20220614074223
20220811173540
20221003041349
20221003041400
20221011041400
20221020193600
20221021073300
20221021082433
20221027105023
20221114143122
20221114143410
20221125140132
20221208132122
20221215195500
20221215195800
20221215195900
20230116124310
20230116124412
20230131181311
\.


--
-- Data for Name: sessions; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sessions (id, user_id, created_at, updated_at, factor_id, aal, not_after) FROM stdin;
5b66ab6e-77ba-428b-8ad7-654356f2af38	0ca80e2a-9a01-477a-8900-8d9f483e76a1	2023-02-24 15:47:16.15845+00	2023-02-24 15:47:16.15845+00	\N	aal1	\N
e4233cbe-a263-4763-b889-ad84d92b8788	9200dab3-1c2c-40a2-9e95-4024d23dd6c3	2023-02-24 16:24:03.720118+00	2023-02-24 16:24:03.720118+00	\N	aal1	\N
abe4e181-3a83-406b-825d-8242d72be95f	0ca80e2a-9a01-477a-8900-8d9f483e76a1	2023-02-24 17:08:54.513768+00	2023-02-24 17:08:54.513768+00	\N	aal1	\N
8067cbb0-87db-4f31-9460-0b0cf6d8d0ac	9200dab3-1c2c-40a2-9e95-4024d23dd6c3	2023-02-24 17:18:57.459789+00	2023-02-24 17:18:57.459789+00	\N	aal1	\N
59b9f3a7-3f39-4640-a184-72844529c312	9200dab3-1c2c-40a2-9e95-4024d23dd6c3	2023-03-04 15:11:36.148397+00	2023-03-04 15:11:36.148397+00	\N	aal1	\N
05af2f9f-5908-43e1-b66f-dc446e623fa9	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 17:37:17.476474+00	2023-03-04 17:37:17.476474+00	\N	aal1	\N
7e6d9c2b-4d1e-450e-b69b-4c3c6707d1d3	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 17:57:22.468575+00	2023-03-04 17:57:22.468575+00	\N	aal1	\N
5ceebd34-453b-4fc9-a31d-0aae5fbdd0ec	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 18:33:15.672346+00	2023-03-04 18:33:15.672346+00	\N	aal1	\N
e91faf8e-c2cf-40bd-a8da-eb8aea163306	71494f6d-cccc-4c64-b88b-8c645fa56480	2023-03-04 18:45:34.874719+00	2023-03-04 18:45:34.874719+00	\N	aal1	\N
4172dfa0-6c56-48e2-bf51-6c4c5c9406cd	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 18:46:04.413382+00	2023-03-04 18:46:04.413382+00	\N	aal1	\N
3df498ba-dfcf-4fd8-a6c9-16eec6b12f6d	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 18:46:29.833001+00	2023-03-04 18:46:29.833001+00	\N	aal1	\N
d66208aa-524e-458d-89f0-68aa9b8f7a91	71494f6d-cccc-4c64-b88b-8c645fa56480	2023-03-04 19:07:08.715304+00	2023-03-04 19:07:08.715304+00	\N	aal1	\N
41c2b47f-38b0-43e2-b9a4-67ed2249c689	71494f6d-cccc-4c64-b88b-8c645fa56480	2023-03-04 19:15:57.699479+00	2023-03-04 19:15:57.699479+00	\N	aal1	\N
3cb7b467-9597-4c1d-8d5a-1e41b8d18fd6	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	2023-03-04 19:24:43.443165+00	2023-03-04 19:24:43.443165+00	\N	aal1	\N
fb3181b1-14ca-447a-bb4a-89ececcc45e1	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	2023-03-04 19:25:33.496198+00	2023-03-04 19:25:33.496198+00	\N	aal1	\N
f56fa1d6-defe-4ca8-9ba0-dcf2c05d4e6d	63b8784a-74af-4bc2-ba5d-43caf224fae9	2023-03-04 19:26:56.308056+00	2023-03-04 19:26:56.308056+00	\N	aal1	\N
82f49001-546b-4593-8515-e2b4249fded6	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 19:31:38.598052+00	2023-03-04 19:31:38.598052+00	\N	aal1	\N
687aed6f-1923-49cc-a4d1-ace9fde0e5c1	ea531554-9713-44cb-ac70-2204e9b2b03d	2023-03-04 19:32:01.708956+00	2023-03-04 19:32:01.708956+00	\N	aal1	\N
202d5555-58c1-4e72-b69c-301419ad1c5d	c1136610-2233-4623-a9db-a9976d8d6726	2023-03-04 20:56:40.569642+00	2023-03-04 20:56:40.569642+00	\N	aal1	\N
4833e51c-0ff3-42d2-b984-015b1647f81b	c1136610-2233-4623-a9db-a9976d8d6726	2023-03-04 20:58:58.387673+00	2023-03-04 20:58:58.387673+00	\N	aal1	\N
6b21357c-0c5c-4e8a-834e-11134b9c671e	c1136610-2233-4623-a9db-a9976d8d6726	2023-03-04 21:00:02.432537+00	2023-03-04 21:00:02.432537+00	\N	aal1	\N
e4fade3d-8507-46f0-9be8-870b73a7ceb8	c1136610-2233-4623-a9db-a9976d8d6726	2023-03-04 21:04:49.155546+00	2023-03-04 21:04:49.155546+00	\N	aal1	\N
819ec7a1-2b16-4a6c-b90f-cad7f42550a8	63b8784a-74af-4bc2-ba5d-43caf224fae9	2023-03-04 21:05:17.146238+00	2023-03-04 21:05:17.146238+00	\N	aal1	\N
75ae2d9e-809f-4dd0-be49-eb41c2a10950	c1136610-2233-4623-a9db-a9976d8d6726	2023-03-04 21:05:33.240551+00	2023-03-04 21:05:33.240551+00	\N	aal1	\N
d5a986d7-f295-4281-a3c8-d388c5d8ed97	c1136610-2233-4623-a9db-a9976d8d6726	2023-03-04 21:06:35.192499+00	2023-03-04 21:06:35.192499+00	\N	aal1	\N
0f2bf2f2-747b-4a8c-8684-9179089beaae	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:12:17.04351+00	2023-03-04 21:12:17.04351+00	\N	aal1	\N
dab685fe-7819-49df-b25d-e4c3ac5ef859	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:12:18.113159+00	2023-03-04 21:12:18.113159+00	\N	aal1	\N
fdf345b7-a012-48de-88d5-582ce5de2620	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:12:19.273028+00	2023-03-04 21:12:19.273028+00	\N	aal1	\N
d28ad8e3-09a5-48b2-8654-6a54020c072c	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:12:20.394857+00	2023-03-04 21:12:20.394857+00	\N	aal1	\N
07d93b68-48c5-412f-8e2e-c4654030960e	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:12:21.387728+00	2023-03-04 21:12:21.387728+00	\N	aal1	\N
17585296-2a9d-4722-a70d-0bd28f25e197	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:12:22.453898+00	2023-03-04 21:12:22.453898+00	\N	aal1	\N
5f7053ff-d508-4f76-a358-ee27303995bf	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:12:23.532835+00	2023-03-04 21:12:23.532835+00	\N	aal1	\N
b9af0799-6282-4c0b-9a8f-2becd6797524	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:12:24.635946+00	2023-03-04 21:12:24.635946+00	\N	aal1	\N
ffc4f04b-41b1-46f5-b679-db119ba4eb24	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:12:25.736234+00	2023-03-04 21:12:25.736234+00	\N	aal1	\N
e62c98b6-a344-4749-926c-aeeab646a864	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:13:11.102071+00	2023-03-04 21:13:11.102071+00	\N	aal1	\N
1766f376-fc69-4335-9fe8-71bd9ebd71cc	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:28:42.941036+00	2023-03-04 21:28:42.941036+00	\N	aal1	\N
c6fc9754-7c75-49a7-bb88-ed84e1e707c1	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:28:52.950047+00	2023-03-04 21:28:52.950047+00	\N	aal1	\N
acdd3ea8-191b-4101-99c8-f99bc4fa8dab	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:29:50.65199+00	2023-03-04 21:29:50.65199+00	\N	aal1	\N
8a2eded7-1b4d-4cd6-bf3f-f69741f80dcb	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 21:30:19.541756+00	2023-03-04 21:30:19.541756+00	\N	aal1	\N
d62127aa-0364-43fe-bbf5-54a8a3d7cd76	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	2023-03-04 22:18:17.119079+00	2023-03-04 22:18:17.119079+00	\N	aal1	\N
8c1687f3-6122-416d-80b3-2753261c47d9	c1136610-2233-4623-a9db-a9976d8d6726	2023-03-04 22:22:51.542934+00	2023-03-04 22:22:51.542934+00	\N	aal1	\N
e4a11ff6-1100-4381-ae25-d194e9e6d509	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 22:24:45.612398+00	2023-03-04 22:24:45.612398+00	\N	aal1	\N
66c006bc-a8e5-43ac-8946-235e7c70557e	63b8784a-74af-4bc2-ba5d-43caf224fae9	2023-03-04 22:31:16.072128+00	2023-03-04 22:31:16.072128+00	\N	aal1	\N
6bab8cfe-d22e-4514-95a8-5b202a32a0f1	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	2023-03-04 22:31:44.05879+00	2023-03-04 22:31:44.05879+00	\N	aal1	\N
eafd5cca-a38a-4e93-b893-c8c58551f5c9	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	2023-03-04 22:32:13.709163+00	2023-03-04 22:32:13.709163+00	\N	aal1	\N
fb80f883-666c-49a8-aa6d-e3fc70a7b1bb	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1	2023-03-04 22:32:15.035403+00	2023-03-04 22:32:15.035403+00	\N	aal1	\N
5cd9a52c-138c-4f52-8ec4-2c107f83695c	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 22:41:50.155278+00	2023-03-04 22:41:50.155278+00	\N	aal1	\N
a3059898-06e3-4baf-acac-256a41a9e159	985ea5d5-bdcf-480e-aa62-a35f09268c00	2023-03-04 22:42:45.720955+00	2023-03-04 22:42:45.720955+00	\N	aal1	\N
103f2074-fdd9-4499-a35f-9505ecf2a81f	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 22:43:11.824683+00	2023-03-04 22:43:11.824683+00	\N	aal1	\N
00344e57-8d30-4a3d-858d-bf12c3982585	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 22:44:20.348308+00	2023-03-04 22:44:20.348308+00	\N	aal1	\N
5913fad4-f7fb-456b-8daf-bfa2cf87800a	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 22:44:27.193804+00	2023-03-04 22:44:27.193804+00	\N	aal1	\N
4f8e6f98-2d60-4aaf-8d59-2d2aefaf8926	985ea5d5-bdcf-480e-aa62-a35f09268c00	2023-03-04 22:44:40.945517+00	2023-03-04 22:44:40.945517+00	\N	aal1	\N
af6ffaba-7cee-4185-baee-4bc37b73aad4	d147b95f-17a0-4d18-b481-d1d53a67500a	2023-03-04 22:45:15.506039+00	2023-03-04 22:45:15.506039+00	\N	aal1	\N
5f4810de-a455-430c-9e11-4e26cd03e7a0	404180d2-0f86-498b-b57f-77740b09d684	2023-03-04 22:45:26.477226+00	2023-03-04 22:45:26.477226+00	\N	aal1	\N
6386ee01-2a73-4e37-b145-8609e3a57a4b	985ea5d5-bdcf-480e-aa62-a35f09268c00	2023-03-05 00:51:02.46143+00	2023-03-05 00:51:02.46143+00	\N	aal1	\N
9a6e1dc4-9b3f-4095-b718-60ac4c7c393e	985ea5d5-bdcf-480e-aa62-a35f09268c00	2023-03-05 04:09:10.740307+00	2023-03-05 04:09:10.740307+00	\N	aal1	\N
37bf6806-c076-45be-83d2-b1512cdcfbb0	404180d2-0f86-498b-b57f-77740b09d684	2023-03-05 04:09:17.085627+00	2023-03-05 04:09:17.085627+00	\N	aal1	\N
575260f4-6efb-4cff-93b0-629bf34bf5b3	985ea5d5-bdcf-480e-aa62-a35f09268c00	2023-03-05 04:18:24.903257+00	2023-03-05 04:18:24.903257+00	\N	aal1	\N
6e928f5e-d47f-4b6c-b83d-b83345a264c3	985ea5d5-bdcf-480e-aa62-a35f09268c00	2023-03-05 04:19:25.067644+00	2023-03-05 04:19:25.067644+00	\N	aal1	\N
004b3692-49d0-4830-b3a1-c83d3f49bf50	404180d2-0f86-498b-b57f-77740b09d684	2023-03-05 04:19:38.280243+00	2023-03-05 04:19:38.280243+00	\N	aal1	\N
f6833906-5db9-4731-8c0d-7faef363ff49	63b8784a-74af-4bc2-ba5d-43caf224fae9	2023-03-05 04:19:58.897285+00	2023-03-05 04:19:58.897285+00	\N	aal1	\N
3e482f3c-f159-4c53-ad1f-9337df7a9aa5	985ea5d5-bdcf-480e-aa62-a35f09268c00	2023-03-05 04:20:01.313424+00	2023-03-05 04:20:01.313424+00	\N	aal1	\N
13a634d5-dea4-44ff-b119-ed6a9c73c3ba	c1136610-2233-4623-a9db-a9976d8d6726	2023-03-05 04:23:55.428181+00	2023-03-05 04:23:55.428181+00	\N	aal1	\N
550bae05-3874-4cb1-b45e-a88472238f16	404180d2-0f86-498b-b57f-77740b09d684	2023-03-05 04:24:30.389398+00	2023-03-05 04:24:30.389398+00	\N	aal1	\N
\.


--
-- Data for Name: sso_domains; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_domains (id, sso_provider_id, domain, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: sso_providers; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.sso_providers (id, resource_id, created_at, updated_at) FROM stdin;
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: auth; Owner: supabase_auth_admin
--

COPY auth.users (instance_id, id, aud, role, email, encrypted_password, email_confirmed_at, invited_at, confirmation_token, confirmation_sent_at, recovery_token, recovery_sent_at, email_change_token_new, email_change, email_change_sent_at, last_sign_in_at, raw_app_meta_data, raw_user_meta_data, is_super_admin, created_at, updated_at, phone, phone_confirmed_at, phone_change, phone_change_token, phone_change_sent_at, email_change_token_current, email_change_confirm_status, banned_until, reauthentication_token, reauthentication_sent_at, is_sso_user, deleted_at) FROM stdin;
00000000-0000-0000-0000-000000000000	9200dab3-1c2c-40a2-9e95-4024d23dd6c3	authenticated	authenticated	vasile@tict.app	$2a$10$0fDWtwGPLheMFb7Wm94foe83RiN.jJnclD.o/XP10ePGY.ii/8NIi	2023-02-24 16:24:03.719459+00	2023-02-24 16:23:18.102901+00		2023-02-24 16:23:18.102901+00		2023-03-04 15:09:01.238949+00			\N	2023-03-04 15:11:36.148233+00	{"provider": "email", "providers": ["email"]}	{}	\N	2023-02-24 16:23:18.098056+00	2023-03-04 15:11:36.157107+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	0ca80e2a-9a01-477a-8900-8d9f483e76a1	authenticated	authenticated	ion@tict.app	$2a$10$WJKiQ5/W7OPK/bwyQ2yKk.RZivedtTf8itn8dhlQe0pFUVCUulb6e	2023-02-24 15:47:16.15757+00	2023-02-24 15:45:37.968064+00		2023-02-24 15:46:59.378164+00		2023-02-24 17:08:41.664097+00			\N	2023-02-24 17:08:54.513648+00	{"provider": "email", "providers": ["email"]}	{}	\N	2023-02-24 15:45:37.962685+00	2023-02-24 17:08:54.51736+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	ea531554-9713-44cb-ac70-2204e9b2b03d			sergiu.toderascu@gmail.com		2023-03-04 19:32:01.708586+00	\N		\N		\N			\N	2023-03-04 19:32:01.708925+00	{"provider": "google", "providers": ["google"]}	{"iss": "https://www.googleapis.com/userinfo/v2/me", "sub": "106676535335197892675", "name": "Sergiu Toderascu", "email": "sergiu.toderascu@gmail.com", "picture": "https://lh3.googleusercontent.com/a/AGNmyxYdn5xxMS1ZtijeAuOL2f5Kx30vo108sfD99ougPk8=s96-c", "full_name": "Sergiu Toderascu", "avatar_url": "https://lh3.googleusercontent.com/a/AGNmyxYdn5xxMS1ZtijeAuOL2f5Kx30vo108sfD99ougPk8=s96-c", "provider_id": "106676535335197892675", "email_verified": true}	\N	2023-03-04 19:32:01.704913+00	2023-03-04 19:32:01.710212+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	71494f6d-cccc-4c64-b88b-8c645fa56480			aa@tict.app	$2a$10$xfqK.GB3/363TDRk.dgjz.An5gLF9IIGtFz8cdoX5SPR4YapDUET2	2023-03-04 18:45:34.874223+00	2023-03-04 18:43:36.478138+00		2023-03-04 18:45:17.357599+00		2023-03-04 19:14:52.795812+00			\N	2023-03-04 19:15:57.699446+00	{"provider": "email", "providers": ["email"]}	{}	\N	2023-03-04 18:43:36.475251+00	2023-03-04 19:15:57.701195+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	c1136610-2233-4623-a9db-a9976d8d6726			\N	$2a$10$waYsw5vA64UBvAUkjl6dsOK5QmZ9bTzNy4ZlqhJChWd59RsPEdP0C	\N	\N		2023-03-04 20:58:18.362391+00		\N			\N	2023-03-05 04:23:55.42813+00	{"provider": "phone", "providers": ["phone"]}	{}	\N	2023-03-04 20:56:12.318061+00	2023-03-05 04:23:55.429404+00	40739740662	2023-03-04 20:58:58.386665+00			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	d147b95f-17a0-4d18-b481-d1d53a67500a			w@tict.app	$2a$10$BMbWYYe3.Uv3tPHfqNh5bu6h2hhVbuYSrciN8XxqICcNX47VTdOKW	2023-03-04 22:45:15.505581+00	\N		2023-03-04 22:44:57.424006+00		\N			\N	2023-03-04 22:45:15.506007+00	{"provider": "email", "providers": ["email"]}	{}	\N	2023-03-04 22:44:57.42016+00	2023-03-04 22:45:15.507125+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	5669a89a-d38f-4c25-b1f2-eeb2d1cd90c1			z@tict.app	$2a$10$CviLJo6rjagdtx1nv4Ih2et4GzYPg4nUf8tatkZ5bLS1VUHLrsjVu	2023-03-04 19:24:43.44164+00	\N		2023-03-04 19:17:56.895775+00		\N			\N	2023-03-04 22:32:15.035338+00	{"provider": "email", "providers": ["email"]}	{}	\N	2023-03-04 19:17:56.892702+00	2023-03-05 11:56:10.287494+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	63b8784a-74af-4bc2-ba5d-43caf224fae9			miafosh007@gmail.com		2023-03-04 19:26:56.307642+00	\N		\N		\N			\N	2023-03-05 04:19:58.897243+00	{"provider": "google", "providers": ["google"]}	{"iss": "https://www.googleapis.com/userinfo/v2/me", "sub": "100196046488372331425", "name": "Miafosh", "email": "miafosh007@gmail.com", "picture": "https://lh3.googleusercontent.com/a/AGNmyxZf8KL_FBnazJ871-HibgjFqc9PvXrhVg5OwtYd=s96-c", "full_name": "Miafosh", "avatar_url": "https://lh3.googleusercontent.com/a/AGNmyxZf8KL_FBnazJ871-HibgjFqc9PvXrhVg5OwtYd=s96-c", "provider_id": "100196046488372331425", "email_verified": true}	\N	2023-03-04 19:26:56.303967+00	2023-03-05 04:19:58.898119+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	404180d2-0f86-498b-b57f-77740b09d684	authenticated	authenticated	mr.serebano@gmail.com		2023-03-04 17:37:17.475771+00	\N		\N		\N			\N	2023-03-05 04:24:30.389364+00	{"provider": "github", "providers": ["github", "google"]}	{"iss": "https://api.github.com", "sub": "1105775", "name": "Mr Serebano", "email": "mr.serebano@gmail.com", "picture": "https://lh3.googleusercontent.com/a/AGNmyxYvINb-8pzHefrEdZizNfFIXQZ64h0niZH-wKGZkmU=s96-c", "full_name": "Mr Serebano", "user_name": "serebano", "avatar_url": "https://avatars.githubusercontent.com/u/1105775?v=4", "provider_id": "1105775", "email_verified": true, "preferred_username": "serebano"}	\N	2023-03-04 17:37:17.456087+00	2023-03-05 05:43:18.915935+00	\N	\N			\N		0	\N		\N	f	\N
00000000-0000-0000-0000-000000000000	985ea5d5-bdcf-480e-aa62-a35f09268c00			y@tict.app	$2a$10$aUO/GM5OkN9K3a/vvkvQ4.TuerL5Lo8YdZDSXQjYl33U22W1syUvS	2023-03-04 22:42:45.71963+00	\N		2023-03-04 22:40:39.533072+00		\N			\N	2023-03-05 04:20:01.313387+00	{"provider": "email", "providers": ["email"]}	{"name": "YYYY", "avatar": "https://dev1.tictapp.io/storage/v1/render/image/public/profiles/tictapp.jpg?width=200&height=200", "avatar_url": "https://dev1.tictapp.io/storage/v1/render/image/public/profiles/tictapp.jpg?width=200&height=200"}	\N	2023-03-04 22:40:39.530206+00	2023-03-05 04:20:28.966702+00	\N	\N			\N		0	\N		\N	f	\N
\.


--
-- Data for Name: key; Type: TABLE DATA; Schema: pgsodium; Owner: supabase_admin
--

COPY pgsodium.key (id, status, created, expires, key_type, key_id, key_context, name, associated_data, raw_key, raw_key_nonce, parent_key, comment, user_data) FROM stdin;
8a7e340f-b337-4276-a80e-6c10ee19cdf8	valid	2023-02-24 17:24:19.335872+00	\N	aead-det	1	\\x7067736f6469756d	default_vault_key		\N	\N	\N	\N	\N
\.


--
-- Data for Name: fun_logs; Type: TABLE DATA; Schema: public; Owner: supabase_admin
--

COPY public.fun_logs (id, inserted_at, data) FROM stdin;
1	2023-03-04 01:45:24.104+00	{"deno": {"region": "europe-west3", "deployment_id": "089w2bgvexw0"}, "client": {"ip": "2a02:2f0f:910c:e200:7846:883e:f026:94d7", "loc": "44.4022,26.0624", "org": "AS8708 RCS & RDS SA", "city": "Bucuresti", "postal": "050557", "region": "București", "country": "RO", "timezone": "Europe/Bucharest"}}
2	2023-03-04 01:45:25.993+00	{"deno": {"region": "europe-west3", "deployment_id": "089w2bgvexw0"}, "client": {"ip": "2a02:2f0f:910c:e200:7846:883e:f026:94d7", "loc": "44.4022,26.0624", "org": "AS8708 RCS & RDS SA", "city": "Bucuresti", "postal": "050557", "region": "București", "country": "RO", "timezone": "Europe/Bucharest"}}
3	2023-03-04 01:45:28.2+00	{"deno": {"region": "europe-west3", "deployment_id": "089w2bgvexw0"}, "client": {"ip": "2a02:2f0f:910c:e200:7846:883e:f026:94d7", "loc": "44.4022,26.0624", "org": "AS8708 RCS & RDS SA", "city": "Bucuresti", "postal": "050557", "region": "București", "country": "RO", "timezone": "Europe/Bucharest"}}
4	2023-03-04 01:45:35.554+00	{"deno": {"region": "europe-west3", "deployment_id": "089w2bgvexw0"}, "client": {"ip": "2a02:2f0f:910c:e200:7846:883e:f026:94d7", "loc": "44.4022,26.0624", "org": "AS8708 RCS & RDS SA", "city": "Bucuresti", "postal": "050557", "region": "București", "country": "RO", "timezone": "Europe/Bucharest"}}
5	2023-03-04 01:45:39.573+00	{"deno": {"region": "europe-west3", "deployment_id": "089w2bgvexw0"}, "client": {"ip": "2a02:2f0f:910c:e200:7846:883e:f026:94d7", "loc": "44.4022,26.0624", "org": "AS8708 RCS & RDS SA", "city": "Bucuresti", "postal": "050557", "region": "București", "country": "RO", "timezone": "Europe/Bucharest"}}
6	2023-03-04 01:45:40.924+00	{"deno": {"region": "europe-west3", "deployment_id": "089w2bgvexw0"}, "client": {"ip": "2a02:2f0f:910c:e200:7846:883e:f026:94d7", "loc": "44.4022,26.0624", "org": "AS8708 RCS & RDS SA", "city": "Bucuresti", "postal": "050557", "region": "București", "country": "RO", "timezone": "Europe/Bucharest"}}
7	2023-03-04 01:45:42.044+00	{"deno": {"region": "europe-west3", "deployment_id": "089w2bgvexw0"}, "client": {"ip": "2a02:2f0f:910c:e200:7846:883e:f026:94d7", "loc": "44.4022,26.0624", "org": "AS8708 RCS & RDS SA", "city": "Bucuresti", "postal": "050557", "region": "București", "country": "RO", "timezone": "Europe/Bucharest"}}
8	2023-03-04 01:45:42.531+00	{"deno": {"region": "europe-west3", "deployment_id": "089w2bgvexw0"}, "client": {"ip": "2a02:2f0f:910c:e200:7846:883e:f026:94d7", "loc": "44.4022,26.0624", "org": "AS8708 RCS & RDS SA", "city": "Bucuresti", "postal": "050557", "region": "București", "country": "RO", "timezone": "Europe/Bucharest"}}
\.


--
-- Data for Name: buckets; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.buckets (id, name, owner, created_at, updated_at, public) FROM stdin;
b1	b1	\N	2023-03-04 14:51:01.563447+00	2023-03-04 14:51:01.563447+00	t
profiles	profiles	\N	2023-03-05 01:02:22.38184+00	2023-03-05 01:02:22.38184+00	f
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.migrations (id, name, hash, executed_at) FROM stdin;
0	create-migrations-table	e18db593bcde2aca2a408c4d1100f6abba2195df	2023-02-24 14:38:48.282601
1	initialmigration	6ab16121fbaa08bbd11b712d05f358f9b555d777	2023-02-24 14:38:48.286902
2	pathtoken-column	49756be03be4c17bb85fe70d4a861f27de7e49ad	2023-02-24 14:38:48.291697
3	add-migrations-rls	bb5d124c53d68635a883e399426c6a5a25fc893d	2023-02-24 14:38:48.333406
4	add-size-functions	6d79007d04f5acd288c9c250c42d2d5fd286c54d	2023-02-24 14:38:48.339462
5	change-column-name-in-get-size	fd65688505d2ffa9fbdc58a944348dd8604d688c	2023-02-24 14:38:48.346138
6	add-rls-to-buckets	63e2bab75a2040fee8e3fb3f15a0d26f3380e9b6	2023-02-24 14:38:48.353736
7	add-public-to-buckets	82568934f8a4d9e0a85f126f6fb483ad8214c418	2023-02-24 14:38:48.35859
8	fix-search-function	1a43a40eddb525f2e2f26efd709e6c06e58e059c	2023-02-24 14:38:48.363591
9	search-files-search-function	34c096597eb8b9d077fdfdde9878c88501b2fafc	2023-02-24 14:38:48.372886
10	add-trigger-to-auto-update-updated_at-column	37d6bb964a70a822e6d37f22f457b9bca7885928	2023-02-24 14:38:48.37798
\.


--
-- Data for Name: objects; Type: TABLE DATA; Schema: storage; Owner: supabase_storage_admin
--

COPY storage.objects (id, bucket_id, name, owner, created_at, updated_at, last_accessed_at, metadata) FROM stdin;
b7f4cabc-9b0e-4a4c-8076-1178353db2ef	b1	a/s/as/as/asd/f/aasd/aasdd/as/photo_2023-01-19 02.49.32.jpeg	\N	2023-03-04 14:51:11.033357+00	2023-03-04 15:07:38.973303+00	2023-03-04 15:07:38.451+00	{"eTag": "\\"ac9ce904334f5c9d719e42b4a4f360b9\\"", "size": 24767, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-03-04T15:07:38.000Z", "contentLength": 24767, "httpStatusCode": 200}
12592aac-724e-4786-bdf1-a9f5ade0ecc6	profiles	tictapp.jpg	\N	2023-03-05 01:03:06.318744+00	2023-03-05 01:03:06.666222+00	2023-03-05 01:03:06.318744+00	{"eTag": "\\"e5f250df598e77756a517d95ede0af1a\\"", "size": 43350, "mimetype": "image/jpeg", "cacheControl": "max-age=3600", "lastModified": "2023-03-05T01:03:06.000Z", "contentLength": 43350, "httpStatusCode": 200}
7d5d2afb-1ebc-41d4-bf06-1c4905aa2ae8	profiles	fresh-logo.svg	\N	2023-03-05 04:22:15.007114+00	2023-03-05 04:22:15.381487+00	2023-03-05 04:22:15.007114+00	{"eTag": "\\"b24c6ed02cd2a425a79d3f2df47a20e8\\"", "size": 1028, "mimetype": "image/svg+xml", "cacheControl": "max-age=3600", "lastModified": "2023-03-05T04:22:15.000Z", "contentLength": 1028, "httpStatusCode": 200}
\.


--
-- Data for Name: hooks; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.hooks (id, hook_table_id, hook_name, created_at, request_id) FROM stdin;
\.


--
-- Data for Name: migrations; Type: TABLE DATA; Schema: supabase_functions; Owner: supabase_functions_admin
--

COPY supabase_functions.migrations (version, inserted_at) FROM stdin;
initial	2023-02-24 14:36:14.481546+00
20210809183423_update_grants	2023-02-24 14:36:14.481546+00
\.


--
-- Data for Name: secrets; Type: TABLE DATA; Schema: vault; Owner: supabase_admin
--

COPY vault.secrets (id, name, description, secret, key_id, nonce, created_at, updated_at) FROM stdin;
4635154e-74ee-46bb-972b-afa27c6ad269	TOKEN	Test Token	Km8oIDjxuvGgE4sLT6HAPgeGpfqZygAPICQTqwRODpCHxNzrSGmeUyLm	8a7e340f-b337-4276-a80e-6c10ee19cdf8	\\x0dac07fce5945714171e01488e29e8e3	2023-02-24 17:24:41.880339+00	2023-02-24 17:24:41.880339+00
\.


--
-- Name: refresh_tokens_id_seq; Type: SEQUENCE SET; Schema: auth; Owner: supabase_auth_admin
--

SELECT pg_catalog.setval('auth.refresh_tokens_id_seq', 73, true);


--
-- Name: fun_logs_id_seq; Type: SEQUENCE SET; Schema: public; Owner: supabase_admin
--

SELECT pg_catalog.setval('public.fun_logs_id_seq', 8, true);


--
-- Name: hooks_id_seq; Type: SEQUENCE SET; Schema: supabase_functions; Owner: supabase_functions_admin
--

SELECT pg_catalog.setval('supabase_functions.hooks_id_seq', 1, false);


--
-- Name: extensions extensions_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: tenants tenants_pkey; Type: CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.tenants
    ADD CONSTRAINT tenants_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims amr_id_pk; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT amr_id_pk PRIMARY KEY (id);


--
-- Name: audit_log_entries audit_log_entries_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.audit_log_entries
    ADD CONSTRAINT audit_log_entries_pkey PRIMARY KEY (id);


--
-- Name: identities identities_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_pkey PRIMARY KEY (provider, id);


--
-- Name: instances instances_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.instances
    ADD CONSTRAINT instances_pkey PRIMARY KEY (id);


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_authentication_method_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_authentication_method_pkey UNIQUE (session_id, authentication_method);


--
-- Name: mfa_challenges mfa_challenges_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_pkey PRIMARY KEY (id);


--
-- Name: mfa_factors mfa_factors_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_unique; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_unique UNIQUE (token);


--
-- Name: saml_providers saml_providers_entity_id_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_entity_id_key UNIQUE (entity_id);


--
-- Name: saml_providers saml_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_pkey PRIMARY KEY (id);


--
-- Name: saml_relay_states saml_relay_states_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_pkey PRIMARY KEY (id);


--
-- Name: schema_migrations schema_migrations_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.schema_migrations
    ADD CONSTRAINT schema_migrations_pkey PRIMARY KEY (version);


--
-- Name: sessions sessions_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_pkey PRIMARY KEY (id);


--
-- Name: sso_domains sso_domains_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_pkey PRIMARY KEY (id);


--
-- Name: sso_providers sso_providers_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_providers
    ADD CONSTRAINT sso_providers_pkey PRIMARY KEY (id);


--
-- Name: users users_phone_key; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_phone_key UNIQUE (phone);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: fun_logs fun_logs_pkey; Type: CONSTRAINT; Schema: public; Owner: supabase_admin
--

ALTER TABLE ONLY public.fun_logs
    ADD CONSTRAINT fun_logs_pkey PRIMARY KEY (id);


--
-- Name: buckets buckets_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_name_key; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_name_key UNIQUE (name);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (id);


--
-- Name: objects objects_pkey; Type: CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_pkey PRIMARY KEY (id);


--
-- Name: hooks hooks_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.hooks
    ADD CONSTRAINT hooks_pkey PRIMARY KEY (id);


--
-- Name: migrations migrations_pkey; Type: CONSTRAINT; Schema: supabase_functions; Owner: supabase_functions_admin
--

ALTER TABLE ONLY supabase_functions.migrations
    ADD CONSTRAINT migrations_pkey PRIMARY KEY (version);


--
-- Name: extensions_tenant_external_id_type_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX extensions_tenant_external_id_type_index ON _realtime.extensions USING btree (tenant_external_id, type);


--
-- Name: tenants_external_id_index; Type: INDEX; Schema: _realtime; Owner: supabase_admin
--

CREATE UNIQUE INDEX tenants_external_id_index ON _realtime.tenants USING btree (external_id);


--
-- Name: audit_logs_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX audit_logs_instance_id_idx ON auth.audit_log_entries USING btree (instance_id);


--
-- Name: confirmation_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX confirmation_token_idx ON auth.users USING btree (confirmation_token) WHERE ((confirmation_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_current_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_current_idx ON auth.users USING btree (email_change_token_current) WHERE ((email_change_token_current)::text !~ '^[0-9 ]*$'::text);


--
-- Name: email_change_token_new_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX email_change_token_new_idx ON auth.users USING btree (email_change_token_new) WHERE ((email_change_token_new)::text !~ '^[0-9 ]*$'::text);


--
-- Name: factor_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX factor_id_created_at_idx ON auth.mfa_factors USING btree (user_id, created_at);


--
-- Name: identities_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_email_idx ON auth.identities USING btree (email text_pattern_ops);


--
-- Name: INDEX identities_email_idx; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.identities_email_idx IS 'Auth: Ensures indexed queries on the email column';


--
-- Name: identities_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX identities_user_id_idx ON auth.identities USING btree (user_id);


--
-- Name: mfa_factors_user_friendly_name_unique; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX mfa_factors_user_friendly_name_unique ON auth.mfa_factors USING btree (friendly_name, user_id) WHERE (TRIM(BOTH FROM friendly_name) <> ''::text);


--
-- Name: reauthentication_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX reauthentication_token_idx ON auth.users USING btree (reauthentication_token) WHERE ((reauthentication_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: recovery_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX recovery_token_idx ON auth.users USING btree (recovery_token) WHERE ((recovery_token)::text !~ '^[0-9 ]*$'::text);


--
-- Name: refresh_tokens_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_idx ON auth.refresh_tokens USING btree (instance_id);


--
-- Name: refresh_tokens_instance_id_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_instance_id_user_id_idx ON auth.refresh_tokens USING btree (instance_id, user_id);


--
-- Name: refresh_tokens_parent_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_parent_idx ON auth.refresh_tokens USING btree (parent);


--
-- Name: refresh_tokens_session_id_revoked_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_session_id_revoked_idx ON auth.refresh_tokens USING btree (session_id, revoked);


--
-- Name: refresh_tokens_token_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX refresh_tokens_token_idx ON auth.refresh_tokens USING btree (token);


--
-- Name: saml_providers_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_providers_sso_provider_id_idx ON auth.saml_providers USING btree (sso_provider_id);


--
-- Name: saml_relay_states_for_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_for_email_idx ON auth.saml_relay_states USING btree (for_email);


--
-- Name: saml_relay_states_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX saml_relay_states_sso_provider_id_idx ON auth.saml_relay_states USING btree (sso_provider_id);


--
-- Name: sessions_user_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sessions_user_id_idx ON auth.sessions USING btree (user_id);


--
-- Name: sso_domains_domain_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_domains_domain_idx ON auth.sso_domains USING btree (lower(domain));


--
-- Name: sso_domains_sso_provider_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX sso_domains_sso_provider_id_idx ON auth.sso_domains USING btree (sso_provider_id);


--
-- Name: sso_providers_resource_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX sso_providers_resource_id_idx ON auth.sso_providers USING btree (lower(resource_id));


--
-- Name: user_id_created_at_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX user_id_created_at_idx ON auth.sessions USING btree (user_id, created_at);


--
-- Name: users_email_partial_key; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE UNIQUE INDEX users_email_partial_key ON auth.users USING btree (email) WHERE (is_sso_user = false);


--
-- Name: INDEX users_email_partial_key; Type: COMMENT; Schema: auth; Owner: supabase_auth_admin
--

COMMENT ON INDEX auth.users_email_partial_key IS 'Auth: A partial unique index that applies only when is_sso_user is false';


--
-- Name: users_instance_id_email_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_email_idx ON auth.users USING btree (instance_id, lower((email)::text));


--
-- Name: users_instance_id_idx; Type: INDEX; Schema: auth; Owner: supabase_auth_admin
--

CREATE INDEX users_instance_id_idx ON auth.users USING btree (instance_id);


--
-- Name: bname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bname ON storage.buckets USING btree (name);


--
-- Name: bucketid_objname; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE UNIQUE INDEX bucketid_objname ON storage.objects USING btree (bucket_id, name);


--
-- Name: name_prefix_search; Type: INDEX; Schema: storage; Owner: supabase_storage_admin
--

CREATE INDEX name_prefix_search ON storage.objects USING btree (name text_pattern_ops);


--
-- Name: supabase_functions_hooks_h_table_id_h_name_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_h_table_id_h_name_idx ON supabase_functions.hooks USING btree (hook_table_id, hook_name);


--
-- Name: supabase_functions_hooks_request_id_idx; Type: INDEX; Schema: supabase_functions; Owner: supabase_functions_admin
--

CREATE INDEX supabase_functions_hooks_request_id_idx ON supabase_functions.hooks USING btree (request_id);


--
-- Name: objects update_objects_updated_at; Type: TRIGGER; Schema: storage; Owner: supabase_storage_admin
--

CREATE TRIGGER update_objects_updated_at BEFORE UPDATE ON storage.objects FOR EACH ROW EXECUTE FUNCTION storage.update_updated_at_column();


--
-- Name: extensions extensions_tenant_external_id_fkey; Type: FK CONSTRAINT; Schema: _realtime; Owner: supabase_admin
--

ALTER TABLE ONLY _realtime.extensions
    ADD CONSTRAINT extensions_tenant_external_id_fkey FOREIGN KEY (tenant_external_id) REFERENCES _realtime.tenants(external_id) ON DELETE CASCADE;


--
-- Name: identities identities_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.identities
    ADD CONSTRAINT identities_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: mfa_amr_claims mfa_amr_claims_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_amr_claims
    ADD CONSTRAINT mfa_amr_claims_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: mfa_challenges mfa_challenges_auth_factor_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_challenges
    ADD CONSTRAINT mfa_challenges_auth_factor_id_fkey FOREIGN KEY (factor_id) REFERENCES auth.mfa_factors(id) ON DELETE CASCADE;


--
-- Name: mfa_factors mfa_factors_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.mfa_factors
    ADD CONSTRAINT mfa_factors_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: refresh_tokens refresh_tokens_session_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.refresh_tokens
    ADD CONSTRAINT refresh_tokens_session_id_fkey FOREIGN KEY (session_id) REFERENCES auth.sessions(id) ON DELETE CASCADE;


--
-- Name: saml_providers saml_providers_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_providers
    ADD CONSTRAINT saml_providers_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: saml_relay_states saml_relay_states_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.saml_relay_states
    ADD CONSTRAINT saml_relay_states_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: sessions sessions_user_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sessions
    ADD CONSTRAINT sessions_user_id_fkey FOREIGN KEY (user_id) REFERENCES auth.users(id) ON DELETE CASCADE;


--
-- Name: sso_domains sso_domains_sso_provider_id_fkey; Type: FK CONSTRAINT; Schema: auth; Owner: supabase_auth_admin
--

ALTER TABLE ONLY auth.sso_domains
    ADD CONSTRAINT sso_domains_sso_provider_id_fkey FOREIGN KEY (sso_provider_id) REFERENCES auth.sso_providers(id) ON DELETE CASCADE;


--
-- Name: buckets buckets_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.buckets
    ADD CONSTRAINT buckets_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: objects objects_bucketId_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT "objects_bucketId_fkey" FOREIGN KEY (bucket_id) REFERENCES storage.buckets(id);


--
-- Name: objects objects_owner_fkey; Type: FK CONSTRAINT; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE ONLY storage.objects
    ADD CONSTRAINT objects_owner_fkey FOREIGN KEY (owner) REFERENCES auth.users(id);


--
-- Name: objects Give users authenticated access to folder 1ige2ga_0; Type: POLICY; Schema: storage; Owner: supabase_storage_admin
--

CREATE POLICY "Give users authenticated access to folder 1ige2ga_0" ON storage.objects FOR SELECT TO anon, authenticated, service_role USING (((bucket_id = 'profiles'::text) AND (auth.role() = 'authenticated'::text)));


--
-- Name: buckets; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.buckets ENABLE ROW LEVEL SECURITY;

--
-- Name: migrations; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.migrations ENABLE ROW LEVEL SECURITY;

--
-- Name: objects; Type: ROW SECURITY; Schema: storage; Owner: supabase_storage_admin
--

ALTER TABLE storage.objects ENABLE ROW LEVEL SECURITY;

--
-- Name: supabase_realtime; Type: PUBLICATION; Schema: -; Owner: postgres
--

CREATE PUBLICATION supabase_realtime WITH (publish = 'insert, update, delete, truncate');


ALTER PUBLICATION supabase_realtime OWNER TO postgres;

--
-- Name: SCHEMA auth; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA auth TO anon;
GRANT USAGE ON SCHEMA auth TO authenticated;
GRANT USAGE ON SCHEMA auth TO service_role;
GRANT ALL ON SCHEMA auth TO supabase_auth_admin;
GRANT ALL ON SCHEMA auth TO dashboard_user;
GRANT ALL ON SCHEMA auth TO postgres;


--
-- Name: SCHEMA extensions; Type: ACL; Schema: -; Owner: postgres
--

GRANT USAGE ON SCHEMA extensions TO anon;
GRANT USAGE ON SCHEMA extensions TO authenticated;
GRANT USAGE ON SCHEMA extensions TO service_role;
GRANT ALL ON SCHEMA extensions TO dashboard_user;


--
-- Name: SCHEMA graphql_public; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA graphql_public TO postgres;
GRANT USAGE ON SCHEMA graphql_public TO anon;
GRANT USAGE ON SCHEMA graphql_public TO authenticated;
GRANT USAGE ON SCHEMA graphql_public TO service_role;


--
-- Name: SCHEMA net; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA net TO supabase_functions_admin;
GRANT USAGE ON SCHEMA net TO anon;
GRANT USAGE ON SCHEMA net TO authenticated;
GRANT USAGE ON SCHEMA net TO service_role;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT USAGE ON SCHEMA public TO postgres;
GRANT USAGE ON SCHEMA public TO anon;
GRANT USAGE ON SCHEMA public TO authenticated;
GRANT USAGE ON SCHEMA public TO service_role;


--
-- Name: SCHEMA realtime; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA realtime TO postgres;


--
-- Name: SCHEMA storage; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT ALL ON SCHEMA storage TO postgres;
GRANT USAGE ON SCHEMA storage TO anon;
GRANT USAGE ON SCHEMA storage TO authenticated;
GRANT USAGE ON SCHEMA storage TO service_role;
GRANT ALL ON SCHEMA storage TO supabase_storage_admin;
GRANT ALL ON SCHEMA storage TO dashboard_user;


--
-- Name: SCHEMA supabase_functions; Type: ACL; Schema: -; Owner: supabase_admin
--

GRANT USAGE ON SCHEMA supabase_functions TO postgres;
GRANT ALL ON SCHEMA supabase_functions TO supabase_functions_admin;


--
-- Name: FUNCTION email(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.email() TO dashboard_user;


--
-- Name: FUNCTION jwt(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.jwt() TO postgres;
GRANT ALL ON FUNCTION auth.jwt() TO dashboard_user;


--
-- Name: FUNCTION role(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.role() TO dashboard_user;


--
-- Name: FUNCTION uid(); Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON FUNCTION auth.uid() TO dashboard_user;


--
-- Name: FUNCTION algorithm_sign(signables text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.algorithm_sign(signables text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea) TO dashboard_user;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.armor(bytea, text[], text[]) TO dashboard_user;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.crypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.dearmor(text) TO dashboard_user;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.decrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.digest(text, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.encrypt_iv(bytea, bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_bytes(integer) TO dashboard_user;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_random_uuid() TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text) TO dashboard_user;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.gen_salt(text, integer) TO dashboard_user;


--
-- Name: FUNCTION grant_pg_cron_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_cron_access() TO dashboard_user;


--
-- Name: FUNCTION grant_pg_net_access(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.grant_pg_net_access() TO dashboard_user;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.hmac(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements(showtext boolean, OUT userid oid, OUT dbid oid, OUT toplevel boolean, OUT queryid bigint, OUT query text, OUT plans bigint, OUT total_plan_time double precision, OUT min_plan_time double precision, OUT max_plan_time double precision, OUT mean_plan_time double precision, OUT stddev_plan_time double precision, OUT calls bigint, OUT total_exec_time double precision, OUT min_exec_time double precision, OUT max_exec_time double precision, OUT mean_exec_time double precision, OUT stddev_exec_time double precision, OUT rows bigint, OUT shared_blks_hit bigint, OUT shared_blks_read bigint, OUT shared_blks_dirtied bigint, OUT shared_blks_written bigint, OUT local_blks_hit bigint, OUT local_blks_read bigint, OUT local_blks_dirtied bigint, OUT local_blks_written bigint, OUT temp_blks_read bigint, OUT temp_blks_written bigint, OUT blk_read_time double precision, OUT blk_write_time double precision, OUT temp_blk_read_time double precision, OUT temp_blk_write_time double precision, OUT wal_records bigint, OUT wal_fpi bigint, OUT wal_bytes numeric, OUT jit_functions bigint, OUT jit_generation_time double precision, OUT jit_inlining_count bigint, OUT jit_inlining_time double precision, OUT jit_optimization_count bigint, OUT jit_optimization_time double precision, OUT jit_emission_count bigint, OUT jit_emission_time double precision) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_info(OUT dealloc bigint, OUT stats_reset timestamp with time zone) TO dashboard_user;


--
-- Name: FUNCTION pg_stat_statements_reset(userid oid, dbid oid, queryid bigint); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pg_stat_statements_reset(userid oid, dbid oid, queryid bigint) TO dashboard_user;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_armor_headers(text, OUT key text, OUT value text) TO dashboard_user;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_key_id(bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt(text, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea) TO dashboard_user;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_pub_encrypt_bytea(bytea, bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_decrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt(text, text, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text) TO dashboard_user;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.pgp_sym_encrypt_bytea(bytea, text, text) TO dashboard_user;


--
-- Name: FUNCTION sign(payload json, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.sign(payload json, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION try_cast_double(inp text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.try_cast_double(inp text) TO dashboard_user;


--
-- Name: FUNCTION url_decode(data text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_decode(data text) TO dashboard_user;


--
-- Name: FUNCTION url_encode(data bytea); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.url_encode(data bytea) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v1mc() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v3(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v4() TO dashboard_user;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_generate_v5(namespace uuid, name text) TO dashboard_user;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_nil() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_dns() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_oid() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_url() TO dashboard_user;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.uuid_ns_x500() TO dashboard_user;


--
-- Name: FUNCTION verify(token text, secret text, algorithm text); Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON FUNCTION extensions.verify(token text, secret text, algorithm text) TO dashboard_user;


--
-- Name: FUNCTION comment_directive(comment_ text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO postgres;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO anon;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO authenticated;
GRANT ALL ON FUNCTION graphql.comment_directive(comment_ text) TO service_role;


--
-- Name: FUNCTION exception(message text); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.exception(message text) TO postgres;
GRANT ALL ON FUNCTION graphql.exception(message text) TO anon;
GRANT ALL ON FUNCTION graphql.exception(message text) TO authenticated;
GRANT ALL ON FUNCTION graphql.exception(message text) TO service_role;


--
-- Name: FUNCTION get_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.get_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.get_schema_version() TO service_role;


--
-- Name: FUNCTION increment_schema_version(); Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql.increment_schema_version() TO postgres;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO anon;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO authenticated;
GRANT ALL ON FUNCTION graphql.increment_schema_version() TO service_role;


--
-- Name: FUNCTION graphql("operationName" text, query text, variables jsonb, extensions jsonb); Type: ACL; Schema: graphql_public; Owner: supabase_admin
--

GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO postgres;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO anon;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO authenticated;
GRANT ALL ON FUNCTION graphql_public.graphql("operationName" text, query text, variables jsonb, extensions jsonb) TO service_role;


--
-- Name: FUNCTION http_collect_response(request_id bigint, async boolean); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_collect_response(request_id bigint, async boolean) TO postgres;


--
-- Name: FUNCTION http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_get(url text, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer); Type: ACL; Schema: net; Owner: supabase_admin
--

REVOKE ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) FROM PUBLIC;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO supabase_functions_admin;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO postgres;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO anon;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO authenticated;
GRANT ALL ON FUNCTION net.http_post(url text, body jsonb, params jsonb, headers jsonb, timeout_milliseconds integer) TO service_role;


--
-- Name: FUNCTION get_auth(p_usename text); Type: ACL; Schema: pgbouncer; Owner: postgres
--

REVOKE ALL ON FUNCTION pgbouncer.get_auth(p_usename text) FROM PUBLIC;
GRANT ALL ON FUNCTION pgbouncer.get_auth(p_usename text) TO pgbouncer;


--
-- Name: FUNCTION crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_decrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea); Type: ACL; Schema: pgsodium; Owner: pgsodium_keymaker
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_encrypt(message bytea, additional bytea, key_uuid uuid, nonce bytea) TO service_role;


--
-- Name: FUNCTION crypto_aead_det_keygen(); Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON FUNCTION pgsodium.crypto_aead_det_keygen() TO service_role;


--
-- Name: FUNCTION extension(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.extension(name text) TO anon;
GRANT ALL ON FUNCTION storage.extension(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.extension(name text) TO service_role;
GRANT ALL ON FUNCTION storage.extension(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.extension(name text) TO postgres;


--
-- Name: FUNCTION filename(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.filename(name text) TO anon;
GRANT ALL ON FUNCTION storage.filename(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.filename(name text) TO service_role;
GRANT ALL ON FUNCTION storage.filename(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.filename(name text) TO postgres;


--
-- Name: FUNCTION foldername(name text); Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON FUNCTION storage.foldername(name text) TO anon;
GRANT ALL ON FUNCTION storage.foldername(name text) TO authenticated;
GRANT ALL ON FUNCTION storage.foldername(name text) TO service_role;
GRANT ALL ON FUNCTION storage.foldername(name text) TO dashboard_user;
GRANT ALL ON FUNCTION storage.foldername(name text) TO postgres;


--
-- Name: FUNCTION http_request(); Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

REVOKE ALL ON FUNCTION supabase_functions.http_request() FROM PUBLIC;
GRANT ALL ON FUNCTION supabase_functions.http_request() TO postgres;


--
-- Name: TABLE audit_log_entries; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.audit_log_entries TO dashboard_user;
GRANT ALL ON TABLE auth.audit_log_entries TO postgres;


--
-- Name: TABLE identities; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.identities TO postgres;
GRANT ALL ON TABLE auth.identities TO dashboard_user;


--
-- Name: TABLE instances; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.instances TO dashboard_user;
GRANT ALL ON TABLE auth.instances TO postgres;


--
-- Name: TABLE mfa_amr_claims; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_amr_claims TO postgres;
GRANT ALL ON TABLE auth.mfa_amr_claims TO dashboard_user;


--
-- Name: TABLE mfa_challenges; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_challenges TO postgres;
GRANT ALL ON TABLE auth.mfa_challenges TO dashboard_user;


--
-- Name: TABLE mfa_factors; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.mfa_factors TO postgres;
GRANT ALL ON TABLE auth.mfa_factors TO dashboard_user;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.refresh_tokens TO dashboard_user;
GRANT ALL ON TABLE auth.refresh_tokens TO postgres;


--
-- Name: SEQUENCE refresh_tokens_id_seq; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO dashboard_user;
GRANT ALL ON SEQUENCE auth.refresh_tokens_id_seq TO postgres;


--
-- Name: TABLE saml_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_providers TO postgres;
GRANT ALL ON TABLE auth.saml_providers TO dashboard_user;


--
-- Name: TABLE saml_relay_states; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.saml_relay_states TO postgres;
GRANT ALL ON TABLE auth.saml_relay_states TO dashboard_user;


--
-- Name: TABLE schema_migrations; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.schema_migrations TO dashboard_user;
GRANT ALL ON TABLE auth.schema_migrations TO postgres;


--
-- Name: TABLE sessions; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sessions TO postgres;
GRANT ALL ON TABLE auth.sessions TO dashboard_user;


--
-- Name: TABLE sso_domains; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_domains TO postgres;
GRANT ALL ON TABLE auth.sso_domains TO dashboard_user;


--
-- Name: TABLE sso_providers; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.sso_providers TO postgres;
GRANT ALL ON TABLE auth.sso_providers TO dashboard_user;


--
-- Name: TABLE users; Type: ACL; Schema: auth; Owner: supabase_auth_admin
--

GRANT ALL ON TABLE auth.users TO dashboard_user;
GRANT ALL ON TABLE auth.users TO postgres;


--
-- Name: TABLE pg_stat_statements; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements TO dashboard_user;


--
-- Name: TABLE pg_stat_statements_info; Type: ACL; Schema: extensions; Owner: postgres
--

GRANT ALL ON TABLE extensions.pg_stat_statements_info TO dashboard_user;


--
-- Name: SEQUENCE seq_schema_version; Type: ACL; Schema: graphql; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE graphql.seq_schema_version TO postgres;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO anon;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO authenticated;
GRANT ALL ON SEQUENCE graphql.seq_schema_version TO service_role;


--
-- Name: TABLE decrypted_key; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.decrypted_key TO pgsodium_keyholder;


--
-- Name: TABLE masking_rule; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.masking_rule TO pgsodium_keyholder;


--
-- Name: TABLE mask_columns; Type: ACL; Schema: pgsodium; Owner: supabase_admin
--

GRANT ALL ON TABLE pgsodium.mask_columns TO pgsodium_keyholder;


--
-- Name: TABLE decrypted_secrets; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.decrypted_secrets TO postgres;
GRANT ALL ON TABLE public.decrypted_secrets TO anon;
GRANT ALL ON TABLE public.decrypted_secrets TO authenticated;
GRANT ALL ON TABLE public.decrypted_secrets TO service_role;


--
-- Name: TABLE fun_logs; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.fun_logs TO postgres;
GRANT ALL ON TABLE public.fun_logs TO anon;
GRANT ALL ON TABLE public.fun_logs TO authenticated;
GRANT ALL ON TABLE public.fun_logs TO service_role;


--
-- Name: SEQUENCE fun_logs_id_seq; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON SEQUENCE public.fun_logs_id_seq TO postgres;
GRANT ALL ON SEQUENCE public.fun_logs_id_seq TO anon;
GRANT ALL ON SEQUENCE public.fun_logs_id_seq TO authenticated;
GRANT ALL ON SEQUENCE public.fun_logs_id_seq TO service_role;


--
-- Name: TABLE get_secrets; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.get_secrets TO postgres;
GRANT ALL ON TABLE public.get_secrets TO anon;
GRANT ALL ON TABLE public.get_secrets TO authenticated;
GRANT ALL ON TABLE public.get_secrets TO service_role;


--
-- Name: TABLE secrets; Type: ACL; Schema: public; Owner: supabase_admin
--

GRANT ALL ON TABLE public.secrets TO postgres;
GRANT ALL ON TABLE public.secrets TO anon;
GRANT ALL ON TABLE public.secrets TO authenticated;
GRANT ALL ON TABLE public.secrets TO service_role;


--
-- Name: TABLE buckets; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.buckets TO anon;
GRANT ALL ON TABLE storage.buckets TO authenticated;
GRANT ALL ON TABLE storage.buckets TO service_role;
GRANT ALL ON TABLE storage.buckets TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.migrations TO anon;
GRANT ALL ON TABLE storage.migrations TO authenticated;
GRANT ALL ON TABLE storage.migrations TO service_role;
GRANT ALL ON TABLE storage.migrations TO postgres;


--
-- Name: TABLE objects; Type: ACL; Schema: storage; Owner: supabase_storage_admin
--

GRANT ALL ON TABLE storage.objects TO anon;
GRANT ALL ON TABLE storage.objects TO authenticated;
GRANT ALL ON TABLE storage.objects TO service_role;
GRANT ALL ON TABLE storage.objects TO postgres;


--
-- Name: TABLE hooks; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.hooks TO postgres;


--
-- Name: SEQUENCE hooks_id_seq; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON SEQUENCE supabase_functions.hooks_id_seq TO postgres;


--
-- Name: TABLE migrations; Type: ACL; Schema: supabase_functions; Owner: supabase_functions_admin
--

GRANT ALL ON TABLE supabase_functions.migrations TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: auth; Owner: supabase_auth_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_auth_admin IN SCHEMA auth GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: graphql_public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA graphql_public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON SEQUENCES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium GRANT ALL ON TABLES  TO pgsodium_keyholder;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON SEQUENCES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON FUNCTIONS  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: pgsodium_masks; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA pgsodium_masks GRANT ALL ON TABLES  TO pgsodium_keyiduser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA public GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON SEQUENCES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON FUNCTIONS  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: realtime; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA realtime GRANT ALL ON TABLES  TO dashboard_user;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON SEQUENCES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON FUNCTIONS  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: storage; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO postgres;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO anon;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO authenticated;
ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA storage GRANT ALL ON TABLES  TO service_role;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON SEQUENCES  TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON FUNCTIONS  TO postgres;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: supabase_functions; Owner: supabase_admin
--

ALTER DEFAULT PRIVILEGES FOR ROLE supabase_admin IN SCHEMA supabase_functions GRANT ALL ON TABLES  TO postgres;


--
-- Name: issue_graphql_placeholder; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_graphql_placeholder ON sql_drop
         WHEN TAG IN ('DROP EXTENSION')
   EXECUTE FUNCTION extensions.set_graphql_placeholder();


ALTER EVENT TRIGGER issue_graphql_placeholder OWNER TO supabase_admin;

--
-- Name: issue_pg_cron_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_cron_access ON ddl_command_end
         WHEN TAG IN ('CREATE SCHEMA')
   EXECUTE FUNCTION extensions.grant_pg_cron_access();


ALTER EVENT TRIGGER issue_pg_cron_access OWNER TO postgres;

--
-- Name: issue_pg_graphql_access; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER issue_pg_graphql_access ON ddl_command_end
         WHEN TAG IN ('CREATE FUNCTION')
   EXECUTE FUNCTION extensions.grant_pg_graphql_access();


ALTER EVENT TRIGGER issue_pg_graphql_access OWNER TO supabase_admin;

--
-- Name: issue_pg_net_access; Type: EVENT TRIGGER; Schema: -; Owner: postgres
--

CREATE EVENT TRIGGER issue_pg_net_access ON ddl_command_end
         WHEN TAG IN ('CREATE EXTENSION')
   EXECUTE FUNCTION extensions.grant_pg_net_access();


ALTER EVENT TRIGGER issue_pg_net_access OWNER TO postgres;

--
-- Name: pgrst_ddl_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_ddl_watch ON ddl_command_end
   EXECUTE FUNCTION extensions.pgrst_ddl_watch();


ALTER EVENT TRIGGER pgrst_ddl_watch OWNER TO supabase_admin;

--
-- Name: pgrst_drop_watch; Type: EVENT TRIGGER; Schema: -; Owner: supabase_admin
--

CREATE EVENT TRIGGER pgrst_drop_watch ON sql_drop
   EXECUTE FUNCTION extensions.pgrst_drop_watch();


ALTER EVENT TRIGGER pgrst_drop_watch OWNER TO supabase_admin;

--
-- PostgreSQL database dump complete
--

--
-- PostgreSQL database cluster dump complete
--

