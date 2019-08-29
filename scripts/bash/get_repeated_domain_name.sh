#!/usr/bin/env bash
cat info/domains-list.txt | egrep -o '^[^.]+' |  awk 'cnt[$0]++{if (cnt[$0]>=2) print;}'