#!/usr/bin/env bash

# TODO: proxy configs

# TODO: bashrc

# TODO: vscode

while read -r package; do
    python3 -m pip install --user "$package"
done < ../python-packages.txt

