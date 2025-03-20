// firebase/functions/src/index.js

const functions = require('firebase-functions');
const express = require('express');
const bodyParser = require('body-parser');
const admin = require('firebase-admin');

// Initialize Firebase Admin SDK
admin.initializeApp();

// Create an Express application
const app = express();

// Use middleware to parse JSON bodies
app.use(bodyParser.json());

// Require our endpoint modules
const listingsRoutes = require('./listings');
// You can similarly require ordersRoutes and usersRoutes

// Mount the routes under the /api prefix
app.use('/listings', listingsRoutes);

// (Optionally mount orders and users routes)
// app.use('/orders', ordersRoutes);
// app.use('/users', usersRoutes);

// Export the API as a Cloud Function
exports.api = functions.https.onRequest(app);