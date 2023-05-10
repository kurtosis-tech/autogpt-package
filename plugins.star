MASTER_BRANCH = "master"
SIGNIFICANT_GRAVITAS_AUTHOR = "Significant-Gravitas"
STDLIB_OF_PLUGINS_FILENAME = "Auto-GPT-Plugins.zip"

plugins_map = {
    "twitter": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": SIGNIFICANT_GRAVITAS_AUTHOR, "repository-name": "Auto-GPT-Plugins", "branch": MASTER_BRANCH},
    "email": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": SIGNIFICANT_GRAVITAS_AUTHOR, "repository-name": "Auto-GPT-Plugins", "branch": MASTER_BRANCH},
    "scenex": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": SIGNIFICANT_GRAVITAS_AUTHOR, "repository-name": "Auto-GPT-Plugins", "branch": MASTER_BRANCH},
    "bing_search": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": SIGNIFICANT_GRAVITAS_AUTHOR, "repository-name": "Auto-GPT-Plugins", "branch": MASTER_BRANCH},
    "news_search": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": SIGNIFICANT_GRAVITAS_AUTHOR, "repository-name": "Auto-GPT-Plugins", "branch": MASTER_BRANCH},
    "wikipedia_search": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": SIGNIFICANT_GRAVITAS_AUTHOR, "repository-name": "Auto-GPT-Plugins", "branch": MASTER_BRANCH},
    "api_tools": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": SIGNIFICANT_GRAVITAS_AUTHOR, "repository-name": "Auto-GPT-Plugins", "branch": MASTER_BRANCH},
    "random_values": {"name": STDLIB_OF_PLUGINS_FILENAME, "author": SIGNIFICANT_GRAVITAS_AUTHOR, "repository-name": "Auto-GPT-Plugins", "branch": MASTER_BRANCH},
    "AutoGPTGoogleAnalyticsPlugin": {"name": "AutoGPTGoogleAnalyticsPlugin", "author": "isaiahbjork", "repository-name": "Auto-GPT-Google-Analytics-Plugin", "branch": MASTER_BRANCH},
}

def get_plugin_url(plugin_data):
    return "https://github.com/{0}/{1}/archive/refs/heads/{2}.zip".format(plugin_data["author"], plugin_data["repository-name"], plugin_data["branch"])
