AUTOGPT_IMAGE="autogpt"

def run(plan, args):

    if "open-api-key" not in args:
        fail("open-api-key is a required argument that needs to be passed to this script")

    env_template = read_file("github.com/kurtosis-tech/autogpt-package/.env.template")

    rendered_env_file = plan.render_templates(
        config = {
            ".env": struct(
                template = env_template,
                data = {
                    "OpenAPIKey": args["open-api-key"]
                }
            )
        }
    )

    plan.add_service(
        name = "autogpt",
        config = ServiceConfig(
            image = AUTOGPT_IMAGE,
            entrypoint = ["sleep", "9999999"],
            files = {
                "/app": rendered_env_file,
            }
        )
    )