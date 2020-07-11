--
-- @file db.sql
--
-- @brief Ejecución de los archivos sql. || TODO: Crear un bash.
--
-- @author Josué Gutiérrez Quino <josuandroidg7@gmail.com>
--
--

create extension if not exists pgcrypto;
create extension if not exists "uuid-ossp";

drop schema if exists glb cascade;
create schema glb;
comment on schema glb is 'Global';

drop schema if exists security cascade;
create schema security;
comment on schema security is 'Seguridad';

drop schema if exists ventas cascade;
create schema ventas;
comment on schema ventas is 'Tablas del esquema de ventas';

\i glb.functions.sql
\i security.functions.sql

\i security.ddl
\i ventas.ddl

\i security.dml
\i ventas.dml

\i security.fix.root.sql

\i ventas.functions.sql