import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mars/drift/drift.dart';
import 'package:mars/models/link.dart';
import 'package:mars/models/prefs.dart';
import 'package:mars/models/sSettings.dart';
import 'package:mars/models/user.dart';
import 'package:mars/models/user_data.dart';
import 'package:mars/services/auth_service.dart';
import 'package:mars/services/firestore/settings.dart';
import 'package:mars/services/firestore/users.dart';
import 'package:mars/services/locator.dart';
import 'package:mars/services/pref_manager.dart';

//auth change
final userStreamProvider =
    StreamProvider<UserModel?>((ref) => AuthService().authChange());

final userProvider = StateProvider<UserModel?>((ref) {
  AsyncValue<UserModel?> stream = ref.watch(userStreamProvider);

  return stream.maybeWhen(
    data: (userModel) {
      if (userModel != null) {
        locator.get<Users>().updateUserLastSignInAndToken(userModel);
      }
      return userModel;
    },
    orElse: (() {
      return null;
    }),
  );
}); // auth change

// user Data
final userDataStreamProvider = StreamProvider<UserData>((ref) {
  UserModel? user = ref.watch(userProvider);
  return locator.get<Users>().watchUserData(user);
});

final userDataProvider = StateProvider<UserData>((ref) {
  AsyncValue<UserData> stream = ref.watch(userDataStreamProvider);

  return stream.maybeWhen(
    data: (value) {
      return value;
    },
    orElse: (() {
      return UserData([], 0);
    }),
  );
}); // user data

final prefProvider =
    StateNotifierProvider.autoDispose<PreferencesManager, Prefs>(
        (ref) => PreferencesManager());

final linkProvider = StateNotifierProvider<LinkManager, Link>((ref) {
  return LinkManager();
});

final shopSettingsStreamProvider = StreamProvider<SSetting>(
    (ref) => locator.get<SSettings>().getShopSettings());

final shopSettingsProvider = StateProvider<SSetting?>((ref) {
  AsyncValue<SSetting> stream = ref.watch(shopSettingsStreamProvider);
  return stream.whenOrNull(data: (value) {
    print(value);
    return value;
  });
});

// roles data
final rolesStreamProvider = StreamProvider<Role>((ref) {
  UserModel? user = ref.watch(userProvider);
  return locator.get<Users>().getRole(user);
});

final rolesProvider = StateProvider<Role>((ref) {
  AsyncValue<Role> stream = ref.watch(rolesStreamProvider);

  return stream.when(
    data: (value) {
      return value;
    },
    loading: () {
      return Role(role: Roles.user, refreshTime: 0, accessLevel: 0);
    },
    error: (error, stackTrace) {
      debugPrint("roles error $error");
      return Role(role: Roles.user, refreshTime: 0, accessLevel: 0);
    },
  );
}); // roles

final dbProvider = StateProvider<AppDatabase>((ref) {
  final db = AppDatabase();
  return db;
});
