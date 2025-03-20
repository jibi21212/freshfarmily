// firebase/functions/src/listings.js

const express = require('express');
const router = express.Router();
const admin = require('firebase-admin');

// Helper: validate required fields for a listing (adjust as needed)
function validateListingData(data) {
  if (!data.product || !data.product.name || !data.product.price) {
    return "Missing required product fields (name, price)";
  }
  if (data.availableQuantity === undefined) {
    return "Missing available quantity";
  }
  return null;
}

// POST endpoint: Create a new listing
router.post('/', async (req, res) => {
  try {
    const listingData = req.body;
    const validationError = validateListingData(listingData);
    if (validationError) {
      return res.status(400).json({ error: validationError });
    }

    // Set server timestamp if needed.
    listingData.posted = admin.firestore.FieldValue.serverTimestamp();
    listingData.product.posted = admin.firestore.FieldValue.serverTimestamp();

    const docRef = await admin.firestore().collection('listings').add(listingData);
    // Optionally, retrieve the newly created document
    const createdDoc = await docRef.get();

    return res.status(201).json({ message: 'Listing created successfully', listing: { id: docRef.id, ...createdDoc.data() } });
  } catch (error) {
    console.error("Error creating listing:", error);
    return res.status(500).json({ error: error.toString() });
  }
});

// PATCH endpoint: Update an existing listing
router.patch('/:listingId', async (req, res) => {
  try {
    const { listingId } = req.params;
    const updatedData = req.body;
    const validationError = validateListingData(updatedData);
    if (validationError) {
      return res.status(400).json({ error: validationError });
    }
    
    // Update the listing document.
    await admin.firestore().collection('listings').doc(listingId).update(updatedData);
    const updatedDoc = await admin.firestore().collection('listings').doc(listingId).get();

    return res.status(200).json({ message: 'Listing updated successfully', listing: { id: listingId, ...updatedDoc.data() } });
  } catch (error) {
    console.error("Error updating listing:", error);
    return res.status(500).json({ error: error.toString() });
  }
});

module.exports = router;