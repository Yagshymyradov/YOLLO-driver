import 'dart:io';

import 'package:json_annotation/json_annotation.dart';

import '../utils/enums.dart';

part 'response.g.dart';

double? _priceFromJson(String? value) => double.tryParse(value ?? '');

@JsonSerializable()
class LoginResponse {
  @JsonKey(name: 'refresh')
  final String refreshToken;
  @JsonKey(name: 'access')
  final String accessToken;
  final User user;
  final Address address;

  LoginResponse({
    required this.refreshToken,
    required this.accessToken,
    required this.user,
    required this.address,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => _$LoginResponseFromJson(json);
}

@JsonSerializable()
class User {
  final String username;
  final String name;
  final String email;
  final String phone;
  final String type;

  User({
    required this.username,
    required this.name,
    required this.email,
    required this.phone,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@JsonSerializable()
class RefreshTokenResponse {
  final String access;

  RefreshTokenResponse({
    required this.access,
  });

  factory RefreshTokenResponse.fromJson(Map<String, dynamic> json) =>
      _$RefreshTokenResponseFromJson(json);
}

@JsonSerializable()
class Address {
  final String address;
  final String regionName;
  final int regionId;
  final String regionHi;

  Address({
    required this.address,
    required this.regionName,
    required this.regionId,
    required this.regionHi,
  });

  factory Address.fromJson(Map<String, dynamic> json) => _$AddressFromJson(json);
}

@JsonSerializable()
class OrderData {
  final List<OrdersBox>? boxes;

  OrderData({required this.boxes});

  factory OrderData.fromJson(Map<String, dynamic> json) => _$OrderDataFromJson(json);
}

@JsonSerializable()
class OrderDetails {
  final OrdersBox? box;
  final List<BoxHistory>? history;

  OrderDetails({
    required this.box,
    required this.history,
  });

  factory OrderDetails.fromJson(Map<String, dynamic> json) => _$OrderDetailsFromJson(json);
}

@JsonSerializable()
class BoxHistory {
  final int? boxId;
  @JsonKey(name: 'inputdate')
  final DateTime? inputDate;
  @JsonKey(name: 'regionbh__name')
  final String? regionbhName;
  final String? status;

  factory BoxHistory.fromJson(Map<String, dynamic> json) => _$BoxHistoryFromJson(json);

  BoxHistory({
    required this.boxId,
    required this.inputDate,
    required this.regionbhName,
    required this.status,
  });
}

@JsonSerializable()
class OrdersBox {
  final int? id;
  @JsonKey(name: 'clientfrom')
  final String? clientFrom;
  @JsonKey(name: 'clientto')
  final String? clientTo;
  @JsonKey(name: 'phonefrom')
  final String? phoneFrom;
  @JsonKey(name: 'phoneto')
  final String? phoneTo;
  @JsonKey(name: 'addressfrom')
  final String? addressFrom;
  @JsonKey(name: 'addressto')
  final String? addressTo;
  @JsonKey(fromJson: _priceFromJson)
  final double? tarif;
  @JsonKey(fromJson: _priceFromJson)
  final double? amount;
  final String? weight;
  @JsonKey(name: 'volumesm')
  final String? volumeSm;
  final String? delivery;
  @JsonKey(name: 'minsm')
  final String? minSm;
  @JsonKey(name: 'maxsm')
  final String? maxSm;
  @JsonKey(name: 'placecount')
  final int? placeCount;
  @JsonKey(name: 'disCount')
  final String? disCount;
  final String? valuta;
  final String? status;
  final String? comment;
  final bool? select;
  final String? payment;
  @JsonKey(name: 'boximg')
  final String? boxImg;
  @JsonKey(name: 'regionfrom__name')
  final String? regionFromName;
  @JsonKey(name: 'regionfrom')
  final int? regionFrom;
  @JsonKey(name: 'regionto')
  final int? regionTo;
  @JsonKey(name: 'regionto__name')
  final String? regionToName;
  @JsonKey(name: 'inputdate')
  final DateTime? inputDate;
  @JsonKey(name: 'updatedate')
  final DateTime? updateDate;
  final int? user;

  OrdersBox({
    required this.id,
    required this.clientFrom,
    required this.clientTo,
    required this.phoneFrom,
    required this.phoneTo,
    required this.addressFrom,
    required this.addressTo,
    required this.tarif,
    required this.amount,
    required this.weight,
    required this.volumeSm,
    required this.delivery,
    required this.minSm,
    required this.maxSm,
    required this.placeCount,
    required this.disCount,
    required this.valuta,
    required this.status,
    required this.comment,
    required this.select,
    required this.payment,
    required this.boxImg,
    required this.regionFromName,
    required this.regionToName,
    required this.inputDate,
    required this.updateDate,
    required this.user,
    required this.regionFrom,
    required this.regionTo,
  });

  factory OrdersBox.fromJson(Map<String, dynamic> json) => _$OrdersBoxFromJson(json);
}

@JsonSerializable(createToJson: true)
class SearchSuggestion {
  final int? id;
  final String title;
  final int? dateTimestamp;

  SearchSuggestion({
    required this.id,
    required this.title,
    required this.dateTimestamp,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) => _$SearchSuggestionFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSuggestionToJson(this);
}

@JsonSerializable()
class Regions {
  final int count;
  final List<RegionResults> results;

  Regions({
    required this.count,
    required this.results,
  });

  factory Regions.fromJson(Map<String, dynamic> json) => _$RegionsFromJson(json);
}

@JsonSerializable()
class RegionResults {
  final int id;
  final String name;
  final String tarif;
  final String hiRegion;

  RegionResults({
    required this.id,
    required this.name,
    required this.tarif,
    required this.hiRegion,
  });

  factory RegionResults.fromJson(Map<String, dynamic> json) => _$RegionResultsFromJson(json);
}

@JsonSerializable(createToJson: true)
class CreateOrderBox {
  @JsonKey(name: 'clientfrom')
  final String? clientFrom;
  @JsonKey(name: 'clientto')
  final String? clientTo;
  @JsonKey(name: 'phonefrom')
  final String? phoneFrom;
  @JsonKey(name: 'phoneto')
  final String? phoneTo;
  @JsonKey(name: 'addressfrom')
  final String? addressFrom;
  @JsonKey(name: 'addressto')
  final String? addressTo;
  final String? tarif;
  final String? amount;
  final String? weight;
  @JsonKey(name: 'weightmax')
  final String? weightMax;
  @JsonKey(name: 'placecount')
  final int? placeCount;
  final String? discount;
  final Currency? valuta;
  final OrderStatus? status;
  final String? comment;
  final String? payment;
  @JsonKey(name: 'regionfrom')
  final String? regionFrom;
  @JsonKey(name: 'regionto')
  final String? regionTo;
  @JsonKey(name: 'minsm')
  final String? minSm;
  @JsonKey(name: 'volumesm')
  final String? volumeSm;
  @JsonKey(name: 'maxsm')
  final String? maxSm;
  final String? delivery;
  @JsonKey(ignore: true)
  final String? img;
  @JsonKey(ignore: true)
  final File? file;

  CreateOrderBox({
    required this.clientFrom,
    required this.clientTo,
    required this.phoneFrom,
    required this.phoneTo,
    required this.addressFrom,
    required this.addressTo,
    required this.tarif,
    required this.amount,
    required this.weight,
    required this.placeCount,
    required this.valuta,
    required this.status,
    required this.comment,
    required this.payment,
    required this.regionFrom,
    required this.regionTo,
    this.img,
    this.file,
    required this.discount,
    required this.volumeSm,
    required this.weightMax,
    required this.minSm,
    required this.maxSm,
    required this.delivery,
  });

  factory CreateOrderBox.fromJson(Map<String, dynamic> json) => _$CreateOrderBoxFromJson(json);

  Map<String, dynamic> toJson() => _$CreateOrderBoxToJson(this);
}
