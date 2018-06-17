#!/bin/bash

echo "["
cat $1 | grep _00_ | perl -pe 's/.*://g; ' | sed -e '/====/d' | perl -pe 's/\n+/, /g'
echo "]"

echo "["
cat $1 | grep _05_ | perl -pe 's/.*://g; ' | sed -e '/====/d' | perl -pe 's/\n+/, /g'
echo "]"

echo "["
cat $1 | grep _10_ | perl -pe 's/.*://g; ' | sed -e '/====/d' | perl -pe 's/\n+/, /g'
echo "]"

echo "["
cat $1 | grep _15_ | perl -pe 's/.*://g; ' | sed -e '/====/d' | perl -pe 's/\n+/, /g'
echo "]"

echo "["
cat $1 | grep _20_ | perl -pe 's/.*://g; ' | sed -e '/====/d' | perl -pe 's/\n+/, /g'
echo "]"

echo "["
cat $1 | grep _inf_ | perl -pe 's/.*://g; ' | sed -e '/====/d' | perl -pe 's/\n+/, /g'
echo "]"
