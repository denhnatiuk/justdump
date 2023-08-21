## Docker receipes

DOCKER_FILE := "-f " + (
    if IS_PROD == "true" { "prod/docker-compose.yml" }
    else { "docker-compose.yml" }
)

