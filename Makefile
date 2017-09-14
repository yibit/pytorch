
format:
	yapf -i -r src tests --style=yapf.style

deps:
	sh tools/setup 
	pip install -r requirements.txt

pytest:
	pytest --showlocals --durations=1 --pyargs

unittest:
	python -m unittest discover --pattern="*_test.py" -v

pylint:
	pylint --rcfile=pylint.conf src/*.py tests/*.py
