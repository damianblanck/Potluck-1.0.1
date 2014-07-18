#!/bin/bash

#NODES

#Make the emtpy file
echo "*"
echo "Make Nodes File"
echo "*"
sudo touch /tmp/node.copy

#Change permissions to postgres:postgres
echo "*"
echo "Change perms"
echo "*"
sudo chown postgres:postgres /tmp/node.copy

#Copying table from postgresql database to empty file
echo "*"
echo "Copy table to new file"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY nodes TO '/tmp/node.copy' (DELIMITER '|');"

#Organize the output from previous step to match the schema of empty table to populate
echo "*"
echo "Organize File"
echo "*"
sudo cat /tmp/node.copy | awk -F'|' '{print $1 "|" $2 "|" $3 "|" $4 "|" $5 "|" $6 "|" $7 "|" $8}' > /tmp/node-edited.copy

#Push the updated file to the empty table in the database
echo "*"
echo "Push file into empty table"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY current_nodes FROM '/tmp/node-edited.copy' (DELIMITER '|');"

#Move outputs to history folder to free space
echo "*"
echo "Moving Files"
echo "*"
#sudo mv node* /data/pgsql-tables/world/


#WAYS

#Make the emtpy file
echo "*"
echo "Make Ways File"
echo "*"
sudo touch /tmp/way.copy

#Change permissions to postgres:postgres
echo "*"
echo "Change perms"
echo "*"
sudo chown postgres:postgres /tmp/way.copy

#Copying table from postgresql database to empty file
echo "*"
echo "Copy table to new file"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY ways TO '/tmp/way.copy' (DELIMITER '|');"

#Organize the output from previous step to match the schema of empty table to populate
echo "*"
echo "Organize File"
echo "*"
sudo cat /tmp/way.copy | awk -F'|' '{print $1 "|" $2 "|" $3 "|" $5 "|" $4}' > /tmp/way-edited.copy

#Push the updated file to the empty table in the database
echo "*"
echo "Push file into empty table"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY current_ways FROM '/tmp/way-edited.copy' (DELIMITER '|');"

#Move outputs to history folder to free space
echo "*"
echo "Moving Files"
echo "*"
#sudo mv way* /data/pgsql-tables/world/


#NODE-TAGS

#Make the emtpy file
echo "*"
echo "Make Node-tags File"
echo "*"
sudo touch /tmp/node-tags.copy

#Change permissions to postgres:postgres
echo "*"
echo "Change perms"
echo "*"
sudo chown postgres:postgres /tmp/node-tags.copy

#Copying table from postgresql database to empty file
echo "*"
echo "Copy table to new file"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY node_tags TO '/tmp/node-tags.copy' (DELIMITER '|');"

#Organize the output from previous step to match the schema of empty table to populate
echo "*"
echo "Organize File"
echo "*"
sudo cat /tmp/node-tags.copy | awk -F'|' '{print $1 "|" $3 "|" $4}' > /tmp/node-tags-edited.copy

#Push the updated file to the empty table in the database
echo "*"
echo "Push file into empty table"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY current_node_tags FROM '/tmp/node-tags-edited.copy' (DELIMITER '|');"

#Move outputs to history folder to free space
echo "*"
echo "Moving Files"
echo "*"
#sudo mv node* /data/pgsql-tables/world/


#WAY-TAGS

#Make the emtpy file
echo "*"
echo "Make way-tags File"
echo "*"
sudo touch /tmp/way-tags.copy

#Change permissions to postgres:postgres
echo "*"
echo "Change perms"
echo "*"
sudo chown postgres:postgres /tmp/way-tags.copy

#Copying table from postgresql database to empty file
echo "*"
echo "Copy table to new file"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY way_tags TO '/tmp/way-tags.copy' (DELIMITER '|');"

#Organize the output from previous step to match the schema of empty table to populate
echo "*"
echo "Organize File"
echo "*"
sudo cat /tmp/way-tags.copy | awk -F'|' '{print $1 "|" $2 "|" $3}' > /tmp/way-tags-edited.copy

#Push the updated file to the empty table in the database
echo "*"
echo "Push file into empty table"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY current_way_tags FROM '/tmp/way-tags-edited.copy' (DELIMITER '|');"

#Move outputs to history folder to free space
echo "*"
echo "Moving Files"
echo "*"
#sudo mv way* /data/pgsql-tables/world/


#WAY-NODES

#Make the emtpy file
echo "*"
echo "Make way-nodes File"
echo "*"
sudo touch /tmp/way-nodes.copy

#Change permissions to postgres:postgres
echo "*"
echo "Change perms"
echo "*"
sudo chown postgres:postgres /tmp/way-nodes.copy

#Copying table from postgresql database to empty file
echo "*"
echo "Copy table to new file"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY way_nodes TO '/tmp/way-nodes.copy' (DELIMITER '|');"

#Organize the output from previous step to match the schema of empty table to populate
echo "*"
echo "Organize File"
echo "*"
sudo cat /tmp/way-nodes.copy | awk -F'|' '{print $1 "|" $2 "|" $4}' > /tmp/way-nodes-edited.copy

#Push the updated file to the empty table in the database
echo "*"
echo "Push file into empty table"
echo "*"
sudo psql hoot-test -U openstreetmap -c "COPY current_way_nodes FROM '/tmp/way-nodes-edited.copy' (DELIMITER '|');"

#Move outputs to history folder to free space
echo "*"
echo "Moving Files"
echo "*"
#sudo mv way* /data/pgsql-tables/world/


echo "Removing files"
sudo rm /tmp/node*
sudo rm /tmp/way*
