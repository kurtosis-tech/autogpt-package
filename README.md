# Auto-GPT Package

"It's like AutoGPT got a `brew install`", made possible by [Kurtosis](https://www.kurtosis.com/).

Assuming you have [Kurtosis installed](https://docs.kurtosis.com/install), simply run the following with your OpenAI API key:

```bash
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "<YOUR_API_KEY_HERE>"}'
kurtosis service shell autogpt autogpt --exec "python -m autogpt"
```

To run this on Kurtosis on GitPod click [here](https://gitpod.io/?editor=code#https://github.com/kurtosis-tech/autogpt-package). This doesn't
require a local installation of Kurtosis.

We use the `Redis` memory backend by default.

## How to get the OpenAI API Key

Follow along the official guide [here](https://github.com/Significant-Gravitas/Auto-GPT#%EF%B8%8F-openai-api-keys-configuration-%EF%B8%8F)


## How to pass other configuration

To pass any other configuration listed [here](https://github.com/Significant-Gravitas/Auto-GPT/blob/master/.env.template); pass the argument
wrapped inside a dictionary called `env` for example to change `RESTRICT_TO_WORKSPACE` to `False` run using

```bash
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "<YOUR_API_KEY_HERE>", "env": {"RESTRICT_TO_WORKSPACE": "False"}}'
```

Note - This package spins up AutoGPT using the `Redis` backend. To use the local backend instead set `MEMORY_BACKEND` to `local` in `args.env`. For `pinecone` and `milvus` you will need to get API keys for it and pass it. `Weaviate` isn't supported yet. For any other backend apart from `redis`; the `Redis` server will still be spun up but won't be used.

## Feedback or Questions?

Let us know in our [Discord](https://discord.gg/eBWFjGtm) or on [Twitter @KurtosisTech](https://twitter.com/KurtosisTech)!
