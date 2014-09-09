ci: build_docker_images publish_images

build_docker_images:
	docker build -t quay.io/mojolingo/adam-snark-rabbit-basic-memory .

run_tests:
	docker run -i quay.io/mojolingo/adam-snark-rabbit-basic-memory /bin/bash -c "cd /app && bin/test"

publish_images:
	docker push quay.io/mojolingo/adam-snark-rabbit-basic-memory
