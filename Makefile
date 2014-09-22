ci: build_docker_images run_tests publish_images

build_docker_images:
	docker build -t quay.io/mojolingo/adam-snark-rabbit-basic-memory memory
	docker build -t quay.io/mojolingo/adam-snark-rabbit-basic-brain brain

run_tests:
	docker run -i quay.io/mojolingo/adam-snark-rabbit-basic-brain /bin/bash -c "cd /app && bin/test"

publish_images:
	docker push quay.io/mojolingo/adam-snark-rabbit-basic-memory
	docker push quay.io/mojolingo/adam-snark-rabbit-basic-brain
