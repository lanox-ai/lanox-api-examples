# lanox-api-examples

Official code examples for the LanoX API (OpenAI-compatible): Python, Node.js and curl. Each example sends one Chat Completions request to `POST https://api.lanox.ai/v1/chat/completions` and prints the reply.

## Before you start

1. Create an API key: “Create it in the console; after creation, you can copy it again from the API Key list.” Create an API key
2. Pick a model ID: “Copy an exact ID from Models & pricing instead of guessing.” See the Models & pricing page. `GET /v1/models` lists models for your key, filtered by API-key permissions.
3. Set your API key:

   ```bash
   export API_KEY="your-lanox-api-key"
   ```

   **Warning:** “Your API key is a credential. Never share it publicly or commit it to a repository.”

## Connection values

| Use | Value |
|---|---|
| Base host | `https://api.lanox.ai` |
| Codex / OpenAI Compatible base URL | `https://api.lanox.ai/v1` |
| Claude Code | `https://api.lanox.ai` (without `/v1`) |
| Auth | Bearer Token |
| Header | `Authorization: Bearer $API_KEY` |

## Quick start

Minimal request:

```bash
curl -X POST "https://api.lanox.ai/v1/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.6-sol",
    "messages": [{"role": "user", "content": [{"type": "text", "text": "Say hello in one sentence."}]}]
  }'
```

### Official tool-calling example

Copied from the LanoX docs:

```bash
curl -X POST "https://api.lanox.ai/v1/chat/completions" \
  -H "Authorization: Bearer $API_KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "gpt-5.6-sol",
    "messages": [{"role": "user", "content": [{"type": "text", "text": "Check the weather in Shanghai"}]}],
    "tools": [{
      "type": "function",
      "function": {
        "name": "get_weather",
        "description": "Look up the weather for a city",
        "parameters": {
          "type": "object",
          "properties": {"city": {"type": "string"}},
          "required": ["city"],
          "additionalProperties": false
        },
        "strict": true
      }
    }],
    "tool_choice": "auto",
    "temperature": 0.2,
    "max_completion_tokens": 300,
    "stream": false
  }'
```

## Python

LanoX lists a "Codex / OpenAI Compatible" base URL (`https://api.lanox.ai/v1`). The Python example points the official OpenAI Python SDK at that base URL. The LanoX docs do not name a specific SDK. The OpenAI Python SDK requires Python 3.10 or higher.

Install it:

```bash
pip install openai
# or: pip install -r requirements.txt
```

Run it:

```bash
python examples/chat_completions.py
```

## Node.js

The Node.js example points the official OpenAI Node.js SDK at the same base URL. It is an ES module (`.mjs`), so no build step is needed. The OpenAI Node.js SDK lists Node.js 22 as the minimum supported version.

Install it:

```bash
npm install openai
```

Run it:

```bash
node examples/chat_completions.mjs
```

## curl

Run the minimal request (prints the HTTP status and the response body; also prints the reply text if `jq` is installed):

```bash
bash examples/chat_completions.sh
```

Run the official tool-calling example from the LanoX docs:

```bash
bash examples/chat_completions.sh tools
```

## Using Codex or Claude Code

“Yes. For Codex, use https://api.lanox.ai/v1 and configure the Responses API as described in the documentation. For Claude Code, use https://api.lanox.ai without /v1. Both require a LanoX API key and a model ID that supports the client's API format; follow the LanoX CC Switch guide for setup instructions.”

See the Codex guide and Claude Code guide. Follow those guides for configuration instructions.

## Model IDs

Copy an exact ID from the live catalog instead of guessing. The models you can call depend on your key: `GET /v1/models` returns the list filtered by API-key permissions. `gpt-5.6-sol` is the model used in the official docs example as of 2026-11-12. To use another model, change `MODEL` / `model` in the example files.

## Notes

“A disconnected stream does not mean that the request was not executed. Evaluate the risk of a duplicate request before retrying.”

On an error, the examples print the HTTP status and the response body as returned by the API. See the API errors guide for error guidance.

## Docs

- LanoX docs
- Models & pricing

Written from the official LanoX docs as of 2026-11-12; check the docs for the latest values.

## License

MIT, see [LICENSE](LICENSE).
