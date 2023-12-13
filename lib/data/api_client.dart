import 'dart:io';

import 'json_http_client.dart';
import 'response.dart';

extension Endpoints on Never {
  static const String baseUrl = 'https://yollo.com.tm';

  static const String login = 'user/apilogin/';

  static const String logOut = 'user/apilogout/';

  static const String refreshToken = 'token/refresh/';

  static String ordersBox({int page = 1, int size = 10}) => 'box/boxes?page=$page&size=$size';

  static const String createOrdersBox = 'box/boxes';

  static String changeOrderStatus(int id) => 'box/boxreject/$id';

  static String ordersBoxById(int id) => 'box/boxes/$id';

  static const String regionsHi = 'box/regionshi';

  static String regionsCity(String hiRegion) => 'box/regionscity?region_hi=$hiRegion';
}

class ApiClient {
  final JsonHttpClient _httpClient;

  ApiClient(this._httpClient);

  Future<LoginResponse> signIn({
    required String username,
    required String password,
  }) {
    final postData = <String, dynamic>{
      'username': username,
      'password': password,
    };
    return _httpClient.post(
      Endpoints.login,
      body: postData,
      mapper: (dynamic data) => LoginResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<LoginResponse> logOut(String? accessToken) {
    return _httpClient.post(
      Endpoints.logOut,
      mapper: (dynamic data) => LoginResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<OrderData> getOrdersBox({int page = 1, int size = 10}) {
    return _httpClient.get(
      Endpoints.ordersBox(
        page: page,
        size: size,
      ),
      mapper: (dynamic data) => OrderData.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<OrderDetails> getOrdersBoxById(int id) {
    return _httpClient.get(
      Endpoints.ordersBoxById(id),
      mapper: (dynamic data) => OrderDetails.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<RefreshTokenResponse> refreshToken(String tokenResponse) async {
    // log('tOKEN REPO --> ${tokenResponse.toJson()}');
    return _httpClient.post(
      Endpoints.refreshToken,
      body: <String, dynamic>{
        'refresh': tokenResponse,
      },
      mapper: (dynamic data) => RefreshTokenResponse.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Regions> getRegionsHi() {
    return _httpClient.get(
      Endpoints.regionsHi,
      mapper: (dynamic data) => Regions.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<Regions> getRegionsCity(String hiRegion) {
    return _httpClient.get(
      Endpoints.regionsCity(hiRegion),
      mapper: (dynamic data) => Regions.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<CreateOrderBox> createOrderBox({
    required CreateOrderBox createOrderBox,
    String? img,
    File? file,
  }) async {
    return _httpClient.post(
      Endpoints.createOrdersBox,
      body: createOrderBox.toJson(),
      mapper: (dynamic data) => CreateOrderBox.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<CreateOrderBox> updateOrderBox({
    required CreateOrderBox createOrderBox,
    required int id,
    String? img,
    File? file,
  }) async {
    return _httpClient.put(
      file: file,
      Endpoints.ordersBoxById(id),
      body: createOrderBox.toJson(),
      mapper: (dynamic data) => CreateOrderBox.fromJson(data as Map<String, dynamic>),
    );
  }

  Future<void> setOrderBoxStatus({required int id, String? comment, String? status}) {
    final bodyData = <String, dynamic>{
      'comment': comment,
      'status': status,
    };
    return _httpClient.put<void>(
      Endpoints.changeOrderStatus(id),
      body: bodyData,
      needDecodeBody: false,
      mapper: (dynamic data) {
        //no-op
      },
    );
  }
}
