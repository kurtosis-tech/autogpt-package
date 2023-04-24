# Auto-GPT Package

![Run of the Auto-GPT Package](/run.gif)

"It's like AutoGPT got a `brew install`", made possible by [Kurtosis](https://www.kurtosis.com/).

Assuming you have [Kurtosis installed](https://docs.kurtosis.com/install), simply run the following with your OpenAI API key:

```bash
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "<YOUR_API_KEY_HERE>"}'
kurtosis service shell autogpt autogpt --exec "python -m autogpt"
```

We use the `Redis` memory backend by default.

## Run On GitPod in the browser


To run this on Kurtosis on GitPod click [here](https://gitpod.io/?editor=code#https://github.com/kurtosis-tech/autogpt-package). This doesn't
require a local installation of Kurtosis.


## How to get the OpenAI API Key

Follow along the official guide [here](https://significant-gravitas.github.io/Auto-GPT/installation/#:~:text=%F0%9F%92%BE%20Installation-,%E2%9A%A0%EF%B8%8F%20OpenAI%20API%20Keys%20Configuration,-Get%20your%20OpenAI)


## How to pass other configuration

To pass any other configuration listed [here](https://github.com/Significant-Gravitas/Auto-GPT/blob/master/.env.template); pass the argument like you pass the `OPENAI_API_KEY`

```bash
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "<YOUR_API_KEY_HERE>", "RESTRICT_TO_WORKSPACE": "False"}'
```

Note - This package spins up AutoGPT using the `Redis` backend by default. To use the local backend instead set `MEMORY_BACKEND` to `local` in `args`. For `pinecone` and `milvus` you will need to get API keys for it and pass it. `Weaviate` is supported both locally & remotely.

## Feedback or Questions?

Let us know in our [Discord](https://discord.gg/eBWFjGtm) or on [Twitter @KurtosisTech](https://twitter.com/KurtosisTech)!
