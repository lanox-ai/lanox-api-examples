// Minimal Chat Completions request to LanoX with the official OpenAI Node.js SDK.
// Run: npm install openai && node examples/chat_completions.mjs
import OpenAI from 'openai';

if (!process.env.API_KEY) {
  console.error('API_KEY is not set. Set it before running this example.');
  process.exit(1);
}

// Copy an exact model ID from https://lanox.ai/en/model-pricing
const MODEL = 'gpt-5.6-sol';

const client = new OpenAI({
  apiKey: process.env.API_KEY,
  baseURL: 'https://api.lanox.ai/v1',
});

try {
  const completion = await client.chat.completions.create({
    model: MODEL,
    messages: [
      {
        role: 'user',
        content: [{ type: 'text', text: 'Say hello in one sentence.' }],
      },
    ],
  });
  console.log(completion.choices[0].message.content);
} catch (err) {
  if (err instanceof OpenAI.APIError) {
    // err.status is undefined when the server could not be reached.
    console.error(`HTTP ${err.status ?? 'n/a'}`);
    console.error(err.error ?? err.message);
    process.exitCode = 1;
  } else {
    throw err;
  }
}
