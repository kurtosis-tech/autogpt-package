AUTOGPT_IMAGE="h4ck3rk3y/autogpt"
REDIS_IMAGE="redis/redis-stack-server:latest"

OPENAI_API_KEY_ARG="OPENAI_API_KEY"
# all other env_vars apart from OPENAI_API_KEY_ARG go here
ENV_VARS_ARG="env"

redis_module = import_module("github.com/kurtosis-tech/redis-package/main.star")

def run(plan, args):

    if OPENAI_API_KEY_ARG not in args:
        fail("{0} is a required argument that needs to be passed to this script".format(OPENAI_API_KEY_ARG))

    redis_server = redis_module.run(plan, {'redis-image': REDIS_IMAGE})

    env_vars = {
        "OPENAI_API_KEY": args[OPENAI_API_KEY_ARG],
        "MEMORY_BACKEND": "redis",
        "REDIS_HOST": redis_server["hostname"],
        "REDIS_PORT": str(redis_server["client-port"]),
        "REDIS_PASSWORD": ""
    }

    if ENV_VARS_ARG in args:
        if type(args[ENV_VARS_ARG]) != 'dict':
            fail("{0} is supposed to be a dict but found {1}".format(ENV_VARS_ARG, type(args[ENV_VARS_ARG])))
        for env_var_key, env_var_value in args[ENV_VARS_ARG].items():
            env_vars[env_var_key] = env_var_value

    plan.add_service(
        name = "autogpt",
        config = ServiceConfig(
            image = AUTOGPT_IMAGE,
            entrypoint = ["sleep", "9999999"],
            env_vars = env_vars,
        )
    )
