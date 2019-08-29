#!/bin/bash
registrar=$(cat info/$1.txt | grep -P "Registrar:.{0,30}")
echo ${registrar}
