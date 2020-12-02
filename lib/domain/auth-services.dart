import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthServices {
  static FirebaseAuth _auth = FirebaseAuth.instance;


  static GoogleSignIn googleSignIn = GoogleSignIn(
    scopes: ['email'],
  );

  static FacebookLogin facebookLogin = FacebookLogin();

  // create Account
  static Future<SignInSignUpResult> createUser({String email, String pass}) async {
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: email, password: pass);
      return SignInSignUpResult(user: result.user);
    } catch (e) {
      return SignInSignUpResult(message: e.toString());
    }
  }

  // sign in with email/password
  static Future<SignInSignUpResult> signInWithEmail({String email, String pass}) async {
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: email, password: pass);
      return SignInSignUpResult(user: result.user);
    } catch (e) {
      return SignInSignUpResult(message: e.toString());
    }
  }

  // sign out
  static void signOut() {
    _auth.signOut();
  }

  // sign in with google
  static Future<SignInSignUpResult> signInWithGoogle() async {
    try {
      final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.getCredential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken);

      final AuthResult result = await _auth.signInWithCredential(credential);
      return SignInSignUpResult(user: result.user);
    } catch (e) {
      return SignInSignUpResult(message: e.toString());
    }
  }

  // sign out google
  static Future<void> signOutGoogle() async {
    await googleSignIn.signOut();
  }

  // sign in with facebook
  static Future<SignInSignUpResult> signInWithFacebook() async {
    try {
      facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
      final FacebookLoginResult result = await facebookLogin.logIn(['email']);
      final AuthCredential credential =
      FacebookAuthProvider.getCredential(accessToken: result.accessToken.token);

      final AuthResult authResult = await _auth.signInWithCredential(credential);

      return SignInSignUpResult(user: authResult.user);
    } catch (e) {
      return SignInSignUpResult(message: e.toString());
    }
  }

  // sign in with facebook
  static Future<void> signOutWithFacebook() async {
    await facebookLogin.logOut();
  }
}

class SignInSignUpResult {
  final FirebaseUser user;
  final String message;

  SignInSignUpResult({this.user, this.message});
}
