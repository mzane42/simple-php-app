#!/bin/bash

set -o errexit -o nounset

cd terraform

terraform init

terraform plan

terraform apply

