#!/bin/bash

ssh -F /dev/null -o 'IdentitiesOnly=yes' -o 'IdentityFile=/dev/null' "${@}"
