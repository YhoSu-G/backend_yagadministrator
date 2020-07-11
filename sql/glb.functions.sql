--
-- @file glb.functions.sql
--
-- @brief Funciones del esquema Global.
--
-- @author Josué Gutiérrez Quino <josuandroidg7@gmail.com>
--
--

create or replace function glb.checkError(
    STATE       text,           -- + Estado del error
    ERRM        text )          -- + Mensaje de error
returns text                    -- + Mensaje ajustado para el middleware
language 'plpgsql' immutable
as $__$
begin
    if left( STATE, 1 ) = 'P' -- Class P0 — PL/pgSQL Error
       and left( ERRM, 7 ) != '@ERROR:' then
        ERRM = format( $$@ERROR: %s@$$, ERRM );
    end if;
    return ERRM;
end;
$__$;