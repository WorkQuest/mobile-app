// To parse this JSON data, do
//
//     final currentCourseTokensResponse = currentCourseTokensResponseFromJson(jsonString);

import 'dart:convert';

CurrentCourseTokensResponse currentCourseTokensResponseFromJson(String str) => CurrentCourseTokensResponse.fromJson(json.decode(str));

String currentCourseTokensResponseToJson(CurrentCourseTokensResponse data) => json.encode(data.toJson());

class CurrentCourseTokensResponse {
  CurrentCourseTokensResponse({
    this.symbol,
    this.price,
    this.timestamp,
  });

  String? symbol;
  String? price;
  String? timestamp;

  factory CurrentCourseTokensResponse.fromJson(Map<String, dynamic> json) => CurrentCourseTokensResponse(
    symbol: json["symbol"],
    price: json["price"],
    timestamp: json["timestamp"],
  );

  Map<String, dynamic> toJson() => {
    "symbol": symbol,
    "price": price,
    "timestamp": timestamp,
  };
}
