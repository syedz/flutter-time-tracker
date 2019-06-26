/**
 * This class was replaced with the Provider package.
 * Leaving this here for reference on how to create your own
 * provider if needed.
 */

import 'package:flutter/material.dart';

import 'auth.dart';

class AuthProvider extends InheritedWidget {
  AuthProvider({@required this.auth, @required this.child});

  final AuthBase auth;
  final Widget child;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return false;
  }

  // final auth = AuthProvider.of(context); Will do this in our code
  static AuthBase of(BuildContext context) {
    AuthProvider provider = context.inheritFromWidgetOfExactType(AuthProvider);
    return provider.auth;
  }
}
