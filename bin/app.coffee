icsToCsv = require('./icsToCsv')
express = require('express')

app = express()

app.use(express.bodyParser());
app.use(express.methodOverride());
app.use(app.router);
app.use(express.errorHandler());

app.set('views', __dirname + '/views');
app.set('view engine', 'jade');

app.get('/', (req, res) ->
  res.render('index', {})
)

app.post('/', (req, res) ->
  icsToCsv.loadChunkFromUrl(req.param('icsHost'), req.param('icsPath'), (data) ->
    icsToCsv.parseChunk(data, (events) ->
      res.render('data', { events: events })
    )
  )

)

app.listen(3000);

