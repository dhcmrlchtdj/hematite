.PHONY:
dev:
	hugo -DEF serve

build:
	rm -rf ./public
	hugo --minify
