// To parse this JSON data, do
//
//     final courseTokenReponse = courseTokenReponseFromJson(jsonString);

import 'dart:convert';

CourseTokenResponse courseTokenResponseFromJson(String str) =>
    CourseTokenResponse.fromJson(json.decode(str));

String courseTokenResponseToJson(CourseTokenResponse data) =>
    json.encode(data.toJson());

class CourseTokenResponse {
  CourseTokenResponse({
    this.nonce,
    this.prices,
    this.v,
    this.r,
    this.s,
    this.symbols,
  });

  int? nonce;
  List<String>? prices;
  String? v;
  String? r;
  String? s;
  List<String>? symbols;

  factory CourseTokenResponse.fromJson(Map<String, dynamic> json) =>
      CourseTokenResponse(
        nonce: json["nonce"],
        prices: json["prices"] == null
            ? null
            : List<String>.from(json["prices"].map((x) => x)),
        v: json["v"],
        r: json["r"],
        s: json["s"],
        symbols: json["symbols"] == null
            ? null
            : List<String>.from(json["symbols"].map((x) => x)),
      );

  Map<String, dynamic> toJson() => {
        "nonce": nonce,
        "prices":
            prices == null ? null : List<dynamic>.from(prices!.map((x) => x)),
        "v": v,
        "r": r,
        "s": s,
        "symbols":
            symbols == null ? null : List<dynamic>.from(symbols!.map((x) => x)),
      };
}
