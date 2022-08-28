#!/bin/bash

cd "$(dirname $0)"/..

DIR=./python

if [[ ! -d ${DIR}/venv ]]; then
    python -m venv ${DIR}/venv
fi

_install() {
    mkdir -p ./tools

    source ${DIR}/venv/bin/activate
    if [[ ! -f ${DIR}/venv/bin/pip-sync ]]; then
        python -m pip install pip-tools
    fi
    ${DIR}/venv/bin/pip-sync python/requirements.txt

    tools=(
        pip-compile
        pip-sync
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
