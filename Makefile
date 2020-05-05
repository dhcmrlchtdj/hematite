.PHONY:
dev:
	hugo serve

build:
	rm -rf ./public
	hugo --minify
