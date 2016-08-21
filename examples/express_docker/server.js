'use strict';

const express = require('express');

// Constants
const PORT = 8080;

// App
const app = express();
app.get('/api/products', function (req, res) {
  let roti = {
    name: "Roti rol pittig",
    price: 4.50
  };
  res.send([roti]);
});

app.listen(PORT);
console.log('Running on http://localhost:' + PORT);
