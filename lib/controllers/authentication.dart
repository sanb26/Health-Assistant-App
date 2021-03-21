import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_assistant/pages/sign_in.dart';

// a simple dialog to be visible everytime some error occurs
showErrDialog(BuildContext context, String err) {
  // to hide the keyboard, if it is still p
  FocusScope.of(context).requestFocus(new FocusNode());
  return showDialog(
    context: context,
    child: AlertDialog(
      title: Text("Error"),
      content: Text(err),
      actions: <Widget>[
        OutlineButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Ok"),
        ),
      ],
    ),
  );
}

FirebaseAuth auth = FirebaseAuth.instance;
final gooleSignIn = GoogleSignIn();

Future<bool> googleSignIn() async {
  GoogleSignInAccount googleSignInAccount = await gooleSignIn.signIn();

  if (googleSignInAccount != null) {
    GoogleSignInAuthentication googleAuth =
        await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);

    await auth.signInWithCredential(credential);

    User user = auth.currentUser;
    //print("Hey Google user");
    //print(user.uid);

    return Future.value(true);
  } else {
    return Future.value(null);
  }
}

// instead of returning true or false
// returning user to directly access UserID
Future<User> signin(String email, String password, BuildContext context) async {
  try {
    final result =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    User user = result.user;
    // return Future.value(true);
    //print("User signed in with email and password");
    return Future.value(user);
  } catch (e) {
    // simply passing error code as a message
    print(e.code);
    switch (e.code) {
      case 'ERROR_INVALID_EMAIL':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_WRONG_PASSWORD':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_USER_NOT_FOUND':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_USER_DISABLED':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_TOO_MANY_REQUESTS':
        showErrDialog(context, e.code);
        break;
      case 'ERROR_OPERATION_NOT_ALLOWED':
        showErrDialog(context, e.code);
        break;
    }
    // since we are not actually continuing after displaying errors
    // the false value will not be returned
    // hence we don't have to check the value returned in from the signin function
    // whenever we call it anywhere
    return Future.value(null);
  }
}

Future<bool> signOutUser() async {
  User user = auth.currentUser;
  print(user.providerData[0].providerId);
  //print(user.providerData[1].providerId);

  //if the user is signed in using google
  if (user.providerData[0].providerId == 'google.com') {
    await gooleSignIn.disconnect();
  }
  await auth.signOut();
  SignIn();
  return Future.value(true);
}
