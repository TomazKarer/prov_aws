#!/bin/bash

~/development/apps/bw/bw login
export AWS_ACCESS_KEY_ID=$(~/development/apps/bw/bw get username $ID)
export AWS_SECRET_ACCESS_KEY=$(~/development/apps/bw/bw get password $ID)
