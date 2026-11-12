#!/usr/bin/env python3
"""Minimal Chat Completions request to LanoX with the official OpenAI Python SDK.

Run: pip install openai && python examples/chat_completions.py
"""

import os
import sys

import openai
from openai import OpenAI

if not os.environ.get("API_KEY"):
    print("API_KEY is not set. Set it before running this example.", file=sys.stderr)
    sys.exit(1)

# Copy an exact model ID from https://lanox.ai/en/model-pricing
MODEL = "gpt-5.6-sol"

client = OpenAI(
    api_key=os.environ["API_KEY"],
    base_url="https://api.lanox.ai/v1",
)

try:
    completion = client.chat.completions.create(
        model=MODEL,
        messages=[
            {
                "role": "user",
                "content": [
                    {"type": "text", "text": "Say hello in one sentence."}
                ],
            }
        ],
    )
    print(completion.choices[0].message.content)
except openai.APIStatusError as e:
    print(f"HTTP {e.status_code}", file=sys.stderr)
    print(e.response.text, file=sys.stderr)
    sys.exit(1)
except openai.APIConnectionError as e:
    print("The server could not be reached.", file=sys.stderr)
    print(e.__cause__, file=sys.stderr)
    sys.exit(1)
