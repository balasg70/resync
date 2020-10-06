#!/bin/bash

set -e

if [[ -n "${CI_DEBUG}" ]]; then
    set -x
fi

function usage() {
    echo -n \
    "Usage: $(basename "$0")
Ensure the Terraform source code is properly formatted.
"
}

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    if [ "${1:-}" = "--help" ]; then
        usage
    else
        terraform fmt -check
        terraform init -backend-config ./backend.tfvars
        terraform plan -out=out.plan
        terraform apply out.plan
    fi
fi
