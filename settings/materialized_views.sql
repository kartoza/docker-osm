-- Drop the materialized_views schema if it exists.
DROP SCHEMA IF EXISTS materialized_views CASCADE;


-- Create the materialized_views schema. 
CREATE SCHEMA materialized_views;

ALTER SCHEMA materialized_views OWNER TO docker;


-- Create materialized views for the osm_admin layer. 
CREATE MATERIALIZED VIEW materialized_views.osm_admin_500m_8m AS 
SELECT * 
FROM osm.osm_admin
WHERE admin_level = 2;

CREATE MATERIALIZED VIEW materialized_views.osm_admin_8m_2m AS 
SELECT * 
FROM osm.osm_admin
WHERE admin_level = 3;

CREATE MATERIALIZED VIEW materialized_views.osm_admin_2m_500k AS 
SELECT * 
FROM osm.osm_admin
WHERE admin_level = 4;

CREATE MATERIALIZED VIEW materialized_views.osm_admin_500k_0 AS 
SELECT * 
FROM osm.osm_admin
WHERE admin_level > 4;


-- Create materialized views for the osm_roads layer. 
CREATE MATERIALIZED VIEW materialized_views.osm_roads_15m AS 
SELECT *
FROM osm.osm_roads
WHERE type SIMILAR TO '%(trunk|primary)%';

CREATE MATERIALIZED VIEW materialized_views.osm_roads_1m AS 
SELECT * 
FROM osm.osm_roads
WHERE type SIMILAR TO '%(secondary)%';

CREATE MATERIALIZED VIEW materialized_views.osm_roads_500k AS 
SELECT * 
FROM osm.osm_roads
WHERE type SIMILAR TO '%(tertiary)%';

CREATE MATERIALIZED VIEW materialized_views.osm_roads_15k AS 
SELECT * 
FROM osm.osm_roads
WHERE type NOT LIKE ALL(ARRAY['trunk', 'trunk_link', 'primary', 'primary_link',  'secondary', 'secondary_link', 'tertiary', 'tertiary_link']);


-- Create materialized views for the osm_places layer.
CREATE MATERIALIZED VIEW materialized_views.osm_places_8m_2m AS 
SELECT * 
FROM osm.osm_places
WHERE place IN ('state', 'region');

CREATE MATERIALIZED VIEW materialized_views.osm_places_2m_500k AS 
SELECT * 
FROM osm.osm_places
WHERE place = 'county';

CREATE MATERIALIZED VIEW materialized_views.osm_places_2m_150k AS 
SELECT * 
FROM osm.osm_places
WHERE place = 'city';

CREATE MATERIALIZED VIEW materialized_views.osm_places_150k AS 
SELECT * 
FROM osm.osm_places
WHERE place = 'town';

CREATE MATERIALIZED VIEW materialized_views.osm_places_70k AS 
SELECT * 
FROM osm.osm_places
WHERE place IN ('suburb', 'village', 'hamlet') ;

CREATE MATERIALIZED VIEW materialized_views.osm_places_35k AS 
SELECT * 
FROM osm.osm_places
WHERE place = 'locality';