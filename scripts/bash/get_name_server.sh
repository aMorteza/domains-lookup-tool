#!/bin/bash
name_server=$(cat info/$1.txt | grep -o -P "nserver.{0,30}|Name Server.{0,30}")
echo ${name_server}