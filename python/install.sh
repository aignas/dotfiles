#!/bin/bash

cd "$(dirname $0)"/..

DIR=python

if [[ ! -d ${DIR}/venv ]]; then
	python3 -m venv ${DIR}/venv
fi

_install() {
    mkdir -p ./tools

    ${DIR}/venv/bin/pip install --upgrade pip setuptools
    ${DIR}/venv/bin/pip install -r python/requirements.txt

    tools=(
        black
        epylint
        flake8
        isort
        isort-identify-imports
        okta-awscli
        pycodestyle
        pydocstyle
        pyflakes
        pylint
        pyls
        pyreverse
    )

    for i in "${tools[@]}"; do
        cat <<EOF >"tools/$i"
    #!/bin/bash

    cd "\$(dirname "\$0")"/..
    exec ${DIR}/venv/bin/$i "\$@"
EOF
        chmod +x "tools/$i"
    done
}

_install
