# Base16 Shell
BASE16_SCHEME="default"
BASE16_SHELL="$HOME/src/github/base16/base16-builder/output/shell/base16-$BASE16_SCHEME.dark.sh"
if [[ -s ${BASE16_SHELL} ]]; then
    . ${BASE16_SHELL}
else
    echo "Base16 shell script was not found"
fi

