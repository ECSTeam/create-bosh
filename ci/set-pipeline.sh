#!/bin/bash

set -ex

concourse_target=gold
pipeline=pipeline.yml
pipeline_name=create-bosh-iac-test

fly -t $concourse_target set-pipeline -c $pipeline -p $pipeline_name -n

fly -t $concourse_target unpause-pipeline -p $pipeline_name

