#!/bin/bash

cd "$(dirname $0)"/..

DIR=./python

if [[ ! -d ${DIR}/venv ]]; then
    python -m venv ${DIR}/venv
fi

_install() {
    mkdir -p ./tools

    source ${DIR}/venv/bin/activate
    python -m pip install --upgrade pip-tools pip
    ${DIR}/venv/bin/pip install -r python/requirements.txt

    tools=(
        black
        isort
        pyls
        pre-commit
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
