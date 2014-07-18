#!/bin/bash

echo "*"
echo "*"
echo "Creating Website"
echo "*"
echo "*"

sh /home/toleary/openstreetmap-website/create-apidb.sh

echo "*"
echo "*"
echo "Copying tables"
echo "*"
echo "*"

sh /home/toleary/openstreetmap-website/copy-tables.sh


echo "*"
echo "*"
echo "Updating Database"
echo "*"
echo "*"

sh /home/toleary/openstreetmap-website/update-apidb.sh
