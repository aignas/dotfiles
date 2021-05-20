#!/bin/bash

cd "$(dirname $0)"/..

DIR=python

if [[ ! -d ${DIR}/venv ]]; then
	python3 -m venv ${DIR}/venv
fi

${DIR}/venv/bin/pip install --upgrade pip setuptools
${DIR}/venv/bin/pip install -r python/requirements.txt

for i in \
    pyls \
    pylint \
    pyflakes \
    pydocstyle \
    pycodestyle \
    yapf \
    pyreverse \
    isort-identify-imports \
    isort \
    flake8 \
    epylint \
    autopep8
do
    cat <<EOF >"tools/$i"
#!/bin/bash

cd "\$(dirname "\$0")"/..
exec ${DIR}/venv/bin/$i "\$@"
EOF
    chmod +x "tools/$i"
done