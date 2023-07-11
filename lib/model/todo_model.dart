import 'dart:convert';

class ToDoModel {
  String? uuid;
  String? task;
  bool? completed;

  ToDoModel({
    this.uuid,
    this.task,
    this.completed,
  });

  factory ToDoModel.fromRawJson(String str) =>
      ToDoModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ToDoModel.fromJson(Map<String, dynamic> json) => ToDoModel(
        uuid: json["UUID"],
        task: json["task"],
        completed: json["completed"],
      );

  Map<String, dynamic> toJson() => {
        "UUID": uuid,
        "task": task,
        "completed": completed,
      };
}
