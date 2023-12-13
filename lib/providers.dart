import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/api_client.dart';
import 'data/auth_controller.dart';
import 'data/json_http_client.dart';
import 'data/response.dart';
import 'data/service/preferences.dart';
import 'data/settings_controller.dart';

/// It is an error to use this provider without overriding it's value.
final appPrefsServiceProvider = Provider<AppPrefsService>(
  (ref) => throw UnimplementedError("Can't use this provider without overriding it's value."),
);

final settingsControllerProvider = StateNotifierProvider<SettingsController, AppSettings>(
  (ref) {
    final appPrefs = ref.watch(appPrefsServiceProvider);
    final initialSettings = SettingsController.initialize(appPrefs);
    return SettingsController(appPrefs, initialSettings);
  },
  dependencies: [appPrefsServiceProvider],
);

final authControllerProvider = StateNotifierProvider<AuthController, UserState?>(
  (ref) {
    final appPrefs = ref.watch(appPrefsServiceProvider);
    final initialState = AuthController.initialState(appPrefs);
    return AuthController(appPrefs, initialState);
  },
  dependencies: [appPrefsServiceProvider],
);

final apiBaseUrlProvider = Provider((ref) => 'https://yollo.com.tm/yolloadmin/api/');

final httpClientProvider = Provider(
  (ref) {
    final httpClient = JsonHttpClient();
    Dio? refreshTokenRequest;

    httpClient.dio.interceptors.addAll([
      //TODO: ADD logger interceptor

      InterceptorsWrapper(
        onRequest: (options, handler) {
          final authToken = ref.read(authControllerProvider);
          log('options---->${options.path}');
          log('optionsBody---->${options.data}');
          try {
            if (authToken != null) {
              options.headers[HttpHeaders.authorizationHeader] = 'Bearer ${authToken.authToken}';
            }
          } catch (e) {
            //ignored
          }
          handler.next(options);
        },
        onError: (error, handler) async {
          final authToken = ref.read(authControllerProvider);
          log('Here ---> ${error.response}');
          if (error.response?.statusCode == 401) {

            final newToken = await ApiClient(JsonHttpClient())
                .refreshToken(authToken?.refreshToken ?? '');
            log('newToken ------>>>>>${newToken.refresh}');

            error.requestOptions.headers[HttpHeaders.authorizationHeader] =
                'Bearer ${newToken.refresh}';
            //
            // return handler.resolve(await httpClient.dio.fetch<String>(error.requestOptions));
          }
          return handler.next(error);
        },
      ),
    ]);

    ref.listen(
      apiBaseUrlProvider,
      (previous, next) {
        final apiBaseUrl = next;
        httpClient.dio.options.baseUrl = apiBaseUrl;
      },
      fireImmediately: true,
    );

    return httpClient;
  },
  dependencies: [
    apiBaseUrlProvider,
    authControllerProvider,
  ],
);

final apiClientProvider = Provider(
  (ref) => ApiClient(ref.watch(httpClientProvider)),
  dependencies: [httpClientProvider],
);

final regionsHiProvider = FutureProvider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.getRegionsHi();
});

final regionsCityProvider = FutureProvider.family((ref, String hiRegion) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.getRegionsCity(hiRegion);
});
