# Auto-GPT Package

"Its like AutoGPt got a `brew install`", made possible by [Kurtosis](https://www.kurtosis.com/).

Assuming you have [Kurtosis installed](https://docs.kurtosis.com/install), simply run the following with your OpenAI API key:

```
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"openai-api-key": "<YOUR_API_KEY_HERE>"}'
echo "python -m autogpt" | kurtosis service shell autogpt autogpt
```

## How to get the OpenAI API Key

Follow along the official guide [here](https://github.com/Significant-Gravitas/Auto-GPT#%EF%B8%8F-openai-api-keys-configuration-%EF%B8%8F)

## Feedback or Questions?

Let us know in our [Discord](https://discord.gg/eBWFjGtm) or on [Twitter @KurtosisTech](https://twitter.com/KurtosisTech)!
