# Auto-GPT package

Its like AutoGPt got a brew install

Assuming you have the Kurtosis CLI installed and running simply do

```
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"openai-api-key": "<YOUR_API_KEY_HERE>"}'
echo "python -m autogpt" | kurtosis service shell autogpt autogpt
```


## How to get the OpenAI API Key

Follow along the official guide [here](https://github.com/Significant-Gravitas/Auto-GPT#%EF%B8%8F-openai-api-keys-configuration-%EF%B8%8F)