var app, express, icsToCsv;

icsToCsv = require('./icsToCsv');

express = require('express');

app = express();

app.use(express.bodyParser());

app.use(express.methodOverride());

app.use(app.router);

app.use(express.errorHandler());

app.set('views', __dirname + '/views');

app.set('view engine', 'jade');

app.get('/', function(req, res) {
    return res.render('index', {});
});

app.post('/', function(req, res) {
    return icsToCsv.loadChunkFromUrl(req.param('icsHost'), req.param('icsPath'), function(data) {
        return icsToCsv.parseChunk(data, function(events) {
            return res.render('data', {
                events: events
            });
        });
    });
});

app.listen(3000);


