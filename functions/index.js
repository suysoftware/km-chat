const functions = require("firebase-functions");
const admin = require("firebase-admin");
const express = require('express');
const fetch = require('node-fetch');
const cors = require('cors')({ origin: true });

admin.initializeApp(functions.config().firestore);
const db = admin.firestore();
const app = express();



const validateFirebaseIdToken = async (req, res, next) => {
    functions.logger.log('Check if request is authorized with Firebase ID token');

    if ((!req.headers.authorization || !req.headers.authorization.startsWith('Bearer ')) &&
        !(req.cookies && req.cookies.__session)) {
        functions.logger.error(
            'No Firebase ID token was passed as a Bearer token in the Authorization header.',
            'Make sure you authorize your request by providing the following HTTP header:',
            'Authorization: Bearer <Firebase ID Token>',
            'or by passing a "__session" cookie.'
        );
        res.status(403).send('Unauthorized');
        return;
    }

    let idToken;
    if (req.headers.authorization && req.headers.authorization.startsWith('Bearer ')) {
        functions.logger.log('Found "Authorization" header');
        // Read the ID Token from the Authorization header.
        idToken = req.headers.authorization.split('Bearer ')[1];
    } else if (req.cookies) {
        functions.logger.log('Found "__session" cookie');
        // Read the ID Token from cookie.
        idToken = req.cookies.__session;
    } else {
        // No cookie
        res.status(403).send('Unauthorized');
        return;
    }

    try {
        const decodedIdToken = await admin.auth().verifyIdToken(idToken);
        functions.logger.log('ID Token correctly decoded', decodedIdToken);
        req.user = decodedIdToken;
        next();
        return;
    } catch (error) {
        functions.logger.error('Error while verifying Firebase ID token:', error);
        res.status(403).send('Unauthorized');
        return;
    }
};


async function levelReturner(experience) {

    switch (true) {
        case experience < 1000:
            return 1;
        case experience >= 1000 && experience < 2000:
            return 2;
        case experience >= 2000 && experience < 3000:
            return 3;
        case experience >= 3000 && experience < 4000:
            return 4;
        case experience >= 4000 && experience < 6000:
            return 5;
        case experience >= 6000 && experience < 8000:
            return 6;
        case experience >= 8000 && experience < 10000:
            return 7;
        case experience >= 10000 && experience < 12000:
            return 8;
        case experience >= 12000 && experience < 14000:
            return 9;
        case experience >= 14000 && experience < 16000:
            return 10;
        case experience >= 16000 && experience < 18000:
            return 11;
        case experience >= 18000 && experience < 22000:
            return 12;
        case experience >= 22000 && experience < 26000:
            return 13;
        case experience >= 26000 && experience < 28000:
            return 14;
        case experience >= 28000 && experience < 30000:
            return 15;
        case experience >= 30000 && experience < 34000:
            return 16;
        case experience >= 34000 && experience < 40000:
            return 17;
        case experience >= 40000 && experience < 44000:
            return 18;
        case experience >= 44000 && experience < 50000:
            return 19;
        case experience >= 50000 && experience < 60000:
            return 20;
        case experience >= 60000 && experience < 70000:
            return 21;
        case experience >= 70000 && experience < 80000:
            return 22;
        case experience >= 80000 && experience < 100000:
            return 23;
        case experience > 100000:
            return 24;

    }


};



async function publicMessageUserDocsReturner(systemChatSetting, userCountry, userCity, userDistrict, userPostal) {
    const usersRef = db.collection('users');


    switch (systemChatSetting) {
        case 'world':
            var usersGetting = await usersRef.get();
            usersDocs = usersGetting.docs;
            return usersDocs;



        case 'country':
            var usersGetting = await usersRef.where('user_coordinates.iso_country_code', '==', userCountry).where('user_notification_settings.public_message', '==', true).get();
            var usersDocs = usersGetting.docs;
            return usersDocs;


        case 'city':
            var usersGetting = await usersRef.where('user_coordinates.administrative_area', '==', userCity).where('user_notification_settings.public_message', '==', true).get();
            var usersDocs = usersGetting.docs;
            return usersDocs;

        case 'district':
            var usersGetting = await usersRef.where('user_coordinates.locality', '==', userDistrict).where('user_notification_settings.public_message', '==', true).get();
            var usersDocs = usersGetting.docs;
            return usersDocs;


        case 'postal':
            var usersGetting = await usersRef.where('user_coordinates.postal_code', '==', userPostal).where('user_notification_settings.public_message', '==', true).get();
            var usersDocs = usersGetting.docs;
            return usersDocs;


        default:
            var usersGetting = await usersRef.where('user_coordinates.postal_code', '==', userPostal).where('user_notification_settings.public_message', '==', true).get();
            var usersDocs = usersGetting.docs;
            return usersDocs;



    }
};



async function publicMessageSender(systemChatSetting, userCountry, userCity, userDistrict, userPostal) {
    var notificationTargetUserList = [];
    console.log('buraya girdi 3');
    //to all 

    //const usersGetting = await usersRef.get();

    //const usersDocs = usersGetting.docs;

    var userDocs = await publicMessageUserDocsReturner(systemChatSetting, userCountry, userCity, userDistrict, userPostal);


    userDocs.forEach(element => {

        var userData = element.data();

        if (userData.user_message_token != "") {
            notificationTargetUserList.push(userData.user_message_token);
        }





    });
    return notificationTargetUserList;

};



app.use(cors);
app.use(validateFirebaseIdToken);

app.put("/test", async (req, res) => {

    res.status(200).send('OK');



});
app.put("/AvatarChange", async (req, res) => {

    const userNo = req.body.user_no;
    const userSecretPassword = req.body.user_secret_password;
    const chosenAvatar = req.body.chosen_avatar;
    const userRef = db.collection('users').doc(userNo);
    const systemSettingsRef = db.collection('system').doc('system_settings');


    console.log(userNo);
    console.log(userSecretPassword);
    console.log(chosenAvatar);




    try {
        var systemSettingsGet = await systemSettingsRef.get();
        var systemSettingsData = systemSettingsGet.data();
        var avatarLink = systemSettingsData.avatar_map[chosenAvatar];

        var userGet = await userRef.get();
        var userData = userGet.data();
        var userSecretPasswordGet = userData.user_secret_password;



        if (userSecretPassword == userSecretPasswordGet) {


            console.log(avatarLink);

            await userRef.update({

                'user_avatar': avatarLink
            });

            res.status(200).send('OK');
        }
        else {
            res.status(404).send('NO');

        }




    } catch (error) {
        res.status(404).send('NO');

    }



});

app.put("/AccountRevive", async (req, res) => {
    const userNo = req.body.user_no;
    const userSecretPassword = req.body.user_secret_password;

    const usersRef = db.collection('users');

    const reviverUserRef = db.collection('users').doc(userNo);
    const batch = db.batch();
    const usersGetting = await usersRef.get();

    const usersDocs = usersGetting.docs;

    var reviveTargetUserList = [];

    usersDocs.forEach(element => {

        var userData = element.data();

        if (userData.user_secret_password == userSecretPassword && userData.user_has_banned != true) {

            console.log('aa bundan var');
            reviveTargetUserList.push(userData);


        }


    });

    console.log(reviveTargetUserList[0].user_uid);

    if (reviveTargetUserList[0].user_uid != null && reviveTargetUserList.length == 1) {

        const corpseUserRef = db.collection('users').doc(reviveTargetUserList[0].user_uid);

        batch.update(reviverUserRef, {
            'user_avatar': reviveTargetUserList[0].user_avatar,
            'user_experience_points': reviveTargetUserList[0].user_experience_points,
            'user_level': reviveTargetUserList[0].user_level,
            'user_name': reviveTargetUserList[0].user_name,
            'user_title': reviveTargetUserList[0].user_title,

        });

        batch.update(corpseUserRef, {
            'user_has_banned': true
        });

        try {
            await batch.commit();
            res.status(200).send('OK');

        } catch (error) {

            res.status(404).send('NO');

        }





    }
    else {

        res.status(404).send('NO');
    }








});

app.put("/SpamRemove", async (req, res) => {

    const userNo = req.body.user_no;
    const userSecretPassword = req.body.user_secret_password;
    const targetUid = req.body.target_uid;


    const userRef = db.collection('users').doc(userNo);

    const userBlockedMapsRoute = "user_blocked_map." + targetUid.toString();


    try {

        db.runTransaction(async (t) => {

            var userGet = await t.get(userRef);

            var userData = userGet.data();

            var mySecretPassword = userData.user_secret_password;
            var userBlockedMap = userData.user_blocked_map;





            delete userBlockedMap[targetUid.toString()];




            if (userSecretPassword == mySecretPassword) {
                console.log('buraya giriyor');


                t.update(userRef, {
                    'user_blocked_map': userBlockedMap
                });

                res.status(200).send('OK');

            }
        });


    } catch (error) {
        res.status(404).send('NO');
        console.log('Transaction failure:', error);
    }



});
app.put("/SpamTarget", async (req, res) => {

    const userNo = req.body.user_no;
    const userSecretPassword = req.body.user_secret_password;
    const targetUid = req.body.target_uid;
    const targetName = req.body.target_name;
    const targetMessage = req.body.target_message;

    const userRef = db.collection('users').doc(userNo);

    const userBlockedMapsRoute = "user_blocked_map." + targetUid.toString();
    const currentDate = new Date();

    try {

        db.runTransaction(async (t) => {

            var userGet = await t.get(userRef);

            var userData = userGet.data();

            var mySecretPassword = userData.user_secret_password;

            if (userSecretPassword == mySecretPassword) {
                console.log('buraya giriyor');

                var newBlockedMap = {
                    "user_name": targetName,
                    "user_uid": targetUid,
                    "blocked_date": currentDate,
                    "target_message": targetMessage
                };


                t.update(userRef, {
                    [userBlockedMapsRoute]: newBlockedMap
                });
            }
        });
        res.status(200).send('OK');
    } catch (error) {
        res.status(404).send('NO');
        console.log('Transaction failure:', error);
    }
});
app.put("/NotificationSettingUpdate", async (req, res) => {

    const userNo = req.body.user_no;
    const userSecretPassword = req.body.user_secret_password;
    const targetNotification = req.body.target_notification;
    const changeIsTrue = req.body.change_is_true;

    console.log(userNo);
    console.log(userSecretPassword);
    console.log(targetNotification);
    console.log(changeIsTrue);


    const userRef = db.collection('users').doc(userNo);
    const notificationRoute = "user_notification_settings." + targetNotification.toString();



    try {

        db.runTransaction(async (t) => {

            var userGet = await t.get(userRef);

            var userData = userGet.data();

            var mySecretPassword = userData.user_secret_password;

            if (userSecretPassword == mySecretPassword) {

                t.update(userRef, {
                    [notificationRoute]: changeIsTrue == "true" ? true : false
                });
            }
        });
        res.status(200).send('OK');
    } catch (error) {
        res.status(404).send('NO');
        console.log('Transaction failure:', error);
    }
});


app.put("/ActivityRequest", async (req, res) => {

    const userNo = req.body.user_no;
    const userSecretPassword = req.body.user_secret_password;
    const activityType = req.body.activity_type;



    const currentDate = new Date();

    const year = currentDate.getFullYear().toString();
    const month = (currentDate.getMonth() + 1).toString();
    const day = currentDate.getDate().toString();
    const hour = currentDate.getHours.toString();


    const activityDoc = day + '-' + month + '-' + year + ' (Hour:' + hour + ')';

    const userRef = db.collection('users').doc(userNo);
    const activityRef = db.collection('activity').doc(userNo).collection('activity').doc(activityDoc)
    const movementRef = db.collection('activity').doc(userNo).collection('activity').doc(activityDoc).collection('movements').doc();


    try {

        db.runTransaction(async (t) => {

            var userGet = await t.get(userRef);

            var userData = userGet.data();

            if (userSecretPassword == userData.user_secret_password) {
                if (activityType == "online") {

                    if (userData.user_has_banned != true) {

                        t.update(userRef, {
                            "user_is_online": true


                        });

                        t.set(activityRef, {
                            'user_no': userData.user_uid,
                            'date': currentDate,
                            'user_coordinates': {
                                'administrative_area': userData.user_coordinates.administrative_area,
                                'iso_country_code': userData.user_coordinates.iso_country_code,
                                'latitude': userData.user_coordinates.latitude,
                                'longitude': userData.user_coordinates.longitude,
                                'locality': userData.user_coordinates.locality,
                                'postal_code': userData.user_coordinates.postal_code,
                                'sub_locality': userData.user_coordinates.sub_locality
                            }

                        });

                        t.set(movementRef, {
                            'user_no': userData.user_uid,
                            'date': currentDate,
                            'user_coordinates': {
                                'administrative_area': userData.user_coordinates.administrative_area,
                                'iso_country_code': userData.user_coordinates.iso_country_code,
                                'latitude': userData.user_coordinates.latitude,
                                'longitude': userData.user_coordinates.longitude,
                                'locality': userData.user_coordinates.locality,
                                'postal_code': userData.user_coordinates.postal_code,
                                'sub_locality': userData.user_coordinates.sub_locality
                            },
                            'activity_type': activityType

                        });


                    }




                }

                else {
                    t.update(userRef, {
                        "user_is_online": false


                    });
                    t.set(movementRef, {
                        'user_no': userData.user_uid,
                        'date': currentDate,
                        'user_coordinates': {
                            'administrative_area': userData.user_coordinates.administrative_area,
                            'iso_country_code': userData.user_coordinates.iso_country_code,
                            'latitude': userData.user_coordinates.latitude,
                            'longitude': userData.user_coordinates.longitude,
                            'locality': userData.user_coordinates.locality,
                            'postal_code': userData.user_coordinates.postal_code,
                            'sub_locality': userData.user_coordinates.sub_locality
                        },
                        'activity_type': activityType

                    });


                }

            }











        });



        res.status(200).send('OK');

    } catch (error) {

        res.status(404).send('NO');

    }














});

app.put("/JoinRoomMessage", async (req, res) => {


    console.log('calisti!');

    const userNo = req.body.user_no;
    const userName = req.body.user_name;
    const systemChatSetting = req.body.system_chat_setting;
    const userCountry = req.body.user_country;
    const userCity = req.body.user_city;
    const userDistrict = req.body.user_district;
    const userPostal = req.body.user_postal;


    const currentDate = new Date();
    message = {

        'user_message': userName + ' joined room',
        'user_message_time': currentDate,
        'user_title': 'system',
        'user_name': 'system',
        'user_level': 1,
        'user_blocked_list': [],
        'user_uid': userNo,
        'user_avatar': 'admin_avatar',
        "message_is_private": false,
        "private_message_target": ""

    }
    const generalChatRef = db.collection('chat');

    try {
        switch (systemChatSetting) {
            case 'world':

                await generalChatRef.doc('WORLD')
                    .collection('world_chat').doc().set(message);
                return res.status(200).send('OK');

            case 'country':
                await generalChatRef.doc(userCountry)
                    .collection('country_chat').doc().set(message);
                return res.status(200).send('OK');

            case 'city':
                await generalChatRef.doc(userCountry)
                    .collection('cities')
                    .doc(userCity)
                    .collection('city_chat').doc().set(message);
                return res.status(200).send('OK');

            case 'district':
                await generalChatRef.doc(userCountry)
                    .collection('cities')
                    .doc(userCity)
                    .collection('districts')
                    .doc(userDistrict)
                    .collection('district_chat').doc().set(message);
                return res.status(200).send('OK');

            case 'postal':
                await generalChatRef.doc(userCountry)
                    .collection('cities')
                    .doc(userCity)
                    .collection('districts')
                    .doc(userDistrict)
                    .collection('postals')
                    .doc(userPostal)
                    .collection('postal_chat').doc().set(message);
                return res.status(200).send('OK');

            default:
                await generalChatRef.doc(userCountry)
                    .collection('cities')
                    .doc(userCity)
                    .collection('districts')
                    .doc(userDistrict)
                    .collection('postals')
                    .doc(userPostal)
                    .collection('postal_chat').doc().set(message);
                return res.status(200).send('OK');


        }

    } catch (error) {

        res.status(404).send('NO');

    }






});

app.put("/TokenUpdateRequest", async (req, res) => {
    const userNo = req.body.user_no;
    const userMessageToken = req.body.user_message_token;


    const userRef = db.collection('users').doc(userNo);

    console.log(userNo);
    console.log(userMessageToken);

    console.log('bb1');

    try {
        console.log('bb2');
        await userRef.update({
            'user_message_token': userMessageToken

        });
        console.log('bb3');

        res.status(200).send('OK');
    } catch (error) {
        console.log('bb4');
        res.status(404).send('NO');
        console.log('Transaction failure:', error);
    }






});


app.put("/NotificationSender", async (req, res) => {

    const userNo = req.body.user_no;
    const userName = req.body.user_name;
    const userCountry = req.body.user_country;
    const userCity = req.body.user_city;
    const userDistrict = req.body.user_district;
    const userPostal = req.body.user_postal;
    const privateMessageTarget = req.body.private_message_target;
    const privateMessageText = req.body.private_message_text;
    const systemChatSetting = req.body.system_chat_setting;








    if (privateMessageTarget != "notarget") {

        //private message

        const userRef = db.collection('users').doc(privateMessageTarget);

        var userGet = await userRef.get();
        var userData = userGet.data();

        var userNotificationSettings = userData.user_notification_settings;
        var userMessageToken = userData.user_message_token;




        console.log('buraya girdi 0');
        if (userNotificationSettings.private_message == true) {

            console.log(userMessageToken);

            console.log('buraya girdi 1');
            await admin.messaging().send({
                token: userMessageToken,


                notification: {


                    title: '1 KM',
                    body: privateMessageText,

                },
                data: {
                    notiCategory: 'chat_message',
                    notiCategoryDetail: 'private_message'

                }
            });


        }
        else {
            console.log('buraya girdi 2');
        }
    }
    else {
        console.log('buraya girdi 3');
        //to all 
        var userTokenList = await publicMessageSender(systemChatSetting, userCountry, userCity, userDistrict, userPostal);
        await admin.messaging().sendMulticast({
            tokens: userTokenList,


            notification: {
                title: '1 KM',
                body: 'Someone nearby!'


            },
            data: {

                notiCategory: 'chat_message',
                notiCategoryDetail: 'public_message'

            }

        });


    }



    console.log('buraya girdi 4');



});

exports.experienceGiver = functions.firestore.document('activity/{userUid}/activity/{date}').onCreate(async (snap, context) => {

    const userNo = context.params.userUid;

    const userRef = db.collection('users').doc(userNo);

    try {

        db.runTransaction(async (t) => {

            var userGet = await t.get(userRef);

            var userData = userGet.data();

            var newExperience = userData.user_experience_points + 500;

            var levelReturnData = await levelReturner(newExperience);


            t.update(userRef, {
                "user_level": levelReturnData,
                "user_experience_points": newExperience

            });

        });


    } catch (error) {
        console.log('Transaction failure:', error);
    }





});

exports.activityController = functions.firestore.document('activity/{userUid}/activity/{date}/movements/{movementNo}').onCreate(async (snap, context) => {

    const data = snap.data();

    const userNo = context.params.userUid;
    const activityType = data.activity_type;



    const userRef = db.collection('users').doc(userNo);



    if (activityType == 'online') {

        await userRef.update({
            "user_is_online": true


        });
    }
    else {
        await userRef.update({
            "user_is_online": false


        });

    }
});


exports.userNameListAdder = functions.firestore.document('users/{userNo}').onUpdate(async (snap, context) => {
    const snapBeforeData = snap.before.data();
    const snapAfterData = snap.after.data();


    const userNameBefore = snapBeforeData.user_name;
    const userNameAfter = snapAfterData.user_name;

    if (userNameBefore != userNameAfter) {

        const allUserNamesRef = db.collection('system').doc('system_settings');


        try {

            db.runTransaction(async (t) => {

                var allUserName = await t.get(allUserNamesRef);

                var allUserNameData = allUserName.data();

                var allUserNameList = allUserNameData.all_user_names;


                await allUserNameList.push(userNameAfter);




                t.update(allUserNamesRef, {
                    "all_user_names": allUserNameList


                });


            });





        } catch (error) {
            console.log('Transaction failure:', error);
        }



    }



});


exports.createNewUser = functions.auth.user().onCreate(async (user) => {
    const newUserUid = user.uid;
    const usersRef = db.collection('users').doc(newUserUid);

    const currentDate = new Date();

    await usersRef.set({
        "user_coordinates": {
            "latitude": 11.2,
            "longitude": 12.2,
            "iso_country_code": "",
            "administrative_area": "",
            "locality": "",
            "sub_locality": "",
            "postal_code": "",

        },
        "user_name": "",
        "user_uid": newUserUid,
        "user_secret_password": "",
        "user_experience_points": 1,
        "user_title": "pleb",
        "user_level": 1,
        "user_blocked_map": {},
        "user_has_banned": false,
        "user_avatar": "https://firebasestorage.googleapis.com/v0/b/kmproject-ef6c1.appspot.com/o/avatars%2Fdefault_avatar.png?alt=media&token=b89fdeea-ca20-4239-a9a9-0b3818d3987a",
        "user_is_online": true,
        "user_last_activity_date": currentDate,
        "user_message_token": "",
        "user_notification_settings": { "private_message": true, "public_message": true }
    });




});
// // Create and Deploy Your First Cloud Functions
// // https://firebase.google.com/docs/functions/write-firebase-functions
//
// exports.helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });

exports.appRequest = functions.https.onRequest(app);
