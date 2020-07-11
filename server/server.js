/*
 * @file server.js
 *
 * @brief Main
 *
 * @author Josué Gutiérrez Quino <josuandroidg7@gmail.com>
 *
 */

require( './config/config' );

const express = require( 'express' );
const app = express();



const bodyParser = require( 'body-parser' );

// parse application / x-www- form-urlencoded
app.use( bodyParser.urlencoded( { extended : true } ) );

// parse application/json
app.use( bodyParser.json() );


app.use( require( './routes/usuario') );



app.listen( process.env.PORT, () => {
    console.log( 'Escuchando el puertooo' + process.env.PORT );
})