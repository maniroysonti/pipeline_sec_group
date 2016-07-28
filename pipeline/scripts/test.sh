#!/bin/bash

source /var/lib/jenkins/.rvm/scripts/rvm

cfndsl -y env/security_group_rules.yml cfn security_groups.rb > sec_groups.json