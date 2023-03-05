import { Handlers, PageProps } from "$fresh/server.ts";

const NAMES = ["Alice", "Bob", "Charlie", "Dave", "Eve", "Frank"];

interface Data {
  result: string;
  query: string;
}

export const handler: Handlers<Data> = {
  //   GET(req, ctx) {
  //     const url = new URL(req.url);
  //     const query = url.searchParams.get("q") || "";
  //     const results = NAMES.filter((name) => name.includes(query));
  //     return ctx.render({ results, query });
  //   },
  async GET(req, ctx) {
    const url = new URL(req.url);
    const query = url.searchParams.get("q") || "";
    const resp = await fetch(
      `https://223fc012.tictapp.fun/openai?query=${query}`,
    );
    if (resp.status === 404) {
      return ctx.render(null);
    }
    const result = await resp.text();
    return ctx.render({ result, query });
  },
};

export default function Page({ data }: PageProps<Data>) {
  if (!data) {
    return <h1>Not ok</h1>;
  }

  const { result, query } = data;

  return (
    <div className="bg-gray-900 text-gray-500 w-full h-full flex flex-col absolute inset-0">
      <div className="bg-gray-800">
        <form className="w-full">
          <input
            className="w-full bg-gray-800 text-lg p-4 text-gray-300"
            type="text"
            name="q"
            value={query}
          />
          {/* <button type="submit">Search</button> */}
        </form>
      </div>
      <div className="p-4 font-mono whitespace-pre-line">{result}</div>
    </div>
  );
}
