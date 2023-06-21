# Auto-GPT Package

![Run of the Auto-GPT Package](/run.gif)

"It's like AutoGPT got a `brew install`", made possible by [Kurtosis](https://www.kurtosis.com/).

**NOTE**: This now runs with 0.4.0 that drops support for Milvus, Weaviate and PineCone. You can run Kurtosis against 0.3.1 by doing `kurtosis run github.com/kurtosis-tech/autogpt-package@0.3.1` with the desired arguments

## Run AutoGPT in the browser (no installation needed)

1. If you don't have an OpenAI API key, get one [here](https://platform.openai.com/account/api-keys)
1. Click [this link](https://gitpod.io/?editor=code#https://github.com/kurtosis-tech/autogpt-package) to open a Gitpod, selecting "Continue" to use the default resources
1. Wait for the Gitpod to boot up and the terminal to finish installing Kurtosis (should take ~30 seconds)
1. Run the following in the terminal (replacing `YOUR_API_KEY_HERE` with your OpenAI API key)
   ```bash
   kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "YOUR_API_KEY_HERE"}'
   ```
1. When installing & starting AutoGPT has finished, run the following in the terminal to open the AutoGPT prompt:
   ```bash
   kurtosis service shell autogpt autogpt --exec "python -m autogpt"
   ```
1. Use AutoGPT as you please!

![Run of the Auto-GPT Package](/gitpod.png)

## Run AutoGPT on your machine

1. If you don't have an OpenAI API key, get one [here](https://platform.openai.com/account/api-keys)
1. Install Kurtosis using [these instructions](https://docs.kurtosis.com/install)
1. Run the following in your terminal (replacing `YOUR_API_KEY_HERE` with your OpenAI API key)
   ```bash
   kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "YOUR_API_KEY_HERE"}'
   ```
1. When installing & starting AutoGPT has finished, run the following in your terminal to open the AutoGPT prompt:
   ```bash
   kurtosis service shell autogpt autogpt
   ```
and then within the prompt:
   ```bash
   > python -m autogpt
   ```
1. Use AutoGPT as you please! To destroy the AutoGPT instance, run:
   ```
   kurtosis enclave rm -f autogpt
   ```

## Configuring AutoGPT (including memory backend)

To pass any of the AutoGPT configuration values listed [here](https://github.com/Significant-Gravitas/Auto-GPT/blob/master/.env.template), pass the argument as a property of the JSON object you're passing to Kurtosis just like you passed in `OPENAI_API_KEY`.

For example, this is how you'd pass the `RESTRICT_TO_WORKSPACE` flag:

```bash
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "YOUR_API_KEY_HERE", "RESTRICT_TO_WORKSPACE": "False"}'
```

**NOTE:** this package spins up AutoGPT using the `local` backend by default. Other backends are available by setting the `MEMORY_BACKEND` parameter in the JSON object you pass in when you run the `kurtosis run` command above. 

For example, to set the `redis` memory backend:

```bash
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "YOUR_API_KEY_HERE", "MEMORY_BACKEND": "redis"}'
```

**NOTE**: Redis isn't working with 0.4.0 for now

To run with a different image other than the one hardcoded in `main.star` use
```bash
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "YOUR_API_KEY_HERE", "AUTOGPT_IMAGE": "significantgravitas/auto-gpt:v0.4.0"}'
```

## Using AutoGPT plugins

Kurtosis supports the `ALLOWLISTED_PLUGINS` configuration flag that AutoGPT ships with. For example, to run the `AutoGPTTwitter` plugin do the following:

```bash
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "YOUR_API_KEY_HERE", "ALLOWLISTED_PLUGINS": "AutoGPTTwitter"}'
```

To get multiple plugins running at the same time; separate them with comma without spaces like so:

```
kurtosis run github.com/kurtosis-tech/autogpt-package --enclave autogpt '{"OPENAI_API_KEY": "YOUR_API_KEY_HERE", "ALLOWLISTED_PLUGINS": "AutoGPTTwitter,AutoGPTEmailPlugin"}'
```

Under the hood, Kurtosis will download and install the package for you. 

As of now the following plugins are supported:

### First Party
- [AutoGPTTwitter](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTEmailPlugin](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTSceneXPlugin](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTBingSearch](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTNewsSearch](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTWikipediaSearch](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTApiTools](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTRandomValues](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTSpacePlugin](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTBaiduSearch](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTBluesky](https://github.com/Significant-Gravitas/Auto-GPT-Plugins)
- [AutoGPTAlpacaTraderPlugin](https://github.com/danikhan632/Auto-GPT-AlpacaTrader-Plugin)
- [AutoGPTUserInput](https://github.com/HFrovinJensen/Auto-GPT-User-Input-Plugin)
- [BingAI](https://github.com/gravelBridge/AutoGPT-BingAI)
- [AutoGPTCryptoPlugin](https://github.com/isaiahbjork/Auto-GPT-Crypto-Plugin)
- [AutoGPTDiscord](https://github.com/gravelBridge/AutoGPT-Discord)
- [AutoGPTDollyPlugin](https://github.com/pr-0f3t/Auto-GPT-Dolly-Plugin)

### Third Party
- [AutoGPTGoogleAnalyticsPlugin](https://github.com/isaiahbjork/Auto-GPT-Google-Analytics-Plugin)
- [AutoGPT_IFTTT](https://github.com/AntonioCiolino/AutoGPT-IFTTT)
- [AutoGPT_Zapier](https://github.com/AntonioCiolino/AutoGPT-Zapier)
- [AutoGPT_YouTube](https://github.com/jpetzke/AutoGPT-YouTube)
- [AutoGPTPMPlugin](https://github.com/minfenglu/AutoGPT-PM-Plugin)
- [AutoGPTWolframAlpha](https://github.com/gravelBridge/AutoGPT-WolframAlpha)
- [AutoGPTTodoistPlugin](https://github.com/danikhan632/Auto-GPT-Todoist-Plugin)
- [AutoGPTMessagesPlugin](https://github.com/danikhan632/Auto-GPT-Messages-Plugin)
- [AutoGPTWebInteraction](https://github.com/gravelBridge/AutoGPT-Web-Interaction)
- [AutoGPTNotion](https://github.com/doutv/Auto-GPT-Notion)
- [SystemInformationPlugin](https://github.com/hdkiller/Auto-GPT-SystemInfo)

To add support for more plugins, simply create an issue or create a PR adding an entry to [`plugins.star`](https://github.com/kurtosis-tech/autogpt-package/blob/main/plugins.star).

## Run without OpenAI

We understand OpenAI can be expensive for some people; more-ever some people might be trying to use this with their own models. AutoGPT-Package supports running AutoGPT against a `GPT4All` model that runs via `LocalAI`. To use a local model -

```bash
kurtosis run github.com/kurtosis-tech/autogpt-package '{"GPT_4ALL": true}'
```

This uses the `https://gpt4all.io/models/ggml-gpt4all-j.bin` model default

To use a different model try the `MODEL_URL` parameter like -


```bash
kurtosis run github.com/kurtosis-tech/autogpt-package '{"GPT_4ALL": true, "MODEL_URL": "https://gpt4all.io/models/ggml-gpt4all-l13b-snoozy.bin"}'
```

## Development

To develop on this package, clone this repo and run the following:

```bash
kurtosis run . --enclave autogpt '{"OPENAI_API_KEY": "YOUR_API_KEY_HERE"}'
```

Note the `.` - this tells Kurtosis to use the version of the package on your local machine (rather than the version on Github).

Kurtosis also has [an extension available on the VSCode marketplace](https://marketplace.visualstudio.com/items?itemName=Kurtosis.kurtosis-extension) that provides syntax highlighting and autocompletion for the Starlark that this package is composed of.

## Feedback or Questions?

Let us know in our [Discord](https://discord.gg/eBWFjGtm) or on [Twitter @KurtosisTech](https://twitter.com/KurtosisTech)!

Feel free to create an issue on GitHub if you have any bugs or feature requests.
