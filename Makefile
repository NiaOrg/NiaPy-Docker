DEV ?= $(shell test -z "${DEVEL}" && 0 || 1)

NIAORG_NIAPY_VERSION=2.0.5

build:
	docker build -f Dockerfile \
		--build-arg DEVEL=${DEV} \
		--build-arg PYTHON_VERSION_MAJOR=3 \
		--build-arg PYTHON_VERSION_MINOR_FIRST=11 \
		--build-arg PYTHON_VERSION_MINOR_SECOND=0 \
		-t NiaOrg/NiaPy:${NIAORG_NIAPY_VERSION} .
