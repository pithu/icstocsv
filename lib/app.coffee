ical = require('ical')
express = require('express')

app = express()

app.use(express["static"](__dirname + '/../public'));
app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.errorHandler());

app.set('views', __dirname + '/../views');
app.set('view engine', 'jade');

app.get('/', (req, res) ->
  res.render('index', {})
)

app.post '/', (req, res) ->
    ical.fromURL req.param('icsUrl'), {}, (err, events) ->
        console.dir(events)
        res.render('data', { events: events })


app.listen(3000);

