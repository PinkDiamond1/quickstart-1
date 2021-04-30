__PHONY__: build build-testing

build:
	docker build -t digitalbits/quickstart -f Dockerfile .

build-testing:
	docker build -t digitalbits/quickstart:testing -f Dockerfile.testing .