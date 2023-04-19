AUTOGPT_IMAGE="autogpt"

redis_module = import_module("github.com/kurtosis-tech/redis-package/main.star")

def run(plan, args):

    if "open-api-key" not in args:
        fail("open-api-key is a required argument that needs to be passed to this script")

    redis_server = redis_module.run(plan, args)

    plan.add_service(
        name = "autogpt",
        config = ServiceConfig(
            image = AUTOGPT_IMAGE,
            entrypoint = ["sleep", "9999999"],
            env_vars = {
                "OPENAI_API_KEY": args["open-api-key"]
                "MEMORY_BACKEND": "redis",
                "REDIS_HOST": redis_server["hostname"],
                "REDIS_PORT": 6379,
                "REDIS_PASSWORD": "",
            }
        )
    )