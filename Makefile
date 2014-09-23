ci: build_docker_images run_tests publish_images

build_docker_images:
	fig -p adam build

run_tests:
	fig -p adam run --rm memory bin/test
	fig -p adam run --rm brain bin/test

publish_images:
	docker tag adam_memory quay.io/mojolingo/adam-snark-rabbit-basic-memory
	docker tag adam_brain quay.io/mojolingo/adam-snark-rabbit-basic-brain
	docker push quay.io/mojolingo/adam-snark-rabbit-basic-memory
	docker push quay.io/mojolingo/adam-snark-rabbit-basic-brain
