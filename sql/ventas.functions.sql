--
-- @file ventas.functions.sql
--
-- @brief Funciones para el esquema ventas.
--
-- @author Josué Gutiérrez Quino <josuandroidg7@gmail.com>
--
--

-- + Muestra la lista de clientes en la empresa
-- + > ventas.clientes: Lista de clientes
create or replace function ventas.mostrarClientes(
    token_      text )          -- + User connection token
returns text                    -- + Json del informe
language 'plpgsql'
as $__$
declare
    idUser_     integer;
begin
    idUser_ = security.comprobarAcceso( token_ );
    return json_build_object(
        'status', 'ok',
        'data', ( select 
                      json_agg( t )
                    from
                      ( 
                        select 
                            id_cliente,
                            nombre_cliente,
                            mail,
                            celular,
                            fecha_inicio_cliente,
                            enabled
                          from
                            ventas.clientes
                          where
                            enabled 
                          order by
                            nombre_cliente
                      ) t 
                ) );
exception when others then
    raise exception '%', glb.checkError( SQLSTATE, SQLERRM );
    return '';
end;$__$;

-- + Muestra la lista de productos existentes en la empresa
-- + > ventas.productos: Lista de clientes
create or replace function ventas.mostrarProductos(
    token_      text )          -- + User connection token
returns text                    -- + Json del informe
language 'plpgsql'
as $__$
declare
    idUser_     integer;
begin
    idUser_ = security.comprobarAcceso( token_ );
    -- TODO: Se comprueba si es admin
    return json_build_object(
        'status', 'ok',
        'data', ( select 
                      json_agg( t )
                    from
                      ( 
                        select 
                            id_producto,
                            producto,
                            descripcion,
                            costo_unitario,
                            photo,
                            enabled
                          from
                            ventas.productos
                          where
                            enabled 
                          order by
                            producto
                      ) t 
                ) );
exception when others then
    raise exception '%', glb.checkError( SQLSTATE, SQLERRM );
    return '';
end;$__$;

