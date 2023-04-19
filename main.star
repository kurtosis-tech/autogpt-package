AUTOGPT_IMAGE="h4ck3rk3y/autogpt"
REDIS_IMAGE="redis/redis-stack-server:latest"

redis_module = import_module("github.com/kurtosis-tech/redis-package/main.star")

def run(plan, args):

    if "openai-api-key" not in args:
        fail("open-api-key is a required argument that needs to be passed to this script")

    redis_server = redis_module.run(plan, {'redis-image': REDIS_IMAGE})

    plan.add_service(
        name = "autogpt",
        config = ServiceConfig(
            image = AUTOGPT_IMAGE,
            entrypoint = ["sleep", "9999999"],
            env_vars = {
                "OPENAI_API_KEY": args["openai-api-key"],
                "MEMORY_BACKEND": "redis",
                "REDIS_HOST": redis_server["hostname"],
                "REDIS_PORT": str(redis_server["client-port"]),
                "REDIS_PASSWORD": "",
                "RESTRICT_TO_WORKSPACE": "False"
            }
        )
    )
