--
-- @file security.fix.root.sql
--
-- @brief Creación del usuario administrador y modificaciónes para las tablas de seguridad.
--
-- @author Josué Gutiérrez Quino <josuandroidg7@gmail.com>
--
--

insert into security.users ( login, mail, password, id_rol, id_creator, id_modificator )
    values ( 'root', 'josuandroidg7@gmail.com', crypt( 'admin', gen_salt( 'bf' ) ), 1, 1, 1 );

alter table security.users add constraint creator foreign key (id_creator)
     references security.users (id_user) on delete restrict on update cascade;
alter table security.users add constraint modificator foreign key (id_modificator)
     references security.users (id_user) on delete restrict on update cascade;

