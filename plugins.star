MAIN_BRANCH = "main"
MASTER_BRANCH = "master"
STDLIB_PLUGIN_REPO = "Significant-Gravitas/Auto-GPT-Plugins"
ZIP_EXTENSION = ".zip"

plugins_map = {
    # begin standard plugins
    "AutoGPTTwitter": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTEmailPlugin": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTSceneXPlugin": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTBingSearch": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTNewsSearch": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTWikipediaSearch": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTApiTools": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTRandomValues": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTSpacePlugin": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    # end of standard plugins
    "AutoGPTAlpacaTraderPlugin": {"repository": "danikhan632/Auto-GPT-AlpacaTrader-Plugin", "branch": MASTER_BRANCH},
    "AutoGPTUserInput": {"repository": "HFrovinJensen/Auto-GPT-User-Input-Plugin", "branch": MASTER_BRANCH},
    "BingAI": {"repository": "gravelBridge/AutoGPT-BingAI", "branch": MAIN_BRANCH},
    "AutoGPTCryptoPlugin": {"repository": "isaiahbjork/Auto-GPT-Crypto-Plugin", "branch": MASTER_BRANCH},
    "AutoGPTDiscord": {"repository": "gravelBridge/AutoGPT-Discord", "branch": MAIN_BRANCH},
    "AutoGPTDollyPlugin": {"repository": "pr-0f3t/Auto-GPT-Dolly-Plugin", "branch": MASTER_BRANCH},
    "AutoGPTGoogleAnalyticsPlugin": {"repository": "isaiahbjork/Auto-GPT-Google-Analytics-Plugin", "branch": MASTER_BRANCH},
    "AutoGPT_IFTTT": {"repository": "AntonioCiolino/AutoGPT-IFTTT", "branch": MASTER_BRANCH},
    "AutoGPT_YouTube": {"repository": "jpetzke/AutoGPT-YouTube", "branch": MASTER_BRANCH},
    "AutoGPTPMPlugin": {"repository": "minfenglu/AutoGPT-PM-Plugin", "branch": "main"},
    "AutoGPTWolframAlpha": {"repository":"gravelBridge/AutoGPT-WolframAlpha", "branch": "main"},
}

def get_plugin_url(plugin_data, plugin_branch_to_use, plugin_repo_to_use):
    repo = plugin_data["repository"]
    if plugin_repo_to_use:
        repo = plugin_repo_to_use
    branch = plugin_data["branch"]
    if plugin_branch_to_use:
        branch = plugin_branch_to_use
    return "https://github.com/{0}/archive/refs/heads/{1}.zip".format(repo, branch)

def get_filename(plugin):
    author, actual_repo = plugin["repository"].split("/")
    return actual_repo + ZIP_EXTENSION
