#!/bin/bash
admin_email=$(cat info/$1.txt | grep -P "e-mail.{0,30}|Admin Email.{0,30}")
echo "$admin_email"