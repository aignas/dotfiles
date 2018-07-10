# A function for setting up python dev/test environment for new projects:
function pyvenv_setup() {
    local bootstrap=py-bootstrap.sh
    cat > $bootstrap << EOF
#!/bin/bash

# Setup a virtualenv for Python 3.0
pyvenv venv
venv/bin/pip install --upgrade \
    pip \
    setuptools \
    pylint \
    tox \
    pytest
EOF

    chmod 755 $bootstrap
    ./$bootstrap

    # Generate pylint RC file
    venv/bin/pylint --generate-rcfile >> .pylintrc

    # Create a tests directory
    mkdir -p tests

    # Make tests directory a module
    touch tests/__init__.py
}
