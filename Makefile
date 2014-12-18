# Makefile

IMAGE=gmacario/watchmeip-hack

help:
	@echo Please read Makefile

build:
	docker build -t $(IMAGE) .


run:
	docker run -d --volume=$$PWD/snapshots:/tmp/motion $(IMAGE)

# EOF
