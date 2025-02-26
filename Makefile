#!/usr/bin/env make

.DEFAULT_GOAL := default

.PHONY: check clean dist doc help run test

COMMA	:= ,
EMPTY	:=
PYTHON	:= $(shell which python3)
CTAGS	:= $(shell which ctags)

SRCS	:= *.py employees/*.py tests/*.py utils/*.py
YAMLS	:= $(wildcard .*.yml *.yml .github/**/*.yml tests/*.yaml)

default:	check test version

all:	check test run doc dist

help:
	@echo
	@echo "Default goal: ${.DEFAULT_GOAL}"
	@echo "  all:   check cover run test doc dist"
	@echo "  check: check style and lint code"
	@echo "  run:   run against test data"
	@echo "  test:  run unit tests"
	@echo "  dist:  create a distribution archive"
	@echo "  doc:   create documentation including test coverage and results"
	@echo "  clean: delete all generated files"
	@echo
	@echo "Initialise virtual environment (venv) with:"
	@echo
	@echo "pip3 install -U virtualenv; python3 -m virtualenv venv; source venv/bin/activate; pip3 install -Ur requirements.txt"
	@echo
	@echo "Start virtual environment (venv) with:"
	@echo
	@echo "source venv/bin/activate"
	@echo
	@echo "Deactivate with:"
	@echo
	@echo "deactivate"
	@echo
	$(PYTHON) -m read_yaml -h

check:
ifdef CTAGS
	# ctags for vim
	ctags --recurse -o tags $(SRCS)
endif
	# sort imports
	isort $(SRCS)
	# format code to googles style
	black -q $(SRCS)
	# check using flake8
	flake8 $(SRCS)
	# check with pylint
	pylint $(SRCS)
	# check yaml
	yamllint --strict $(YAMLS)

test:
	pytest -v --cov-report term-missing --cov=employees tests/

doc:
	# create sphinx documentation
	pytest -v --html=cover/report.html --cov=employees --cov-report=html:cover tests/
	(cd docs; make html)

dist:
	cp -pr target/docs/html public

run:
	$(PYTHON) -m read_yaml -v tests

version:
	$(PYTHON) -m read_yaml --version

clean:
	# clean generated files
	(cd docs; make clean)
	$(RM) -rf build
	$(RM) -rf cover
	$(RM) -rf .coverage
	$(RM) -rf dist
	$(RM) -f  *.log *.log.*
	$(RM) -rf __pycache__ employees/__pycache__ tests/__pycache__
	$(RM) -rf public
	$(RM) -f  tags
	$(RM) -rf target
	$(RM) -v  MANIFEST
	$(RM) -v  *.pyc *.pyo *.py,cover
	$(RM) -v  **/*.pyc **/*.pyo **/*.py,cover
