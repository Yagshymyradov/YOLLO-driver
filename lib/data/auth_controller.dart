// ignore_for_file: constant_identifier_names
// ignore: depend_on_referenced_packages
import 'dart:developer';

import 'package:state_notifier/state_notifier.dart';
import 'package:yollo_driver/data/response.dart';

import '../utils/enums.dart';
import 'service/preferences.dart';

class UserState {
  final String username;
  final String authToken;
  final String refreshToken;
  final String driverType;

  UserState({
    required this.username,
    required this.authToken,
    required this.refreshToken,
    required this.driverType,
  });

  UserState copyWith({
    String? username,
    String? authToken,
    String? refreshToken,
    String? driverType,
  }) {
    return UserState(
      username: username ?? this.username,
      authToken: authToken ?? this.authToken,
      refreshToken: refreshToken ?? this.refreshToken,
      driverType: driverType ?? this.driverType,
    );
  }
}

class AuthController extends StateNotifier<UserState?> {
  static const _UserName = 'user_name';
  static const _AuthToken = 'auth_token';
  static const _RefreshToken = 'refresh_token';
  static const _DriverType = 'driver_type';

  final AppPrefsService _service;

  String? get authToken => state?.authToken;

  String? get refreshToken => state?.refreshToken;

  AuthController(this._service, super.state);

  static UserState? initialState(AppPrefsService service) {
    String username = '';
    String? authToken;
    String? refreshToken;
    String driverType = '';

    try {
      authToken = service.getString(_AuthToken);
      refreshToken = service.getString(_RefreshToken);
      username = service.getString(_UserName) ?? '';
      driverType = service.getString(_DriverType) ?? '';
    } catch (e) {
      //ignored
    }

    if (authToken != null && refreshToken != null) {
      return UserState(
        username: username,
        driverType: driverType,
        authToken: authToken,
        refreshToken: refreshToken,
      );
    }

    return null;
  }

  Future<void> onSignedIn(LoginResponse response) async {
    log('authToken ---->>> ${response.accessToken}');
    log('refreshToken ---->>> ${response.refreshToken}');
    final newState = UserState(
      username: response.user.username,
      driverType: response.user.type,
      authToken: response.accessToken,
      refreshToken: response.refreshToken,
    );
    state = newState;

    try {
      await _service.setString(_AuthToken, newState.authToken);
      await _service.setString(_RefreshToken, newState.refreshToken);
      await _service.setString(_UserName, newState.username);
      await _service.setString(_DriverType, newState.driverType);
    } catch (e) {
      //ignored
    }
  }

  Future<void> signOut() async {
    state = null;

    try {
      await _service.remove(_AuthToken);
      await _service.remove(_RefreshToken);
      await _service.remove(_UserName);
      await _service.remove(_DriverType);
    } catch (e) {
      //ignored
    }
  }
}
