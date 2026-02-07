#!/bin/bash

app_name=user

source ./common.sh



nodejs_setup

app_setup

systemd_setup

app_restart

print_total_time