#!/bin/bash

# ADD and DROP CONSTRAINTS for nodes and ways - Add max value of each feature to current_*** tables
echo "Alter tables - nodes"

psql -d hoot-test -c 'ALTER TABLE nodes ADD CONSTRAINT node_constraint FOREIGN KEY (node_id) REFERENCES current_nodes (id) ON UPDATE CASCADE ON DELETE CASCADE'
psql -d hoot-test -c 'ALTER TABLE node_tags ADD CONSTRAINT node_constraint FOREIGN KEY (node_id) REFERENCES current_nodes (id) ON UPDATE CASCADE ON DELETE CASCADE'
psql -d hoot-test -c 'ALTER TABLE way_nodes ADD CONSTRAINT node_constraint FOREIGN KEY (node_id) REFERENCES current_nodes (id) ON UPDATE CASCADE ON DELETE CASCADE'
psql -d hoot-test -c 'ALTER TABLE current_node_tags ADD CONSTRAINT node_constraint FOREIGN KEY (node_id) REFERENCES current_nodes (id) ON UPDATE CASCADE ON DELETE CASCADE'
psql -d hoot-test -c 'ALTER TABLE current_way_nodes ADD CONSTRAINT node_constraint FOREIGN KEY (node_id) REFERENCES current_nodes (id) ON UPDATE CASCADE ON DELETE CASCADE'


psql -d hoot-test -c 'ALTER TABLE current_node_tags DROP CONSTRAINT "current_node_tags_id_fkey"'
psql -d hoot-test -c 'ALTER TABLE current_way_nodes DROP CONSTRAINT "current_way_nodes_node_id_fkey"'

echo "*"
echo "Adding nodes"
echo "*"
##Somalia
#psql -d hoot-test -c 'UPDATE current_nodes set id = id + 8291637'
##Maax data
psql -d hoot-test -c 'UPDATE current_nodes set id = id + 126'

echo "Alter tables - ways"

psql -d hoot-test -c 'ALTER TABLE ways ADD CONSTRAINT way_constraint FOREIGN KEY (way_id) REFERENCES current_ways (id) ON UPDATE CASCADE ON DELETE CASCADE'
psql -d hoot-test -c 'ALTER TABLE way_tags ADD CONSTRAINT way_constraint FOREIGN KEY (way_id) REFERENCES current_ways (id) ON UPDATE CASCADE ON DELETE CASCADE'
psql -d hoot-test -c 'ALTER TABLE way_nodes ADD CONSTRAINT way_constraint FOREIGN KEY (way_id) REFERENCES current_ways (id) ON UPDATE CASCADE ON DELETE CASCADE'
psql -d hoot-test -c 'ALTER TABLE current_way_nodes ADD CONSTRAINT way_constraint FOREIGN KEY (way_id) REFERENCES current_ways (id) ON UPDATE CASCADE ON DELETE CASCADE'
psql -d hoot-test -c 'ALTER TABLE current_way_tags ADD CONSTRAINT way_constraint FOREIGN KEY (way_id) REFERENCES current_ways (id) ON UPDATE CASCADE ON DELETE CASCADE'


psql -d hoot-test -c 'ALTER TABLE current_way_tags DROP CONSTRAINT "current_way_tags_id_fkey"'
psql -d hoot-test -c 'ALTER TABLE current_way_nodes DROP CONSTRAINT "current_way_nodes_id_fkey"'

echo "*"
echo "Adding ways"
echo "*"
##Somalia
#psql -d hoot-test -c 'UPDATE current_ways set id = id + 111766'
##Maax data
psql -d hoot-test -c 'UPDATE current_ways set id = id + 26'


# Read APIdb and write out pbf to ingest into new database to keep consistency 
echo "Reading out database"
osmosis --read-apidb database="hoot-test" user="openstreetmap" validateSchemaVersion=no --write-pbf file="hoot-test.pbf"


# Create new blank database - ingest written pbf
echo "Creating new databsae"

sudo su - postgres -c 'dropdb hoot-test'

sudo su - postgres -c 'createdb -E UTF8 -O openstreetmap hoot-test'

psql -d hoot-test -c "CREATE EXTENSION btree_gist"

psql -d hoot-test -c "CREATE FUNCTION maptile_for_point(int8, int8, int4) RETURNS int4 AS '/tmp/libpgosm.so', 'maptile_for_point' LANGUAGE C STRICT"

psql -d hoot-test -c "CREATE FUNCTION tile_for_point(int4, int4) RETURNS int8 AS '/tmp/libpgosm.so', 'tile_for_point' LANGUAGE C STRICT"

psql -d hoot-test -c "CREATE FUNCTION xid_to_int4(xid) RETURNS int4 AS '/tmp/libpgosm.so', 'xid_to_int4' LANGUAGE C STRICT" 

bundle exec rake db:migrate

echo "Reading in database"
#osmosis --read-pbf /home/toleary/data/hawaii-latest.osm.pbf --write-apidb database="hoot-test" user="openstreetmap" validateSchemaVersion=no
#osmosis --read-pbf /home/toleary/data/HGIS/somalia.osm.pbf --write-apidb database="hoot-test" user="openstreetmap" validateSchemaVersion=no
osmosis --read-pbf /home/toleary/openstreetmap-website/hoot-test.pbf --write-apidb database="hoot-test" user="openstreetmap" validateSchemaVersion=no

psql -d hoot-test -c "SELECT setval('current_nodes_id_seq', (SELECT max(id) from current_nodes))"
psql -d hoot-test -c "SELECT setval('current_ways_id_seq', (SELECT max(id) from current_ways))"
psql -d hoot-test -c "SELECT setval('current_relations_id_seq', (SELECT max(id) from current_relations))"
psql -d hoot-test -c "SELECT setval('changesets_id_seq', (SELECT max(id) from changesets))"
