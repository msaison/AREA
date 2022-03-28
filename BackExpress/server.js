const express = require('express')
const morgan = require('morgan')
const cors = require('cors')
const bodyParser = require('body-parser')
const routes = require('./routes/index')
const Sentry = require("@sentry/node");
const Tracing = require("@sentry/tracing");

const localtunnel = require('localtunnel');

const app = express()

if (process.env.NODE_ENV === 'development') {
    app.use(morgan('dev'))
}

app.use(cors())
app.use(bodyParser.urlencoded({ extended: false }))
app.use(bodyParser.json())

Sentry.init({
    dsn: "https://5e0b101e5c3e45b29ef86374898871c6@o1177292.ingest.sentry.io/6276171",
    integrations: [
        // enable HTTP calls tracing
        new Sentry.Integrations.Http({ tracing: true }),
        // enable Express.js middleware tracing
        new Tracing.Integrations.Express({ app }),
    ],

    // Set tracesSampleRate to 1.0 to capture 100%
    // of transactions for performance monitoring.
    // We recommend adjusting this value in production
    tracesSampleRate: 1.0,
});

// RequestHandler creates a separate execution context using domains, so that every
// transaction/span/breadcrumb is attached to its own Hub instance
app.use(Sentry.Handlers.requestHandler());
// TracingHandler creates a trace for every incoming request
app.use(Sentry.Handlers.tracingHandler());

app.use(routes)

app.use(Sentry.Handlers.errorHandler());
// Optional fallthrough error handler
app.use(function onError(err, req, res, next) {
    // The error id is attached to `res.sentry` to be returned
    // and optionally displayed to the user for support.
    res.statusCode = 500;
    res.end(res.sentry + "\n");
});

const PORT = process.env.PORT || 3000

app.listen(PORT,async (err) => {
        if (err) return console.log(`Something bad happened: ${err}`);
        console.log(`Node.js server listening on ${PORT}`);
    
        let tunnel = await localtunnel(PORT, { subdomain: "areabackexpress" })
        if (err) throw err;
        console.log(`Area Back en is available at ${tunnel.url}`);
    }
)