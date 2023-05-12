MASTER_BRANCH = "master"
STDLIB_PLUGIN_REPO = "Significant-Gravitas/Auto-GPT-Plugins"
STDLIB_OF_PLUGINS_FILENAME = "Auto-GPT-Plugins.zip"

plugins_map = {
    "AutoGPTTwitter": {"author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTEmailPlugin": {"author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTSceneXPlugin": {"author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTBingSearch": {"author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTNewsSearch": {"author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTWikipediaSearch": {"author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTApiTools": {"author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTRandomValues": {"author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTSpacePlugin": {"author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTGoogleAnalyticsPlugin": {"repository": "isaiahbjork/Auto-GPT-Google-Analytics-Plugin", "branch": MASTER_BRANCH},
    "AutoGPTAlpacaTraderPlugin": {"repository": "danikhan632/Auto-GPT-AlpacaTrader-Plugin", "branch": MASTER_BRANCH},
    "AutoGPTUserInput": {"repository": "HFrovinJensen/Auto-GPT-User-Input-Plugin", "branch": MASTER_BRANCH}
    "BingAI": {"repository": "gravelBridge/AutoGPT-BingAI", "branch": MASTER_BRANCH},
    "AutoGPTCryptoPlugin": {"repository": "isaiahbjork/Auto-GPT-Crypto-Plugin", "branch": MASTER_BRANCH},
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
    author, repo = plugin["repo"].split("/")
    return repo