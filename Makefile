all: usage

usage:
	@echo "Usage:                                              "
	@echo "                                                    "
	@echo "    make  command                                   "
	@echo "                                                    "
	@echo "The commands are:                                   "
	@echo "                                                    "
	@echo "    run         start the runner                    "
	@echo "    note        run jupyter notebook                "
	@echo "    jupyter     run jupyterlab                      "
	@echo "    tests       run unit test                       "
	@echo "    format      run yapf on python code files       "
	@echo "    docker      build the docker images             "
	@echo "    deps        install requirements                "
	@echo "    clean       remove object files                 "
	@echo "                                                    "

format:
	yapf -i -r src tests --style=yapf.style

deps:
	sh tools/setup 
	pip install -r requirements.txt

check tests pytest:
	pytest --showlocals --durations=1 --pyargs

unittest:
	python -m unittest discover --pattern="*_test.py" -v

pylint:
	pylint --rcfile=pylint.conf src/*.py tests/*.py

note:
	cd notebook && ../tools/jupyter

jupyter:
	cd jupyterlab && ../tools/jupyterlab

docker build image:
	docker build -t yibit-pytorch .

run:
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
