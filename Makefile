######
# build the base image
#
docker/base_build:
	docker-compose -f docker-compose-base.yml build

######
# build the APP image
#
docker/build:
	docker-compose -f docker-compose-dev.yml build

######
#
# REGISTRY="localhost:5000" make docker/push_local_registry
#
docker/push_local_registry:
	docker tag sso_test-sso_test_base_build $$REGISTRY/sso_test_base_build
	docker push $$REGISTRY/sso_test_base_build

######
# run the dockerised DEV environment
#
docker/up:
	docker-compose -f docker-compose-dev.yml up

######
# run the dockerised DEV environment & make the iex console available
#
docker/iex:
	docker-compose -f docker-compose-dev.yml run --rm -p 4000:4000  sso_test iex -S mix	

# run "mix test" within the docker environment - i.e. All the unit/tests for the whole app are run
# IF you want to test a single unit test file: run "mix test" for a single unit test file - passed as an argument like this:
# TEST="test/sample_test.exs" make docker/test
# the $$TEST will be ignored if empty and the whole test suite will be run
docker/test:
	docker-compose -f docker-compose-test.yml run --rm sso_test mix test $$TEST