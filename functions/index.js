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
                 .concat(snapshot.data().notification),
             clickAction: "FLUTTER_NOTIFICATION_CLICK",
           },
          });
    });

exports.studentAbsentNotif = functions.https.onCall((data, context) => {
  console.log(data.studentName);
  const className = data.className;
  const studName = data.studentName;
  const parentToken = data.parentToken;
  const date = data.date;
  return admin.messaging().sendToDevice(parentToken,
      {
        notification:
      {
        title: studName.concat(" is absent from class"),
        body: studName.concat(" missed ").concat(className).concat(" at ")
            .concat(date),
        clickAction: "FLUTTER_NOTIFICATION_CLICK",
      },
      });
});
exports.assignmentMetric = functions.pubsub
 .schedule('0 0 * * *')
 .onRun(async (context) => {
  studentRef = admin
   .firestore()
   .collection('students');
   const thirdYearStuds = await studentRef.where('year', '==', "3").get();
   let studMarkMap = {};
   thirdYearStuds.forEach(doc => {
    const markList = doc.data()['assignment-marks'];
    const marks = Object.values(markList);
    let total = 0;
    marks.forEach(mark => {
      total = total + mark;
    });
    // console.log(doc.data()['name']);
    // console.log(total);
    studMarkMap[doc.data()['name']] = total;
  });
  var date = new Date(admin.firestore.Timestamp.now());
  const entry = new Map();
  return await admin.firestore().collection('metrics').doc('assignment-marks').set({[Date.now()]: studMarkMap}, {merge: true});
});