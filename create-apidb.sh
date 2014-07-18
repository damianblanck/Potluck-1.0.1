#!/bin/bash

#export DATABASE=hoot-test

#echo $DATABASE

sudo su - postgres -c 'createdb -E UTF8 -O openstreetmap hoot-test'

psql -d hoot-test -c "CREATE EXTENSION btree_gist"

psql -d hoot-test -c "CREATE FUNCTION maptile_for_point(int8, int8, int4) RETURNS int4 AS '/tmp/libpgosm.so', 'maptile_for_point' LANGUAGE C STRICT"

psql -d hoot-test -c "CREATE FUNCTION tile_for_point(int4, int4) RETURNS int8 AS '/tmp/libpgosm.so', 'tile_for_point' LANGUAGE C STRICT"

psql -d hoot-test -c "CREATE FUNCTION xid_to_int4(xid) RETURNS int4 AS '/tmp/libpgosm.so', 'xid_to_int4' LANGUAGE C STRICT" 

bundle exec rake db:migrate

osmosis --read-pbf /home/toleary/data/hawaii-latest.osm.pbf --write-apidb database="hoot-test" user="openstreetmap" validateSchemaVersion=no
#osmosis --read-pbf /home/toleary/data/vermont-latest.osm.pbf --write-apidb database="hoot-test" user="openstreetmap" validateSchemaVersion=no
#osmosis --read-pbf /home/toleary/data/HGIS/somalia.osm.pbf --write-apidb database="hoot-test" user="openstreetmap" validateSchemaVersion=no
#osmosis --read-xml /home/toleary/data/hoot-test.osm --write-apidb database="hoot-test" user="openstreetmap" validateSchemaVersion=no
#osmosis --read-xml /home/toleary/data/maax/MaaxAlx.osm --write-apidb database="hoot-test" user="openstreetmap" validateSchemaVersion=no

psql -d hoot-test -c "SELECT setval('current_nodes_id_seq', (SELECT max(id) from current_nodes))"
psql -d hoot-test -c "SELECT setval('current_ways_id_seq', (SELECT max(id) from current_ways))"
psql -d hoot-test -c "SELECT setval('current_relations_id_seq', (SELECT max(id) from current_relations))"
psql -d hoot-test -c "SELECT setval('changesets_id_seq', (SELECT max(id) from changesets))"
