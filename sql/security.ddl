--
-- @file security.ddl
--
-- @brief Tablas del esquema de seguridad
--
-- @author Josué Gutiérrez Quino <josuandroidg7@gmail.com>
--
--


create table security.rols (
  id_rol                        serial primary key,
  codigo                        char not null unique,
  rol                           text not null unique,
  description                   text,
  enabled                       boolean not null default true,
  date_of_creation              timestamp with time zone not null default now(),
  last_modification             timestamp with time zone not null default now()
);

create table security.users (
  id_user                 serial primary key,
  login                   text unique,
  password                text not null,
  full_name               character varying( 200 ) default '',
  mail                    character varying( 255 ) default '',
  photo                   text,
  birth_date              date,
  direccion               text,
  celular                 text unique,
  telefono_fijo           text,
  document_id             text,
  document_expedition     text,
  id_rol                  integer not null constraint rol references security.users (id_user) on delete restrict on update cascade,
  enabled                 boolean not null default true,                 
  id_creator              integer not null,
  date_of_creation        timestamp with time zone not null default now(),
  id_modificator          integer not null,
  last_modification       timestamp with time zone not null default now()
);
comment on table security.users is 'Tabla de usuarios con acceso al sistema';
comment on column security.users.id_user              is 'Identificador de usuario';
comment on column security.users.login                is 'Login de inicio de sesión';
comment on column security.users.password             is 'Contraseña';
comment on column security.users.full_name            is 'Nombre del usuario';
comment on column security.users.mail                 is 'Correo electrónico';
comment on column security.users.photo                is 'Fotografia del usuario';
comment on column security.users.id_rol               is 'Rol asignado';
comment on column security.users.enabled              is 'Estado del registro';
comment on column security.users.id_creator           is 'Creador';
comment on column security.users.last_modification    is 'Fecha de creación';
comment on column security.users.id_modificator       is 'Modificador';
comment on column security.users.date_of_creation     is 'Última fecha de modificación';

create table security.time_units (
  id_time_unit              serial primary key,
  time_units                text,
  description               text,
  enabled                   boolean not null default true,                 
  date_of_creation          timestamp with time zone not null default now(),
  last_modification         timestamp with time zone not null default now()
);
comment on table security.time_units                       is 'Tabla de unidades de medida de tiempo';
comment on column security.time_units.id_time_unit         is 'Unidad de medida';
comment on column security.time_units.description          is 'Descripcion';
comment on column security.time_units.enabled              is 'Estado del registro';
comment on column security.time_units.last_modification    is 'Fecha de creación';
comment on column security.time_units.date_of_creation     is 'Última fecha de modificación';

-- + Tabla de tokens
create table security.token (
    id_token       serial primary key,
    id_usuario     integer not null constraint c_usuario references security.users (id_user) on delete restrict on update cascade,
    acceso_token   uuid default uuid_generate_v4() not null unique,
    coneccion      timestamp with time zone not null default current_timestamp
);


