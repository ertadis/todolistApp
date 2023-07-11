import 'dart:convert';

import 'userdata_model.dart';

class ListUsersModel {
  int? page;
  int? perPage;
  int? total;
  int? totalPages;
  List<UserData>? data;

  ListUsersModel({
    this.page,
    this.perPage,
    this.total,
    this.totalPages,
    this.data,
  });

  factory ListUsersModel.fromRawJson(String str) =>
      ListUsersModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ListUsersModel.fromJson(Map<String, dynamic> json) => ListUsersModel(
        page: json["page"],
        perPage: json["per_page"],
        total: json["total"],
        totalPages: json["total_pages"],
        data: json["data"] == null
            ? []
            : List<UserData>.from(
                json["data"]!.map((x) => UserData.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "page": page,
        "per_page": perPage,
        "total": total,
        "total_pages": totalPages,
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
      };
}
