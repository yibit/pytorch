#!/bin/sh

usage()
{
    echo "Usage:                        "
    echo "        $0 <project name>     "
    echo "                              "

    return 0
}

if test $# -ne 1; then
    usage
    exit 1
fi

NAME=$1

mkdir -p $NAME/
mkdir -p $NAME/.vscode
mkdir -p $NAME/data
mkdir -p $NAME/jupyterlab
mkdir -p $NAME/notebook
mkdir -p $NAME/src
mkdir -p $NAME/tests
mkdir -p $NAME/tools
mkdir -p $NAME/utils


cat > $NAME/.dockerignore <<EOF
.vscode/tags
.ipynb_checkpoints
.DS_Store
*~
EOF

cat > $NAME/.gitignore <<EOF
.vscode/tags
.ipynb_checkpoints
.DS_Store
*~
EOF

cat > $NAME/.vscode/settings.json <<EOF
{
    "files.associations": {
        "*.h": "cpp",
        "*.c": "c",
        "*.cc": "cpp",
        "*.py": "python",
        "tools/*": "shellscript",
        "*.mk": "makefile",
        "*.sh": "shellscript"
    },
    "files.encoding": "utf8"
}
EOF

cat > $NAME/AUTHORS <<EOF

# This is the official list of pipa authors for copyright purposes.
# This file is distinct from the CONTRIBUTORS files.
# See the latter for an explanation.

GuiQuan Zhang <guiqzhang at gmail.com>
yibit <yibitx at 126.com>
EOF

cat > $NAME/data/.gitignore <<EOF
*
!.gitignore
EOF

cat > $NAME/docker-compose.yml <<EOF
$NAME:
  image: yibit-$NAME
  ports:
    - 9876:9876
    - 19221:19221
  links:
  environment:
  volumes:
EOF

cat > $NAME/Dockerfile <<EOF

FROM centos:7

MAINTAINER $NAME "yibitx@126.com"

ENV $NAME 0.0.1

RUN set -ex \\
    && yum install -q -y python \\
    curl jq vim git-core lsof \\
    && easy_install pip

RUN mkdir -p /$NAME

COPY . /$NAME

WORKDIR /$NAME

RUN set -ex \\
    && sh tools/setup \\
    && pip install -r requirements.txt

CMD ["bash"]
EOF

cat > $NAME/jupyterlab/.gitignore <<EOF
.ipynb_checkpoints
*
!.gitignore
EOF

cat > $NAME/LICENSE <<EOF
// Copyright (c) 2017 - present The yibit Authors. All rights reserved.
//
// Permission to use, copy, modify, and distribute this software and
// its documentation for any purpose and without fee is hereby
// granted, provided that the above copyright notice appear in all
// copies and that both the copyright notice and this permission
// notice and warranty disclaimer appear in supporting
// documentation, and that the name of Lucent Technologies or any of
// its entities not be used in advertising or publicity pertaining
// to distribution of the software without specific, written prior
// permission.

// LUCENT TECHNOLOGIES DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
// SOFTWARE, INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND
// FITNESS.  IN NO EVENT SHALL LUCENT OR ANY OF ITS ENTITIES BE
// LIABLE FOR ANY SPECIAL, INDIRECT OR CONSEQUENTIAL DAMAGES OR ANY
// DAMAGES WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS,
// WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS
// ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
// PERFORMANCE OF THIS SOFTWARE.
EOF

cat > $NAME/Makefile <<EOF
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

pytest:
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
	docker build -t yibit-$NAME .

run:
	docker-compose up

rmi:
	docker rmi -f yibit-$NAME 

stop:
	docker-compose stop

start:
	docker-compose start 

.PHONY: clean
clean:
	find . -name \*~ -type f |xargs rm -f
	find . -name \*.bak -type f |xargs rm -f
EOF

cat > $NAME/notebook/.gitignore <<EOF
.ipynb_checkpoints
*
!.gitignore
EOF

cat > $NAME/pylint.conf <<EOF
[MASTER]

# A comma-separated list of package or module names from where C extensions may
# be loaded. Extensions are loading into the active Python interpreter and may
# run arbitrary code
extension-pkg-whitelist=

# Add files or directories to the blacklist. They should be base names, not
# paths.
ignore=CVS

# Add files or directories matching the regex patterns to the blacklist. The
# regex matches against base names, not paths.
ignore-patterns=

# Python code to execute, usually for sys.path manipulation such as
# pygtk.require().
#init-hook=

# Use multiple processes to speed up Pylint.
jobs=1

# List of plugins (as comma separated values of python modules names) to load,
# usually to register additional checkers.
load-plugins=

# Pickle collected data for later comparisons.
persistent=no

# Specify a configuration file.
#rcfile=

# Allow loading of arbitrary C extensions. Extensions are imported into the
# active Python interpreter and may run arbitrary code.
unsafe-load-any-extension=no


[MESSAGES CONTROL]

# Only show warnings with the listed confidence levels. Leave empty to show
# all. Valid levels: HIGH, INFERENCE, INFERENCE_FAILURE, UNDEFINED
confidence=

# Disable the message, report, category or checker with the given id(s). You
# can either give multiple identifiers separated by comma (,) or put this
# option multiple times (only on the command line, not in the configuration
# file where it should appear only once).You can also use "--disable=all" to
# disable everything first and then reenable specific checks. For example, if
# you want to run only the similarities checker, you can use "--disable=all
# --enable=similarities". If you want to run only the classes checker, but have
# no Warning level messages displayed, use"--disable=all --enable=classes
# --disable=W"
disable=print-statement,parameter-unpacking,unpacking-in-except,old-raise-syntax,backtick,long-suffix,old-ne-operator,old-octal-literal,import-star-module-level,raw-checker-failed,bad-inline-option,locally-disabled,locally-enabled,file-ignored,suppressed-message,useless-suppression,deprecated-pragma,apply-builtin,basestring-builtin,buffer-builtin,cmp-builtin,coerce-builtin,execfile-builtin,file-builtin,long-builtin,raw_input-builtin,reduce-builtin,standarderror-builtin,unicode-builtin,xrange-builtin,coerce-method,delslice-method,getslice-method,setslice-method,no-absolute-import,old-division,dict-iter-method,dict-view-method,next-method-called,metaclass-assignment,indexing-exception,raising-string,reload-builtin,oct-method,hex-method,nonzero-method,cmp-method,input-builtin,round-builtin,intern-builtin,unichr-builtin,map-builtin-not-iterating,zip-builtin-not-iterating,range-builtin-not-iterating,filter-builtin-not-iterating,using-cmp-argument,eq-without-hash,div-method,idiv-method,rdiv-method,exception-message-attribute,invalid-str-codec,sys-max-int,bad-python3-import,deprecated-string-function,deprecated-str-translate-call

# Enable the message, report, category or checker with the given id(s). You can
# either give multiple identifier separated by comma (,) or put this option
# multiple time (only on the command line, not in the configuration file where
# it should appear only once). See also the "--disable" option for examples.
enable=


[REPORTS]

# Python expression which should return a note less than 10 (10 is the highest
# note). You have access to the variables errors warning, statement which
# respectively contain the number of errors / warnings messages and the total
# number of statements analyzed. This is used by the global evaluation report
# (RP0004).
evaluation=10.0 - ((float(5 * error + warning + refactor + convention) / statement) * 10)

# Template used to display messages. This is a python new-style format string
# used to format the message information. See doc for all details
#msg-template=

# Set the output format. Available formats are text, parseable, colorized, json
# and msvs (visual studio).You can also give a reporter class, eg
# mypackage.mymodule.MyReporterClass.
output-format=text

# Tells whether to display a full report or only the messages
reports=no

# Activate the evaluation score.
score=yes


[REFACTORING]

# Maximum number of nested blocks for function / method body
max-nested-blocks=5


[BASIC]

# Naming hint for argument names
argument-name-hint=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$

# Regular expression matching correct argument names
argument-rgx=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$

# Naming hint for attribute names
attr-name-hint=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$

# Regular expression matching correct attribute names
attr-rgx=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$

# Bad variable names which should always be refused, separated by a comma
bad-names=foo,bar,baz,toto,tutu,tata

# Naming hint for class attribute names
class-attribute-name-hint=([A-Za-z_][A-Za-z0-9_]{2,30}|(__.*__))$

# Regular expression matching correct class attribute names
class-attribute-rgx=([A-Za-z_][A-Za-z0-9_]{2,30}|(__.*__))$

# Naming hint for class names
class-name-hint=[A-Z_][a-zA-Z0-9]+$

# Regular expression matching correct class names
class-rgx=[A-Z_][a-zA-Z0-9]+$

# Naming hint for constant names
const-name-hint=(([A-Z_][A-Z0-9_]*)|(__.*__))$

# Regular expression matching correct constant names
const-rgx=(([A-Z_][A-Z0-9_]*)|(__.*__))$

# Minimum line length for functions/classes that require docstrings, shorter
# ones are exempt.
docstring-min-length=-1

# Naming hint for function names
function-name-hint=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$

# Regular expression matching correct function names
function-rgx=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$

# Good variable names which should always be accepted, separated by a comma
good-names=i,j,k,ex,Run,_

# Include a hint for the correct naming format with invalid-name
include-naming-hint=no

# Naming hint for inline iteration names
inlinevar-name-hint=[A-Za-z_][A-Za-z0-9_]*$

# Regular expression matching correct inline iteration names
inlinevar-rgx=[A-Za-z_][A-Za-z0-9_]*$

# Naming hint for method names
method-name-hint=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$

# Regular expression matching correct method names
method-rgx=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$

# Naming hint for module names
module-name-hint=(([a-z_][a-z0-9_]*)|([A-Z][a-zA-Z0-9]+))$

# Regular expression matching correct module names
module-rgx=(([a-z_][a-z0-9_]*)|([A-Z][a-zA-Z0-9]+))$

# Colon-delimited sets of names that determine each other's naming style when
# the name regexes allow several styles.
name-group=

# Regular expression which should only match function or class names that do
# not require a docstring.
no-docstring-rgx=^_

# List of decorators that produce properties, such as abc.abstractproperty. Add
# to this list to register other decorators that produce valid properties.
property-classes=abc.abstractproperty

# Naming hint for variable names
variable-name-hint=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$

# Regular expression matching correct variable names
variable-rgx=(([a-z][a-z0-9_]{2,30})|(_[a-z0-9_]*))$


[FORMAT]

# Expected format of line ending, e.g. empty (any line ending), LF or CRLF.
expected-line-ending-format=

# Regexp for a line that is allowed to be longer than the limit.
ignore-long-lines=^\s*(# )?<?https?://\S+>?$

# Number of spaces of indent required inside a hanging  or continued line.
indent-after-paren=4

# String used as indentation unit. This is usually "    " (4 spaces) or "\t" (1
# tab).
indent-string='    '

# Maximum number of characters on a single line.
max-line-length=100

# Maximum number of lines in a module
max-module-lines=1000

# List of optional constructs for which whitespace checking is disabled. `dict-
# separator` is used to allow tabulation in dicts, etc.: {1  : 1,\n222: 2}.
# `trailing-comma` allows a space between comma and closing bracket: (a, ).
# `empty-line` allows space-only lines.
no-space-check=trailing-comma,dict-separator

# Allow the body of a class to be on the same line as the declaration if body
# contains single statement.
single-line-class-stmt=no

# Allow the body of an if to be on the same line as the test if there is no
# else.
single-line-if-stmt=no


[LOGGING]

# Logging modules to check that the string format arguments are in logging
# function parameter format
logging-modules=logging


[MISCELLANEOUS]

# List of note tags to take in consideration, separated by a comma.
notes=FIXME,XXX,TODO


[SIMILARITIES]

# Ignore comments when computing similarities.
ignore-comments=yes

# Ignore docstrings when computing similarities.
ignore-docstrings=yes

# Ignore imports when computing similarities.
ignore-imports=no

# Minimum lines number of a similarity.
min-similarity-lines=4


[SPELLING]

# Spelling dictionary name. Available dictionaries: none. To make it working
# install python-enchant package.
spelling-dict=

# List of comma separated words that should not be checked.
spelling-ignore-words=

# A path to a file that contains private dictionary; one word per line.
spelling-private-dict-file=

# Tells whether to store unknown words to indicated private dictionary in
# --spelling-private-dict-file option instead of raising a message.
spelling-store-unknown-words=no


[TYPECHECK]

# List of decorators that produce context managers, such as
# contextlib.contextmanager. Add to this list to register other decorators that
# produce valid context managers.
contextmanager-decorators=contextlib.contextmanager

# List of members which are set dynamically and missed by pylint inference
# system, and so shouldn't trigger E1101 when accessed. Python regular
# expressions are accepted.
generated-members=

# Tells whether missing members accessed in mixin class should be ignored. A
# mixin class is detected if its name ends with "mixin" (case insensitive).
ignore-mixin-members=yes

# This flag controls whether pylint should warn about no-member and similar
# checks whenever an opaque object is returned when inferring. The inference
# can return multiple potential results while evaluating a Python object, but
# some branches might not be evaluated, which results in partial inference. In
# that case, it might be useful to still emit no-member and other checks for
# the rest of the inferred objects.
ignore-on-opaque-inference=yes

# List of class names for which member attributes should not be checked (useful
# for classes with dynamically set attributes). This supports the use of
# qualified names.
ignored-classes=optparse.Values,thread._local,_thread._local

# List of module names for which member attributes should not be checked
# (useful for modules/projects where namespaces are manipulated during runtime
# and thus existing member attributes cannot be deduced by static analysis. It
# supports qualified module names, as well as Unix pattern matching.
ignored-modules=

# Show a hint with possible names when a member name was not found. The aspect
# of finding the hint is based on edit distance.
missing-member-hint=yes

# The minimum edit distance a name should have in order to be considered a
# similar match for a missing member name.
missing-member-hint-distance=1

# The total number of similar names that should be taken in consideration when
# showing a hint for a missing member.
missing-member-max-choices=1


[VARIABLES]

# List of additional names supposed to be defined in builtins. Remember that
# you should avoid to define new builtins when possible.
additional-builtins=

# Tells whether unused global variables should be treated as a violation.
allow-global-unused-variables=yes

# List of strings which can identify a callback function by name. A callback
# name must start or end with one of those strings.
callbacks=cb_,_cb

# A regular expression matching the name of dummy variables (i.e. expectedly
# not used).
dummy-variables-rgx=_+$|(_[a-zA-Z0-9_]*[a-zA-Z0-9]+?$)|dummy|^ignored_|^unused_

# Argument names that match this expression will be ignored. Default to name
# with leading underscore
ignored-argument-names=_.*|^ignored_|^unused_

# Tells whether we should check for unused import in __init__ files.
init-import=no

# List of qualified module names which can have objects that can redefine
# builtins.
redefining-builtins-modules=six.moves,future.builtins


[CLASSES]

# List of method names used to declare (i.e. assign) instance attributes.
defining-attr-methods=__init__,__new__,setUp

# List of member names, which should be excluded from the protected access
# warning.
exclude-protected=_asdict,_fields,_replace,_source,_make

# List of valid names for the first argument in a class method.
valid-classmethod-first-arg=cls

# List of valid names for the first argument in a metaclass class method.
valid-metaclass-classmethod-first-arg=mcs


[DESIGN]

# Maximum number of arguments for function / method
max-args=5

# Maximum number of attributes for a class (see R0902).
max-attributes=7

# Maximum number of boolean expressions in a if statement
max-bool-expr=5

# Maximum number of branch for function / method body
max-branches=12

# Maximum number of locals for function / method body
max-locals=15

# Maximum number of parents for a class (see R0901).
max-parents=7

# Maximum number of public methods for a class (see R0904).
max-public-methods=20

# Maximum number of return / yield for function / method body
max-returns=6

# Maximum number of statements in function / method body
max-statements=50

# Minimum number of public methods for a class (see R0903).
min-public-methods=2


[IMPORTS]

# Allow wildcard imports from modules that define __all__.
allow-wildcard-with-all=no

# Analyse import fallback blocks. This can be used to support both Python 2 and
# 3 compatible code, which means that the block might have code that exists
# only in one or another interpreter, leading to false positives when analysed.
analyse-fallback-blocks=no

# Deprecated modules which should not be used, separated by a comma
deprecated-modules=regsub,TERMIOS,Bastion,rexec

# Create a graph of external dependencies in the given file (report RP0402 must
# not be disabled)
ext-import-graph=

# Create a graph of every (i.e. internal and external) dependencies in the
# given file (report RP0402 must not be disabled)
import-graph=

# Create a graph of internal dependencies in the given file (report RP0402 must
# not be disabled)
int-import-graph=

# Force import order to recognize a module as part of the standard
# compatibility libraries.
known-standard-library=

# Force import order to recognize a module as part of a third party library.
known-third-party=enchant


[EXCEPTIONS]

# Exceptions that will emit a warning when being caught. Defaults to
# "Exception"
overgeneral-exceptions=Exception
EOF

cat > $NAME/README.md <<EOF
$NAME
=============

A deep learnning project of $NAME.


Copyright and License
====================

This Software is licensed under the BSD license.
EOF

cat > $NAME/requirements.txt <<EOF
yapf
pylint
pytest
pytest-cov
pandas
xlrd
EOF

cat > $NAME/src/basics.py <<EOF
#!/bin/python

import torch

a = torch.Tensor([[2,3],[5,6],[7,8]])
print('a is: {}'.format(a))
print('a.size() is: {}'.format(a.size()))

b = torch.LongTensor([[2,3],[5,6],[7,9]])
print('b is: {}'.format(b))
print('b.size() is: {}'.format(b.size()))

c = torch.zeros((3,2))
print('c is: {}'.format(c))
print('c.size() is: {}'.format(c.size()))

d = torch.randn((3,2))
print('d is: {}'.format(d))
print('d.size() is: {}'.format(d.size()))
EOF

cat > $NAME/src/format.py <<EOF
x = {'a': 37, 'b': 42, 'c': 927}

y = 'hello ' 'world'
z = 'hello ' + 'world'
a = 'hello {}'.format('world')


class foo(object):
    def f(self):
        return 37 * -+2

    def g(self, x, y=42):
        return y

def f(a):
    return 37 + -+a[42 - x:y**3]
EOF

cat > $NAME/tests/format_test.py <<EOF
x = {'a': 37, 'b': 42, 'c': 927}

y = 'hello ' 'world'
z = 'hello ' + 'world'
a = 'hello {}'.format('world')


class foo(object):
    def f(self):
        return 37 * -+2

    def g(self, x, y=42):
        return y


def f(a):
    return 37 + -+a[42 - x:y**3]
EOF

cat > $NAME/tools/altair_setup <<EOF
#!/bin/sh

sudo pip install altair

sudo jupyter nbextension install --sys-prefix --py vega

jupyter nbextension enable vega --py --sys-prefix
EOF

cat > $NAME/tools/board <<EOF
#!/bin/sh

tensorboard --logdir='./tensorflow_viz' &
EOF

cat > $NAME/tools/conda <<EOF
#!/bin/sh

miniconda
source activate $NAME
EOF

cat > $NAME/tools/conda_setup <<EOF
#!/bin/sh

miniconda
conda list

conda create -n $NAME python=3.6.3
source activate $NAME
conda install $NAME torchvision -c $NAME
EOF

cat > $NAME/tools/env <<EOF
#!/bin/sh

source ~/$NAME/$NAME-env/bin/activate
EOF

cat > $NAME/tools/jupyter <<EOF
#!/bin/sh

# jupyter-notebook

jupyter notebook
EOF

cat > $NAME/tools/jupyterlab <<EOF
#!/bin/sh

#jupyter-lab

jupyter lab
EOF

cat > $NAME/tools/setenv <<EOF
#!/bin/sh

# $NAME

echo 'alias $NAME="source ~/$NAME/$NAME-env/bin/activate"' >> ~/.zshrc

source ~/.zshrc
EOF

cat > $NAME/tools/setup <<EOF
#!/bin/sh

set -ex

sudo easy_install pip
sudo pip install --upgrade virtualenv
sudo pip install jupyter

mkdir ~/$NAME
virtualenv --system-site-packages  ~/$NAME/$NAME-env

source ~/$NAME/$NAME-env/bin/activate

pip install http://download.$NAME.org/whl/torch-0.2.0.post3-cp27-none-macosx_10_7_x86_64.whl
pip install torchvision

sudo pip install jupyterlab

# maybe not works
jupyter serverextension enable --py jupyterlab --sys-prefix
EOF

cat > $NAME/tools/start <<EOF
#!/bin/sh

name=\`cat ~/.zshrc |grep "alias $NAME=\"source" |awk -F 'source' '{ print \$2; }' |awk -F'\"' '{ print \$1; }'\`

if test "x$NAME" != "x"; then
    echo "source $NAME"
fi

# deactivate
EOF

cat > $NAME/tools/update <<EOF
#!/bin/sh

sudo pip install --upgrade $NAME
EOF

cat > $NAME/utils/sitecustomize.py <<EOF
# encoding=utf8

# lib/python2.7/site-packages/sitecustomize.py

import sys

reload(sys)
sys.setdefaultencoding('utf8')
EOF

cat > $NAME/yapf.style <<EOF
[style]
based_on_style = pep8
spaces_before_comment = 4 
split_before_logical_operator = true
EOF


UNAME=Darwin

if test "x" == "xDarwin"; then
    find $NAME -type f |xargs grep -l manta |xargs -I {} sed -i '' "s/manta/$NAME/g" {}
else
    find $NAME -type f |xargs grep -l manta |xargs -I {} sed -i "s/manta/$NAME/g" {}
fi

git init
