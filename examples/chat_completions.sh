#!/usr/bin/env bash
set -euo pipefail

# Chat Completions request to LanoX with curl.
# Usage: bash examples/chat_completions.sh          # minimal request
#        bash examples/chat_completions.sh tools    # official tool-calling example from the LanoX docs

: "${API_KEY:?Set API_KEY first}"

mode="${1:-minimal}"
tmp_body="$(mktemp)"
trap 'rm -f "$tmp_body"' EXIT

if [[ "$mode" == "tools" ]]; then
  request_body='{
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
else
  request_body='{
    "model": "gpt-5.6-sol",
    "messages": [{"role": "user", "content": [{"type": "text", "text": "Say hello in one sentence."}]}]
  }'
fi

status="$(
  curl -sS \
    -o "$tmp_body" \
    -w "%{http_code}" \
    -X POST "https://api.lanox.ai/v1/chat/completions" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$request_body"
)"

echo "HTTP $status"
cat "$tmp_body"
echo

if (( status < 200 || status >= 300 )); then
  exit 1
fi

if [[ "$mode" == "minimal" ]] && command -v jq >/dev/null 2>&1; then
  jq -r '.choices[0].message.content' "$tmp_body"
fi
