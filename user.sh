#!/bin/bash

app_name=user

source ./common.sh

app_setup

nodejs_setup

systemd_setup

app_restart

print_total_time