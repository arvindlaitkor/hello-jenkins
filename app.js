var express = require('express');
 
var app = express();
 
app.get('/', function (req, res) {
  res.send('hello jenkins Laitkor  Demo testing on Video'); 
});
 
app.listen(process.env.PORT || 5000);
 
module.exports = app;
