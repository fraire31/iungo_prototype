import * as functions from "firebase-functions";
import * as admin from "firebase-admin";

admin.initializeApp();
const auth = admin.auth();

exports.setRole = functions.https.onCall( async (data, context) => {
    let uid:string = data.uid;
    let roles:Array<string> = data.roles;
    let loggedInAs:string = data.loggedInAs;


    try{
        if(roles == null) {
            await admin.firestore().collection("usuarios").where("uid", "==", uid).get()
            .then(docs => {
                docs.forEach((doc) => {
                    var data = doc.data();
                    if(data != null){
                         roles = data['rol'];
                         loggedInAs = data['loggedInAs'];
                    }
                })
            });
        }



    }catch(e){
        console.log('---index.ts error---');
        console.log(e);
    }



    return auth.setCustomUserClaims(uid, {roles: roles, loggedInAs: loggedInAs});
})

// // Start writing Firebase Functions
// // https://firebase.google.com/docs/functions/typescript
//
// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
