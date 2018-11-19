LISTEN_PORT = 6170

OS_TEST := $(shell docker system info | grep '^Operating System:' | grep -o 'Mac')

ifneq ($(OS_TEST),Mac)
LISTEN_INTERFACE = 172.17.0.1:
CACHE_LOCATION := /var/cache/docker-git-cache
else
# Docker for macOS is different.
LISTEN_INTERFACE := 127.0.0.1:
CACHE_LOCATION := /Users/Shared/cache/docker-git-cache
endif

ifdef PUBLIC
LISTEN_INTERFACE := 0.0.0.0:
endif

all: git_cache

git_cache:
	docker build -t git_cache .

clean: kill
	-docker rm git_cache
	-docker rmi git_cache

run:
	docker run -d --name git_cache \
		-v $(CACHE_LOCATION):/var/cache/git \
		--restart unless-stopped \
		-p $(LISTEN_INTERFACE)$(LISTEN_PORT):8080/tcp git_cache

kill:
	-docker kill git_cache
	-docker rm git_cache
