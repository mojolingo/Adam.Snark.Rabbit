ci: build_docker_images run_tests

build_docker_images:
	docker build -t mojolingo/adam-snark-rabbit-basic-brain brain

run_tests:
	docker run -i mojolingo/adam-snark-rabbit-basic-brain /bin/bash -c "cd /app && bin/test"

# Create chef solo config for deployment environments
prep_deployment_config:
	rm -rf build && mkdir build
	berks vendor build/cookbooks
	tar zcvf build/cookbooks.tgz build/cookbooks
	tar zcvf build/roles.tgz roles
