all: usage

usage:
	@echo "Usage:                                              "
	@echo "                                                    "
	@echo "    make  command                                   "
	@echo "                                                    "
	@echo "The commands are:                                   "
	@echo "                                                    "
	@echo "    jupyter     run jupyterlab                      "
	@echo "    tensorboard run tensorboard --logdir=runs       "
	@echo "    tests       run unit test                       "
	@echo "    format      run yapf on python code files       "
	@echo "    docker      build the docker images             "
	@echo "    deps        install requirements                "
	@echo "    clean       remove object files                 "
	@echo "                                                    "

format:
	yapf -i -r src tests --style=yapf.style

deps:
	pip3 install -r requirements.txt

check test pytest:
	pytest --showlocals --durations=1 --pyargs

unittest:
	python -m unittest discover --pattern="*_test.py" -v

pylint:
	pylint --rcfile=pylint.conf src/*.py tests/*.py

jupyter:
	cd jupyterlab && ../tools/jupyterlab

tensorboard:
	cd jupyterlab && tensorboard --logdir=runs

docker build image:
	docker build -t yibit-pytorch .

compose:
	docker-compose up

rmi:
	docker rmi -f yibit-pytorch 

stop:
	docker-compose stop

start:
	docker-compose start 

.PHONY: clean
clean:
	find . -name \*~ -type f |xargs rm -f
	find . -name \*.bak -type f |xargs rm -f
