ci: destroy_dev_env create_dev_env run_tests_in_dev_env prep_deployment_config

destroy_dev_env:
	vagrant destroy -f
	rm -rf cookbooks

create_dev_env:
	STANDALONE_DEPLOYMENT=true vagrant up

run_tests_in_dev_env:
	vagrant ssh -c "sudo -u adam -i sh -c 'cd /srv/adam/current && rake'"

# Create chef solo config for deployment environments
prep_deployment_config:
	rm -rf build && mkdir build
	berks install --path cookbooks
	tar zcvf build/cookbooks.tgz cookbooks
	tar zcvf build/roles.tgz roles

destroy_distributed_env:
	VAGRANT_ENVIRONMENT=distributed vagrant destroy -f

build_distributed_environment:
	VAGRANT_ENVIRONMENT=distributed vagrant up --parallel

run_unit_tests_in_distributed_env:
	VAGRANT_ENVIRONMENT=distributed vagrant ssh -c "sudo -u adam -i sh -c 'cd /srv/adam/current && rake'" app
