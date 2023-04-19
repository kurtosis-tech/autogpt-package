# Auto-GPT package

Its like AutoGPt got a brew install

Assuming you have the Kurtosis CLI installed and running simply do

```
kurotsis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"openai-api-key": "<YOUR_API_KEY_HERE>"}'
echo "python -m autogpt" | kurtosis service shell autogpt autogpt
```