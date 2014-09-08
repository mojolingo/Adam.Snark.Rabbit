ci: build_docker_images run_tests

build_docker_images:
	docker build -t mojolingo/adam-snark-rabbit-basic-brain brain

run_tests:
	docker run -i mojolingo/adam-snark-rabbit-basic-brain /bin/bash -c "cd /app && bin/test"
