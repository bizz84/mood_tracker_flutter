import * as admin from 'firebase-admin'
import * as functions from 'firebase-functions'

admin.initializeApp();

exports.updateMoodCounters = functions.firestore
    .document('mood/{moodId}').onCreate((_, __) => {
        return updateCounters()
    });
    
async function updateCounters() {
    const firestore = admin.firestore()
    var positive = 0
    var neutral = 0
    var negative = 0
    // iterate through all the cart items
    const collection = await firestore.collection(`mood`).get()
    for (const doc of collection.docs) {
        // extract the items data
        const { mood } = doc.data()
        if (mood === '😀') {
            positive++
        } else if (mood === '😐') {
            neutral++
        } else if (mood === '😟') {
            negative++
        }
    }
    console.log({
        'positive': positive,
        'neutral': neutral,
        'negative': negative,
    })
    return await firestore.doc(`totals/mood`).set({
        'positive': positive,
        'neutral': neutral,
        'negative': negative,
    })
}
