#!/bin/sh

VERSION="${1}"
if [ "${VERSION}" = "" ]; then
	VERSION="8.3"
fi;
IMAGE="shanemcc:php-${VERSION}-cli-opcache-bug-01"

docker image inspect $IMAGE >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "One time setup: building docker image ${IMAGE}..."
	docker build --pull . -t $IMAGE --build-arg "VERSION=${VERSION}"
	if [ $? -ne 0 ]; then
		echo "Image build failed."
		exit 1;
	fi;
	echo "Image build complete."
fi

echo "Running with PHP version: ${VERSION}"

echo -n 'run.php No Jit: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php /app/run.php

echo -n 'run.php Jit: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php -d opcache.enable_cli=1 -d opcache.jit=tracing -d opcache.jit_buffer_size=0M /app/run.php >/dev/null
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php -d opcache.enable_cli=1 -d opcache.jit=tracing -d opcache.jit_buffer_size=100M /app/run.php

echo -n 'run2.php No Jit: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php /app/run2.php

echo -n 'run2.php Jit: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php -d opcache.enable_cli=1 -d opcache.jit=tracing -d opcache.jit_buffer_size=0M /app/run2.php >/dev/null
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php -d opcache.enable_cli=1 -d opcache.jit=tracing -d opcache.jit_buffer_size=100M /app/run2.php

echo ''
echo -n 'php version: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php --version
