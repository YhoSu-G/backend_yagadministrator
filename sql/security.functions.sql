--
-- @file security.functions.sql
--
-- @brief Funciones del esquema de seguridad
--
-- @author Josué Gutiérrez Quino <josuandroidg7@gmail.com>
--
--

-- Crear unidades de tiempo
create or replace function security.crearUnidadTiempo( 
    timeUnit_       text, 
    description_    text )
returns void 
language 'plpgsql'
as $__$
begin
    insert into security.time_units ( time_units, description ) values ( timeUnit_, description_ ); 
end;$__$;

-- + > Crear roles
create or replace function security.crearRol( 
    codigo_          text,
    rol_             text,
    descripcion_     text )
returns void
language 'plpgsql'
as $__$
begin
    insert into security.rols ( codigo, rol, description ) values ( codigo_, rol_, descripcion_ );
end;$__$;

-- + > sg.desconectaUsuario: Desconecta un usuario conectado
create or replace function security.desconectaUsuario(
    token_     text )       -- + Usuario id
returns text
language 'plpgsql'
as $__$
declare
    response_ boolean;
begin
    if not exists ( select 1 from security.token where acceso_token::text = token_ ) then
        raise exception 'Conexion de usuario no encontrada';
    end if;
    delete from security.token where acceso_token::text = token_;
    return json_build_object(
        'message', 'Usuario desconectado',
        'status', 'ok' );
exception when others then
    raise exception '%', glb.checkError( SQLSTATE, SQLERRM );
    return '';
end;$__$;


-- + > sg.comprobarToken: Verifica si el token está activo
create or replace function security.comprobarToken(
    token_     text )       -- + Usuario id
returns text
language 'plpgsql'
as $__$
begin
    return json_build_object(
        'valid', exists ( select 1 from security.token where acceso_token::text = token_ ),
        'status', 'ok' );
exception when others then
    raise exception '%', glb.checkError( SQLSTATE, SQLERRM );
    return '';
end;$__$;


-- + > sg.comprobarAcceso: [CUD|sc.tokens] Establece si el token tiene acceso al recurso
 -- + Verifica que el usuario (según sus roles) puede o no acceder
create or replace function security.comprobarAcceso(
    token_       text )      -- + Código numérico de recurso
returns integer                 -- + Id del usuario
language 'plpgsql'
as $__$
declare
    iduser_        integer;
    resourceRoles_ text;
    userRoles_     text;
begin
    select id_usuario into idUser_ from security.token where acceso_token::text = token_;
    if idUser_ is null then
        raise exception 'User is not connected';
    end if;
    -- TODO: Borrar a root en producción
    if idUser_ = 1 then
        return 1;
    end if;
    -- select roles into userRoles_ from sg.usuarios where id_usuario = idUser_;
    -- select roles into resourceRoles_ from sg.recursos where codigo = code_;
    -- if userRoles_ ~ '[' || resourceRoles_ || ']' then
    --     return idUser_;
    -- end if;
    raise exception 'Credenciales insuficientes para acceder al recurso';
    return 0;
exception when others then
    raise exception '%', glb.checkError( SQLSTATE, SQLERRM );
    return 0;
end;$__$;

-- + > security.conectarUsuario: Conecta un usuario dado su id
 -- + Crea un token de acceso para un usuario. Si ya existe
 -- + conexión, ésta es eliminada
create or replace function security.conectarUsuario(
    idUser_     integer )       -- + User id
returns text
language 'plpgsql'
as $__$
declare
    token_      text;
begin
    if not exists ( select 1 from security.users where id_user = idUser_ ) then
        raise exception 'Usuario no encontrado';
    end if;
    delete from security.token where id_usuario = idUser_;
    insert into security.token ( id_usuario )
      values ( idUser_ )
      returning acceso_token
      into token_;
    return token_;
exception when others then
    raise exception '%', glb.checkError( SQLSTATE, SQLERRM );
    return '';
end;$__$;


-- + > sg.conectarUsuario: Conectar usuario dado su email
 -- + Crea un token de acceso para un usuario. Si ya existe
 -- + conexión, ésta es eliminada
create or replace function security.autenticar(
    login_        text,            -- + User usuario
    password_     text )           -- + User password
returns text
language 'plpgsql'
as $__$
declare
    idUser_     integer;
begin
    if coalesce( login_, '' ) = '' then
        raise exception 'Usuario esta vacio';
    end if;
    select
        id_user
      into
        idUser_
      from
        security.users
      where
        login = login_
        and password = crypt( password_, password );
    if idUser_ is null then
        raise exception 'Usuario o clave incorrecto';
    end if;
    return json_build_object(
        'token', security.conectarUsuario( idUser_ ),
        'status', 'ok' );
exception when others then
    raise exception '%', glb.checkError( SQLSTATE, SQLERRM );
    return '';
end;$__$;

-- + datosUsuario
-- + > sg.datosUsuario: [R|sc.users] Datos de un Usuario
create or replace function security.datosUsuario(
    token_      text,           -- + User connection token
    idUsers_    integer )       -- + User id
returns text                    -- + Json del informe
language 'plpgsql'
as $__$
declare
    idUser_     integer;
begin
    idUser_ = security.comprobarAcceso( token_ );
    if not exists ( select 1 from security.users where id_user = idUsers_ ) then
        raise exception 'User not found';
    end if;
    return 
        ( select
              row_to_json(t)
            from (
              select
                  id_user,
                  login,
                  mail,
                  rol,
                  full_name,
                  enabled,
                  'ok' as status
                from
                  security.users
                where
                  id_user = idUsers_
            ) t );
exception when others then
    raise exception '%', glb.checkError( SQLSTATE, SQLERRM );
    return '';
end;$__$;


-- + datosUsuario persona conectada
-- + > sg.datosUsuario: [R|sc.users] Datos del Usuario Conectado
create or replace function security.datosUsuarioConectado(
    token_      text )          -- + User connection token
returns text                    -- + Json del informe
language 'plpgsql'
as $__$
declare
    idUser_     integer;
begin
    idUser_ = security.comprobarAcceso( token_ );
    if not exists ( select 1 from security.users where id_user = idUser_ ) then
        raise exception 'User not found';
    end if;
    return 
        ( select
              row_to_json(t)
            from (
              select
                  sc.id_user,
                  sc.login,
                  sc.mail,
                --   sc.id_rol,
                  to_char( sc.birth_date, 'DD/MM/YYYY' ) as birth_date,
                  coalesce( sc.direccion, '' ) as direccion,
                  coalesce( sc.celular, '' ) as celular,
                  coalesce( sc.telefono_fijo, '' ) as telefono_fijo,
                  r.rol,
                  sc.full_name,
                  ( sc.document_id || ' ' || sc.document_expedition ) as document_id,
                  sc.enabled,
                  sc.photo,
                  'ok' as status
                from
                  security.users sc
                    left join
                  security.rols r using( id_rol )
                where   
                  id_user = idUser_
            ) t );
exception when others then
    raise exception '%', glb.checkError( SQLSTATE, SQLERRM );
    return '';
end;$__$;


