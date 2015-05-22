express = require 'express'
app = express()

config =
  port: process.env.HELEN_MYSTIC_PORT or 8000
  title: 'Helen Mystic'

results = require './results'

exphbs = require 'express-handlebars'

app.set 'config', config

app.set 'view engine', 'hbs'

app.engine 'hbs', exphbs
  extname: 'hbs'
  defaultLayout: 'main'

app.set 'locals',
  config: app.get 'config'

app.get '/', (req, res) ->
  res.render 'home',
    title: 'Search Inside Yourself'

app.get '/search', (req, res) ->
  query = req.query.q or ''
  queryResults = query.split(' ')
  .map (word) -> word.toLowerCase()
  .reduce (memo, word) ->
    if word.length <= 0 then return memo
    for key, resultList of results
      if key.indexOf(word) > -1 then memo.push.apply memo, resultList
    memo
  , []
  res.render 'search',
    title: "Results for \"#{query}\""
    query: query
    results: queryResults

server = app.listen app.get('config').port, ->

  host = server.address().address
  port = server.address().port

  console.log 'Listening at http://%s:%s', host, port
