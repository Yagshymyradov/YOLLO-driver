import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'data/api_client.dart';
import 'data/auth_controller.dart';
import 'data/json_http_client.dart';
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

    /*lateinit*/
    JsonHttpClient? refreshTokenHttpClient;
    /*lateinit*/
    ApiClient? refreshTokenApiClient;

    httpClient.dio.interceptors.addAll([
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final authToken = ref.read(authControllerProvider);
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
          log(error.message.toString());
          if (error.response?.statusCode == 401) {
            final authController = ref.read(authControllerProvider.notifier);
            if (authController.isAuthorized) {
              final refreshToken = authController.refreshToken!;

              refreshTokenHttpClient ??= JsonHttpClient();
              refreshTokenApiClient ??= ApiClient(refreshTokenHttpClient!);

              try {
                final refreshedToken = await refreshTokenApiClient!.refreshToken(refreshToken);
                await authController.updateAccessToken(refreshedToken.access);

                error.requestOptions.headers[HttpHeaders.authorizationHeader] =
                    'Bearer ${refreshedToken.access}';

                final response =
                    await refreshTokenHttpClient!.dio.fetch<dynamic>(error.requestOptions);
                return handler.resolve(response);
              } catch (e) {
                //ignored
              }
            }

            ref.listen(
              apiBaseUrlProvider,
                  (previous, next) {
                final apiBaseUrl = next;
                refreshTokenHttpClient!.dio.options.baseUrl = apiBaseUrl;
              },
              fireImmediately: true,
            );
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
