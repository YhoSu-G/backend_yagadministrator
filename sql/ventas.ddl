--
-- @file ventas.ddl
--
-- @brief Tablas del esquema de ventas
--
-- @author Josué Gutiérrez Quino <josuandroidg7@gmail.com>
--
--

-- + TABLA DE LOS CLIENTES EN C Y T
create table ventas.clientes (
  id_cliente              serial primary key,
  nombre_cliente          character varying( 200 ) default '',
  mail                    character varying( 255 ) default '',
  celular                 character varying(100) null,
  fecha_inicio_cliente    date not null default now(),
  enabled                 boolean not null default true,                 
  date_of_creation        timestamp with time zone not null default now(),
  last_modification       timestamp with time zone not null default now()
);

comment on table  ventas.clientes                        is 'Tabla de clientes';
comment on column ventas.clientes.id_cliente             is 'Identificador del cliente';
comment on column ventas.clientes.nombre_cliente         is 'Nombre del cliente';
comment on column ventas.clientes.mail                   is 'Correo electrónico del cliente';
comment on column ventas.clientes.celular                is 'Número de celular';
comment on column ventas.clientes.fecha_inicio_cliente   is 'Fecha en la que se convirtió cliente';
comment on column ventas.clientes.enabled                is 'Estado del registro';
comment on column ventas.clientes.date_of_creation       is 'Fecha de creación';
comment on column ventas.clientes.last_modification      is 'Última fecha de modificación';



-- + TABLA DE LOS PRODUCTOS EXISTENTES PARA C Y T
create table ventas.productos (
  id_producto             serial primary key,
  producto                character varying( 200 ),
  descripcion             text,
  costo_unitario          numeric,
  photo                   text,
--  tiempo_uso              integer default 0,
--  fecha_inicio            date not null,
--  fecha_fin               date, 
  enabled                 boolean not null default true,                 
  date_of_creation        timestamp with time zone not null default now(),
  last_modification       timestamp with time zone not null default now()
);

comment on table  ventas.productos                        is 'Tabla de productos';
comment on column ventas.productos.id_producto            is 'Identificador del producto';
comment on column ventas.productos.producto               is 'Nombre del producto';
comment on column ventas.productos.descripcion            is 'Descripcion del producto';
comment on column ventas.productos.costo_unitario         is 'Precio del producto';
comment on column ventas.productos.photo                  is 'Foto del producto';
comment on column ventas.productos.enabled                is 'Estado del registro';
comment on column ventas.productos.last_modification      is 'Fecha de creación';
comment on column ventas.productos.date_of_creation       is 'Última fecha de modificación';

--+ Tabla para el control de ventas
create table ventas.ventas (
  id_venta               serial primary key,
  id_cliente             integer not null constraint cliente references ventas.clientes( id_cliente ) on delete restrict on update cascade,
  id_producto            integer not null constraint producto references ventas.productos( id_producto ) on delete restrict on update cascade,
  id_unidad_tiempo       integer not null constraint unidad_tiempo references security.time_units( id_time_unit ) on delete restrict on update cascade,
  tiempo_uso             integer,
  fecha_inicio           date not null default now(),
  fecha_fin              date,
  enabled                boolean not null default true,                 
  date_of_creation       timestamp with time zone not null default now(),
  last_modification      timestamp with time zone not null default now()
);
create index ventas_cliente           on ventas.ventas (id_cliente);
create index ventas_producto          on ventas.ventas (id_producto);
create index ventas_unidad_tiempo     on ventas.ventas (id_unidad_tiempo);

comment on table ventas.ventas                         is 'Tabla de ventas realizadas';
comment on column ventas.ventas.id_venta               is 'Identificador de venta';
comment on column ventas.ventas.id_cliente             is 'Cliente';
comment on column ventas.ventas.id_producto            is 'Producto';
comment on column ventas.ventas.id_unidad_tiempo       is 'Unidad de tiempo( dias, meses, anios )';
comment on column ventas.ventas.tiempo_uso             is 'Tiempo de uso';
comment on column ventas.ventas.fecha_inicio           is 'Fecha de inicio';
comment on column ventas.ventas.fecha_fin              is 'Fecha de fin';
comment on column ventas.ventas.enabled                is 'Estado del registro';
comment on column ventas.ventas.last_modification      is 'Fecha de creación';
comment on column ventas.ventas.date_of_creation       is 'Última fecha de modificación';

