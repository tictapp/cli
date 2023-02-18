export class APIError extends Error {
    code = '';
    xDenoRay = '';

    name = "APIError";

    constructor(code, message, xDenoRay) {
        super(message);
        this.code = code;
        this.xDenoRay = xDenoRay;
    }

    toString() {
        let error = `${this.name}: ${this.message}`;
        if (this.xDenoRay !== null) {
            error += `\nx-deno-ray: ${this.xDenoRay}`;
            error += "\nIf you encounter this error frequently," +
                " contact us at deploy@deno.com with the above x-deno-ray.";
        }
        return error;
    }
}

export class API {
    endpoint = '';
    authorization = '';

    constructor(authorization, endpoint) {
        this.authorization = authorization;
        this.endpoint = endpoint;
    }

    static fromToken(token) {
        const endpoint = Deno.env.get("DEPLOY_API_ENDPOINT") ??
            "https://dash.deno.com";
        return new API(`Bearer ${token}`, endpoint);
    }

    async request(path, opts = {}) {
        const url = `${this.endpoint}/api${path}`;
        const method = opts.method ?? "GET";
        const body = opts.body !== undefined
            ? opts.body instanceof FormData ? opts.body : JSON.stringify(opts.body)
            : undefined;
        const headers = {
            "Accept": "application/json",
            "Authorization": this.authorization,
            ...(opts.body !== undefined
                ? opts.body instanceof FormData
                    ? {}
                    : { "Content-Type": "application/json" }
                : {}),
        };
        return await fetch(url, { method, headers, body });
    }

    async requestJson(path, opts) {
        const res = await this.request(path, opts);
        if (res.headers.get("Content-Type") !== "application/json") {
            const text = await res.text();
            throw new Error(`Expected JSON, got '${res.headers.get("Content-Type")}'`);
        }
        const json = await res.json();
        if (res.status !== 200) {
            const xDenoRay = res.headers.get("x-deno-ray");
            throw new APIError(json.code, json.message, xDenoRay);
        }
        return json;
    }

    async getProject(id) {
        try {
            return await this.requestJson(`/projects/${id}`);
        } catch (err) {
            if (err instanceof APIError && err.code === "projectNotFound") {
                return null;
            }
            throw err;
        }
    }

}