project := MatchDinamicTable

pytest := PYTHONDONTWRITEBYTECODE=1 py.test --tb short -rxs \
	--cov-config .coveragerc --cov $(project) tests

test_args := --cov-report xml --cov-report term-missing

.DEFAULT_GOAL : help

help:
	@echo "clean - remove all build, test, coverage and Python artifacts"
	@echo "clean-pyc - remove Python file artifacts"
	@echo "clean-test - remove test and coverage artifacts"
	@echo "lint - check style with flake8"
	@echo "test - run tests quickly with the default Python"
	@echo "coverage - check code coverage quickly with the default Python"

clean: clean-build clean-pyc clean-test

clean-build:
	rm -fr build/
	rm -fr dist/
	rm -fr .eggs/
	find . -name '*.egg-info' -exec rm -fr {} +
	find . -name '*.egg' -exec rm -rf {} +

clean-pyc:
	find . -name '*.pyc' -exec rm -f {} +
	find . -name '*.pyo' -exec rm -f {} +
	find . -name '*~' -exec rm -f {} +
	find . -name '__pycache__' -exec rm -fr {} +

clean-test:
	rm -f .coverage
	rm -f coverage.xml
	rm -fr htmlcov/
	rm -fr .pytest_cache/

lint:
	flake8 --config=.flake8 $(project) tests

test:
	$(pytest) $(test_args)

coverage:
	coverage run --source $(project) setup.py test
	coverage report -m
	coverage html

docker-build:
	docker build --no-cache --tag match-dinamictable .

docker-run: docker-build
	docker run --env-file .env -p 8000:8000 match-dinamictable
