express = require 'express'
app = express()

config =
  port: process.env.HELEN_MYSTIC_PORT or 8000
  title: 'Helen Mystic Search'


exphbs = require 'express-handlebars'

app.set 'config', config
app.set 'locals',
  config: config

app.set 'view engine', 'hbs'
app.set 'locals',
  config: app.get 'config'

app.engine 'hbs', exphbs
  extname: 'hbs'
  defaultLayout: 'main'

app.get '/', (req, res) ->
  res.render 'home',
    title: 'Search Inside Yourself'

server = app.listen app.get('config').port, ->

  host = server.address().address
  port = server.address().port

  console.log 'Listening at http://%s:%s', host, port
