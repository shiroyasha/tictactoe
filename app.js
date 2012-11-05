var express = require('express');
var app = express();

app.use(express.static(__dirname + '/public'));

app.set('views', __dirname + '/public');
app.engine('html', require('ejs').renderFile );

app.get('/', function(req, res){
  res.render('index.html');
});

app.listen( process.env.PORT || 5000 );
