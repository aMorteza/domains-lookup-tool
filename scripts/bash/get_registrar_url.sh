#!/bin/bash
registrar_url=$(cat info/$1.txt | grep -P "Registrar URL.{0,30}")
echo ${registrar_url}