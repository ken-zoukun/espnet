#!/bin/bash
set -euo pipefail


if [ $# -eq 0 ] || [ $# -gt 2 ]; then
    echo "Usage: $0 <python> <python_user_base>"
    echo "e.g."
    echo "$0 \$(which python3)"
    exit 1;
elif [ $# -eq 1 ]; then
    PYTHON="$1"
    PYTHONUSERBASE="$(pwd)/python_user_base"
else
    PYTHON="$1"
    PYTHONUSERBASE="$2"
    mkdir -p "${PYTHONUSERBASE}"
    PYTHONUSERBASE="$(cd ${PYTHONUSERBASE}; pwd)"
fi

if ! "${PYTHON}" -m venv --help 2>&1 > /dev/null; then
    echo "Error: ${PYTHON} is not Python3?"
    exit 1
fi
if [ -e activate_python.sh ]; then
    echo "Warning: activate_python.sh already exists. It will be overwritten"
fi

PYTHON_DIR="$(cd ${PYTHON%/*} && pwd)"
if [ ! -x "${PYTHON_DIR}"/python3 ]; then
    echo "${PYTHON_DIR}/python3 doesn't exist."
    exit 1
elif [ ! -x "${PYTHON_DIR}"/pip3 ]; then
    echo "${PYTHON_DIR}/pip3 doesn't exist."
    exit 1
fi

# Change the user site packages dir from "~/.local"
echo "Warning: Setting PYTHONUSERBASE"
cat << EOF > activate_python.sh
export PYTHONUSERBASE="${PYTHONUSERBASE}"
export PATH="${PYTHONUSERBASE}/bin":\${PATH}
export PATH=${PYTHON_DIR}:\${PATH}
EOF

. ./activate_python.sh
python3 -m pip install -U pip wheel
