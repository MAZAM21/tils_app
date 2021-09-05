const functions = require("firebase-functions");
const admin = require("firebase-admin");

// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
admin.initializeApp();

exports.myFunction = functions.firestore
    .document("classes/{docId}")
    .onCreate((snapshot, context) => {
      console.log(snapshot.data().subjectName);
      return admin.messaging().sendToTopic(snapshot.data().subjectName,
          {
            notification:
           {
             title: "New Class Scheduled",
             body: snapshot.data().subjectName.concat(" at ")
                 .concat(snapshot.data().startTime),
             clickAction: "FLUTTER_NOTIFICATION_CLICK",
           },
          });
    });
