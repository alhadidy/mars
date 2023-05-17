
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mars/models/user.dart';
import 'package:mars/services/firestore/invites.dart';
import 'package:mars/services/firestore/users.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/methods.dart';
import 'package:mars/services/providers.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future siginOut(String userId) async {
    try {
      await locator.get<Users>().deleteUserFCMToken(userId);
      await GoogleSignIn().signOut();
      return await _auth.signOut();
    } catch (e) {
      return null;
    }
  }

  Future deleteAccount(String userId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        user.delete();
      }
    } catch (e) {
      return Future.error(e);
    }
  }

  Future siginInAnonymous() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();

      return _userFromFirebaseUser(userCredential.user);
    } catch (e) {
      return null;
    }
  }

  refreshToken(WidgetRef ref, UserModel? user, bool refresh) {
    if (user == null) {
      return;
    }
    Future<IdTokenResult> tokenFuture;
    if (refresh) {
      tokenFuture = _auth.currentUser!.getIdTokenResult(true);
    } else {
      tokenFuture = _auth.currentUser!.getIdTokenResult();
    }
    tokenFuture.then((value) {
      if (value.claims == null) {
        return;
      }
      debugPrint("the role is: ${value.claims!['role']}");

      Roles role = Role.getRolesFromString(value.claims!['role']);

      if (role == user.role) {
        return;
      }
      int accessLevel = value.claims!['accessLevel'];

      ref.read(userProvider.notifier).state = _userFromFirebaseUser(
          _auth.currentUser,
          role: role,
          accessLevel: accessLevel);
    });
  }

  Stream<UserModel?> authChange() {
    return _auth.userChanges().map((User? user) {
      return _userFromFirebaseUser(user);
    });
  }

  UserModel? _userFromFirebaseUser(User? user,
      {role = Roles.user, accessLevel = 0}) {
    debugPrint("the auth has been changed");
    if (user == null) {
      return null;
    }

    if (user.isAnonymous) {
      return UserModel(
        uid: user.uid,
        isAnon: user.isAnonymous,
        name: user.displayName ?? '',
        photoUrl: user.photoURL ?? '',
        phone: user.phoneNumber ?? '',
        email: user.email ?? '',
        accessLevel: accessLevel,
        role: role,
      );
    }

    return UserModel(
      uid: user.uid,
      isAnon: user.isAnonymous,
      name: user.providerData[0].displayName ?? '',
      photoUrl: user.providerData[0].photoURL ?? '',
      phone: user.phoneNumber ?? '',
      email: user.email ?? '',
      accessLevel: accessLevel,
      role: role,
    );
  }

  Future signInWithGoogle(UserModel? user,
      GoogleAuthCredential? signinCredential, String? inviteId) async {
    OAuthCredential? credential;
    if (signinCredential != null) {
      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(signinCredential);

        debugPrint('log anon to old user');
        return (userCredential.user);
      } catch (e) {
        await GoogleSignIn().signOut();

        return null;
      }
    } else {
      try {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        if (googleUser == null) {
          return null;
        }

        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        if (user != null && user.isAnon) {
          UserCredential userCredential =
              await _auth.currentUser!.linkWithCredential(credential);

          if (inviteId != null && userCredential.user!.uid != inviteId) {
            //set user invitedBy
            await locator
                .get<Invites>()
                .setUserInvite(inviteId, userCredential.user!.uid);
            debugPrint('setUserInvite');
          }
          debugPrint('log anon to new user');
          return (userCredential.user);
        } else {
          UserCredential userCredential =
              await _auth.signInWithCredential(credential);

          bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

          if (isNewUser) {
            if (inviteId != null && userCredential.user!.uid != inviteId) {
              //set user invitedBy
              await locator
                  .get<Invites>()
                  .setUserInvite(inviteId, userCredential.user!.uid);
              debugPrint('setUserInvite');
            }
            debugPrint('log signin to new user');
          } else {
            debugPrint('log signin to old user');
          }

          return (userCredential.user);
        }
      } catch (e) {
        await GoogleSignIn().signOut();
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'credential-already-in-use':
              return credential;

            default:
          }
        }

        return null;
      }
    }
  }

  Future signInWithApple(UserModel? user, OAuthCredential? signinCredential,
      String? inviteId) async {
    OAuthCredential? credential;
    if (signinCredential != null) {
      try {
        UserCredential userCredential =
            await _auth.signInWithCredential(signinCredential);
        debugPrint('log anon to old user');
        return (userCredential.user);
      } catch (e) {
        return null;
      }
    } else {
      try {
        final rawNonce = Methods.generateNonce();
        final nonce = Methods.sha256ofString(rawNonce);

        // Request credential for the currently signed in Apple account.
        final appleCredential = await SignInWithApple.getAppleIDCredential(
          scopes: [
            AppleIDAuthorizationScopes.email,
            AppleIDAuthorizationScopes.fullName,
          ],
          nonce: nonce,
        );

        // Create an `OAuthCredential` from the credential returned by Apple.
        credential = OAuthProvider("apple.com").credential(
          idToken: appleCredential.identityToken,
          rawNonce: rawNonce,
        );

        if (user != null && user.isAnon) {
          UserCredential userCredential =
              await _auth.currentUser!.linkWithCredential(credential);
          if (inviteId != null && userCredential.user!.uid != inviteId) {
            //set user invitedBy
            await locator
                .get<Invites>()
                .setUserInvite(inviteId, userCredential.user!.uid);
            debugPrint('setUserInvite');
          }
          debugPrint('log anon to new user');
          return (userCredential.user);
        } else {
          // Sign in the user with Firebase. If the nonce we generated earlier does
          // not match the nonce in `appleCredential.identityToken`, sign in will fail.
          UserCredential userCredential =
              await FirebaseAuth.instance.signInWithCredential(credential);
          bool isNewUser = userCredential.additionalUserInfo!.isNewUser;

          if (isNewUser) {
            if (inviteId != null && userCredential.user!.uid != inviteId) {
              //set user invitedBy
              await locator
                  .get<Invites>()
                  .setUserInvite(inviteId, userCredential.user!.uid);
              debugPrint('setUserInvite');
            }
            debugPrint('log signin to new user');
          } else {
            debugPrint('log signin to old user');
          }
          return (userCredential.user);
        }
      } catch (e) {
        if (e is FirebaseAuthException) {
          switch (e.code) {
            case 'credential-already-in-use':
              return credential;
            default:
          }
        }
        return null;
      }
    }
  }
}
