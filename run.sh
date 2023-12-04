#!/bin/sh

IMAGE="shanemcc:php-8.3-cli-opcache-bug-01"

docker image inspect $IMAGE >/dev/null 2>&1
if [ $? -ne 0 ]; then
	echo "One time setup: building docker image ${IMAGE}..."
	docker build --pull . -t $IMAGE
	echo "Image build complete."
fi

echo -n 'run.php No Jit: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php /app/run.php

echo -n 'run.php Jit: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php -d opcache.enable_cli=1 -d opcache.jit_buffer_size=0M /app/run.php >/dev/null
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php -d opcache.enable_cli=1 -d opcache.jit_buffer_size=100M /app/run.php

echo -n 'run2.php No Jit: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php /app/run2.php

echo -n 'run2.php Jit: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php -d opcache.enable_cli=1 -d opcache.jit_buffer_size=0M /app/run2.php >/dev/null
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php -d opcache.enable_cli=1 -d opcache.jit_buffer_size=100M /app/run2.php

echo ''
echo -n 'php version: '
docker run --rm -it -v ${PWD}:/app -w /app ${IMAGE} php --version
