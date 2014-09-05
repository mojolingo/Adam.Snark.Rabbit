ci: run_tests prep_deployment_config

run_tests:
	STANDALONE_DEPLOYMENT=true kitchen test

# Create chef solo config for deployment environments
prep_deployment_config:
	rm -rf build && mkdir build
	berks vendor build/cookbooks
	tar zcvf build/cookbooks.tgz build/cookbooks
	tar zcvf build/roles.tgz roles
