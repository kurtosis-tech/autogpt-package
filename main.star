AUTOGPT_IMAGE="h4ck3rk3y/autogpt"
REDIS_IMAGE="redis/redis-stack-server:latest"

OPENAI_API_KEY_ARG="openai-api-key"

redis_module = import_module("github.com/kurtosis-tech/redis-package/main.star")

def run(plan, args):

    if OPENAI_API_KEY_ARG not in args:
        fail(f"{OPENAI_API_KEY_ARG} is a required argument that needs to be passed to this script")

    redis_server = redis_module.run(plan, {'redis-image': REDIS_IMAGE})

    plan.add_service(
        name = "autogpt",
        config = ServiceConfig(
            image = AUTOGPT_IMAGE,
            entrypoint = ["sleep", "9999999"],
            env_vars = {
                "OPENAI_API_KEY": args[OPENAI_API_KEY_ARG],
                "MEMORY_BACKEND": "redis",
                "REDIS_HOST": redis_server["hostname"],
                "REDIS_PORT": str(redis_server["client-port"]),
                "REDIS_PASSWORD": "",
                "RESTRICT_TO_WORKSPACE": "False"
            }
        )
    )
