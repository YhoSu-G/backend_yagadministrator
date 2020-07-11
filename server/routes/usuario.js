/*
 * @file usuario.js
 *
 * @brief Rutas de usuario 
 *
 * @author Josué Gutiérrez Quino <josuandroidg7@gmail.com>
 *
*/

const express = require( 'express' );
const app = express();

const { Client } = require('pg');
const client = new Client({
    user: 'josue',
    host: 'localhost',     // Cambiado para pruebas
    database: 'cytcorp',
    password: 'a',
    port: 5432,
});

client.connect( err => {
    if ( err ) {
        throw err.stack;
    }
});


// + AUTENTICANDO AL USUARIO
app.post( '/cyt/autenticar', async ( req, res ) => {
    let body =  await req.body;    
    client.query( 
        'select * from security.autenticar( $1, $2 )', 
        [ body.login, body.password ], 
        (error, respuesta) => {
          if ( error ) {
              res.json( {
                  'status' : 'nok',
                  'message' : error.message
              });
              return;      
          }
          res.send( JSON.parse( respuesta.rows[0]['autenticar'] ) );
        });
})

// + MOSTRAR DATOS DEL USUARIO CONECTADO
app.post( '/cyt/usuario', function ( req, res ) {
    let body = req.body;
    client.query( 
        'select * from security.datosUsuarioConectado( $1::text )', 
        [ body.token ], 
        (error, respuesta) => {
          if ( error ) {
              res.json( {
                  'status' : 'nok',
                  'message' : error.message
              });
              return;      
          }
          res.send( JSON.parse( respuesta.rows[0]['datosusuarioconectado'] ) );
        });
});

// + MOSTRAR A LOS CLIENTES ACTUALES
app.post( '/cyt/clientes/mostrar', ( req, res ) => {
    let body = req.body;
    client.query(
        'select * from ventas.mostrarClientes( $1::text )', 
        [ body.token ], 
        ( error, respuesta) => {
            if ( error ) {
                res.json( {
                    'status' : 'nok',
                    'message' : error.message
                });
                return;
            }
            res.send( JSON.parse( respuesta.rows[0]['mostrarclientes'] ) );
        }
    )
} );

// + MOSTRAR TODOS LOS PRODUCTOS EXISTENTES
app.post( '/cyt/productos/mostrar', ( req, res ) => {
    let body = req.body;
    client.query(
        'select * from ventas.mostrarProductos( $1::text )', 
        [ body.token ], 
        ( error, respuesta) => {
            if ( error ) {
                res.json( {
                    'status' : 'nok',
                    'message' : error.message
                });
                return;
            }
            res.send( JSON.parse( respuesta.rows[0]['mostrarproductos'] ) );
        }
    )
} );


module.exports = app;