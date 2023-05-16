common = import_module("github.com/kurtosis-tech/autogpt-package/src/common.star")

MAIN_BRANCH = "main"
MASTER_BRANCH = "master"
STDLIB_PLUGIN_REPO = "Significant-Gravitas/Auto-GPT-Plugins"
ZIP_EXTENSION = ".zip"
REQUIRED_ENV_VARS_KEY = "required_env_vars"

plugins_map = {
    # begin standard plugins
    "AutoGPTTwitter": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["TW_CONSUMER_KEY", "TW_CONSUMER_SECRET", "TW_ACCESS_TOKEN", "TW_ACCESS_TOKEN_SECRET", "TW_CLIENT_ID", "TW_CLIENT_ID_SECRET"]},
    "AutoGPTEmailPlugin": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["EMAIL_ADDRESS", "EMAIL_PASSWORD"]},
    "AutoGPTSceneXPlugin": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["SCENEX_API_KEY"]},
    "AutoGPTBingSearch": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["SEARCH_ENGINE", "BING_API_KEY"]}, # TODO SEARCH_ENGINE env could be auto set instead of a requirement
    "AutoGPTNewsSearch": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["NEWSAPI_API_KEY"]},
    "AutoGPTWikipediaSearch": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: []},
    "AutoGPTApiTools": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: []},
    "AutoGPTRandomValues": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: []},
    "AutoGPTSpacePlugin": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: []},
    "AutoGPTBaiduSearch": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["SEARCH_ENGINE", "BAIDU_COOKIE"]}, # TODO SEARCH_ENGINE env could be auto set instead of a requirement
    "AutoGPTBluesky": {"repository": STDLIB_PLUGIN_REPO, "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["BLUESKY_USERNAME", "BLUESKY_APP_PASSWORD"]},
    # end of standard plugins
    "AutoGPTAlpacaTraderPlugin": {"repository": "danikhan632/Auto-GPT-AlpacaTrader-Plugin", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY:["APCA_API_KEY_ID", "APCA_API_SECRET_KEY", "APCA_IS_PAPER"]}, # TODO APCA_IS_PAPER=True can be auto set
    "AutoGPTUserInput": {"repository": "HFrovinJensen/Auto-GPT-User-Input-Plugin", "branch": MASTER_BRANCH},
    "BingAI": {"repository": "gravelBridge/AutoGPT-BingAI", "branch": MAIN_BRANCH, REQUIRED_ENV_VARS_KEY: ["BINGAI_COOKIES_PATH", "BINGAI_MODE"]},
    "AutoGPTCryptoPlugin": {"repository": "isaiahbjork/Auto-GPT-Crypto-Plugin", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["ETHERSCAN_API_KEY", "POLYSCAN_API_KEY", "ETH_WALLET_ADDRESS", "ETH_WALLET_PRIVATE_KEY", "LUNAR_CRUSH_API_KEY", "TELEGRAM_API_ID", "TELEGRAM_API_HASH", "FCS_API_KEY", "CMC_API_KEY", "EXCHANGES", "EXCHANGE_NAME_SECRET", "EXCHANGE_NAME_API_KEY"]},
    "AutoGPTDiscord": {"repository": "gravelBridge/AutoGPT-Discord", "branch": MAIN_BRANCH, REQUIRED_ENV_VARS_KEY: ["DISCORD_BOT_TOKEN", "AUTHORIZED_USER_IDS", "BOT_PREFIX", "CHANNEL_ID", "ASK_FOR_INPUT"]}, # TODO ASK_FOR_INPUT=True can be auto set
    "AutoGPTDollyPlugin": {"repository": "pr-0f3t/Auto-GPT-Dolly-Plugin", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: []},
    "AutoGPTGoogleAnalyticsPlugin": {"repository": "isaiahbjork/Auto-GPT-Google-Analytics-Plugin", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["GOOGLE_APPLICATION_CREDENTIALS", "GOOGLE_ANALYTICS_VIEW_ID"]}, # TODO GOOGLE_APPLICATION_CREDENTIALS=firebase.json can be auto set
    "AutoGPT_IFTTT": {"repository": "AntonioCiolino/AutoGPT-IFTTT", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["IFTTT_WEBHOOK_TRIGGER_NAME", "IFTTT_KEY"]},
    "AutoGPT_YouTube": {"repository": "jpetzke/AutoGPT-YouTube", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["YOUTUBE_API_KEY"]},
    "AutoGPTPMPlugin": {"repository": "minfenglu/AutoGPT-PM-Plugin", "branch": MAIN_BRANCH, REQUIRED_ENV_VARS_KEY: ["TRELLO_API_KEY", "TRELLO_API_TOKEN", "TRELLO_CONFIG_FILE"]},
    "AutoGPTWolframAlpha": {"repository":"gravelBridge/AutoGPT-WolframAlpha", "branch": MAIN_BRANCH, REQUIRED_ENV_VARS_KEY: ["WOLFRAM_ALPHA_APP_ID"]},
    "AutoGPTTodoistPlugin": {"repository": "danikhan632/Auto-GPT-Todoist-Plugin", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["TODOIST_TOKEN"]},
    "AutoGPTMessagesPlugin": {"repository": "danikhan632/Auto-GPT-Messages-Plugin", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["IMESSAGE_PASSWORD_KEY", "IMESSAGE_BASE_URL"]},
    "AutoGPTWebInteraction": {"repository": "gravelBridge/AutoGPT-Web-Interaction", "branch": MAIN_BRANCH, REQUIRED_ENV_VARS_KEY: []},
    "AutoGPTNotion": {"repository": "doutv/Auto-GPT-Notion", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: ["NOTION_TOKEN", "NOTION_DATABASE_ID"]},
    "SystemInformationPlugin": {"repository": "hdkiller/Auto-GPT-SystemInfo", "branch": MASTER_BRANCH, REQUIRED_ENV_VARS_KEY: []},
    "AutoGPT_Zapier": {"repository": "AntonioCiolino/AutoGPT-Zapier", "branch": MAIN_BRANCH, REQUIRED_ENV_VARS_KEY: ["ZAPIER_WEBHOOK_ENDPOINT"]},
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

def areAllRequiredEnvVarsSet(env_vars, plugins_names):
    areAllRequiredEnvVarsSet = True
    missing_env_vars = []
    all_required_env_vars = getAllRequiredEnvVarsFor(plugins_names)
    for required_env_var in all_required_env_vars:
        if required_env_var not in env_vars:
            areAllRequiredEnvVarsSet = False
            missing_env_vars.append(required_env_var)

    return areAllRequiredEnvVarsSet, missing_env_vars
    

def getAllRequiredEnvVarsFor(plugins_names):
    required_env_vars = []
    for plugin_name in plugins_names:
        plugin_data = plugins_map.get(plugin_name)
        if plugin_data == None:
            fail("Invalid plugin name {0}. The supported plugins are: {1}. You can add support for a new plugin by creating an issue or PR at {2}".format(plugin_name, ", ".join(plugins_map.keys()), common.KURTOSIS_AUTOGPT_PACKAGE_URL))
        plugin_env_vars = plugin_data.get(REQUIRED_ENV_VARS_KEY)
        if plugin_env_vars == None:
            continue
        required_env_vars.extend(plugin_env_vars)
    
    return required_env_vars
