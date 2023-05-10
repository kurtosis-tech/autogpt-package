MASTER_BRANCH = "master"
STDLIB_PLUGIN_REPO = "Significant-Gravitas/Auto-GPT-Plugins"
STDLIB_OF_PLUGINS_FILENAME = "Auto-GPT-Plugins.zip"

plugins_map = {
    "twitter": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "email": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "scenex": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "bing_search": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "news_search": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "wikipedia_search": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "api_tools": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "random_values": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": STDLIB_PLUGIN_REPO, "repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH},
    "AutoGPTGoogleAnalyticsPlugin": {"name": "AutoGPTGoogleAnalyticsPlugin", "repository": "isaiahbjork/Auto-GPT-Google-Analytics-Plugin", "branch": MASTER_BRANCH},
}

def get_plugin_url(plugin_data, plugin_branch_to_use, plugin_repo_to_use):
    repo = plugin_data["repository"]
    if plugin_repo_to_use:
        repo = plugin_repo_to_use
    branch = plugin_data["branch"]
    if plugin_branch_to_use:
        branch = plugin_branch_to_use
    return "https://github.com/{0}/archive/refs/heads/{1}.zip".format(repo, branch)
