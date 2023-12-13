// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      refreshToken: json['refresh'] as String,
      accessToken: json['access'] as String,
      user: User.fromJson(json['user'] as Map<String, dynamic>),
      address: Address.fromJson(json['address'] as Map<String, dynamic>),
    );

User _$UserFromJson(Map<String, dynamic> json) => User(
      username: json['username'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      type: json['type'] as String,
    );

RefreshTokenResponse _$RefreshTokenResponseFromJson(
        Map<String, dynamic> json) =>
    RefreshTokenResponse(
      refresh: json['refresh'] as String,
    );

Map<String, dynamic> _$RefreshTokenResponseToJson(
        RefreshTokenResponse instance) =>
    <String, dynamic>{
      'refresh': instance.refresh,
    };

Address _$AddressFromJson(Map<String, dynamic> json) => Address(
      address: json['address'] as String,
      regionName: json['region_name'] as String,
      regionId: json['region_id'] as int,
      regionHi: json['region_hi'] as String,
    );

OrderData _$OrderDataFromJson(Map<String, dynamic> json) => OrderData(
      boxes: (json['boxes'] as List<dynamic>?)
          ?.map((e) => OrdersBox.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

OrderDetails _$OrderDetailsFromJson(Map<String, dynamic> json) => OrderDetails(
      box: json['box'] == null
          ? null
          : OrdersBox.fromJson(json['box'] as Map<String, dynamic>),
      history: (json['history'] as List<dynamic>?)
          ?.map((e) => BoxHistory.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

BoxHistory _$BoxHistoryFromJson(Map<String, dynamic> json) => BoxHistory(
      boxId: json['box_id'] as int?,
      inputDate: json['inputdate'] == null
          ? null
          : DateTime.parse(json['inputdate'] as String),
      regionbhName: json['regionbh__name'] as String?,
      status: json['status'] as String?,
    );

OrdersBox _$OrdersBoxFromJson(Map<String, dynamic> json) => OrdersBox(
      id: json['id'] as int?,
      clientFrom: json['clientfrom'] as String?,
      clientTo: json['clientto'] as String?,
      phoneFrom: json['phonefrom'] as String?,
      phoneTo: json['phoneto'] as String?,
      addressFrom: json['addressfrom'] as String?,
      addressTo: json['addressto'] as String?,
      tarif: _priceFromJson(json['tarif'] as String?),
      amount: _priceFromJson(json['amount'] as String?),
      weight: json['weight'] as String?,
      volumeSm: json['volumesm'] as String?,
      delivery: json['delivery'] as String?,
      minSm: json['minsm'] as String?,
      maxSm: json['maxsm'] as String?,
      placeCount: json['placecount'] as int?,
      disCount: json['disCount'] as String?,
      valuta: json['valuta'] as String?,
      status: json['status'] as String?,
      comment: json['comment'] as String?,
      select: json['select'] as bool?,
      payment: json['payment'] as String?,
      boxImg: json['boximg'] as String?,
      regionFromName: json['regionfrom__name'] as String?,
      regionToName: json['regionto__name'] as String?,
      inputDate: json['inputdate'] == null
          ? null
          : DateTime.parse(json['inputdate'] as String),
      updateDate: json['updatedate'] == null
          ? null
          : DateTime.parse(json['updatedate'] as String),
      user: json['user'] as int?,
      regionFrom: json['regionfrom'] as int?,
      regionTo: json['regionto'] as int?,
    );

SearchSuggestion _$SearchSuggestionFromJson(Map<String, dynamic> json) =>
    SearchSuggestion(
      id: json['id'] as int?,
      title: json['title'] as String,
      dateTimestamp: json['date_timestamp'] as int?,
    );

Map<String, dynamic> _$SearchSuggestionToJson(SearchSuggestion instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('id', instance.id);
  val['title'] = instance.title;
  writeNotNull('date_timestamp', instance.dateTimestamp);
  return val;
}

Regions _$RegionsFromJson(Map<String, dynamic> json) => Regions(
      count: json['count'] as int,
      results: (json['results'] as List<dynamic>)
          .map((e) => RegionResults.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

RegionResults _$RegionResultsFromJson(Map<String, dynamic> json) =>
    RegionResults(
      id: json['id'] as int,
      name: json['name'] as String,
      tarif: json['tarif'] as String,
      hiRegion: json['hi_region'] as String,
    );

CreateOrderBox _$CreateOrderBoxFromJson(Map<String, dynamic> json) =>
    CreateOrderBox(
      clientFrom: json['clientfrom'] as String?,
      clientTo: json['clientto'] as String?,
      phoneFrom: json['phonefrom'] as String?,
      phoneTo: json['phoneto'] as String?,
      addressFrom: json['addressfrom'] as String?,
      addressTo: json['addressto'] as String?,
      tarif: json['tarif'] as String?,
      amount: json['amount'] as String?,
      weight: json['weight'] as String?,
      placeCount: json['placecount'] as int?,
      valuta: $enumDecodeNullable(_$CurrencyEnumMap, json['valuta']),
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']),
      comment: json['comment'] as String?,
      payment: json['payment'] as String?,
      regionFrom: json['regionfrom'] as String?,
      regionTo: json['regionto'] as String?,
      discount: json['discount'] as String?,
      volumeSm: json['volumesm'] as String?,
      weightMax: json['weightmax'] as String?,
      minSm: json['minsm'] as String?,
      maxSm: json['maxsm'] as String?,
      delivery: json['delivery'] as String?,
    );

Map<String, dynamic> _$CreateOrderBoxToJson(CreateOrderBox instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('clientfrom', instance.clientFrom);
  writeNotNull('clientto', instance.clientTo);
  writeNotNull('phonefrom', instance.phoneFrom);
  writeNotNull('phoneto', instance.phoneTo);
  writeNotNull('addressfrom', instance.addressFrom);
  writeNotNull('addressto', instance.addressTo);
  writeNotNull('tarif', instance.tarif);
  writeNotNull('amount', instance.amount);
  writeNotNull('weight', instance.weight);
  writeNotNull('weightmax', instance.weightMax);
  writeNotNull('placecount', instance.placeCount);
  writeNotNull('discount', instance.discount);
  writeNotNull('valuta', _$CurrencyEnumMap[instance.valuta]);
  writeNotNull('status', _$OrderStatusEnumMap[instance.status]);
  writeNotNull('comment', instance.comment);
  writeNotNull('payment', instance.payment);
  writeNotNull('regionfrom', instance.regionFrom);
  writeNotNull('regionto', instance.regionTo);
  writeNotNull('minsm', instance.minSm);
  writeNotNull('volumesm', instance.volumeSm);
  writeNotNull('maxsm', instance.maxSm);
  writeNotNull('delivery', instance.delivery);
  return val;
}

const _$CurrencyEnumMap = {
  Currency.tmt: 'tmt',
  Currency.usd: 'usd',
};

const _$OrderStatusEnumMap = {
  OrderStatus.call: 'call',
};
