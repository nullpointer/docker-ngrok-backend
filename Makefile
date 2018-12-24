DOMAIN := "tunnel.nullpointer.ltd"
NAME   := "airpointer/ngrok"
TAG    := $$(git log -1 --pretty=%h)
IMG    := ${NAME}:${TAG}
LATEST := ${NAME}:latest

HOST_HTTP_PORT  := 9525
HOST_HTTPS_PORT := 9526
CONTAINER_HTTP_PORT  := 9525
CONTAINER_HTTPS_PORT := 9526
TUNNEL_PORT     := 9527

build:
	@docker build -t ${IMG} .
	@docker tag ${IMG} ${LATEST}

run:
	@echo "${HOST_HTTP_PORT} -> ${CONTAINER_HTTP_PORT}"
	@echo "${HOST_HTTPS_PORT} -> ${CONTAINER_HTTPS_PORT}"
	@echo "${TUNNEL_PORT} -> ${TUNNEL_PORT}"
	@docker run --name ngrok \
		-p ${HOST_HTTP_PORT}:${CONTAINER_HTTP_PORT} \
		-p ${HOST_HTTPS_PORT}:${CONTAINER_HTTPS_PORT} \
		-p ${TUNNEL_PORT}:${TUNNEL_PORT} \
		${NAME} ${DOMAIN} ${CONTAINER_HTTP_PORT} ${CONTAINER_HTTPS_PORT} ${TUNNEL_PORT}

stop:
	@docker container stop ngrok
	@docker container rm `docker ps -aqf "name=ngrok"`
