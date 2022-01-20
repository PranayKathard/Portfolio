class NotificationModel {
  int id;
  int user_id;
  String header;
  String note;

  NotificationModel({this.id, this.user_id, this.header, this.note});

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
        id: int.parse(json['id']),
        user_id: int.parse(json['user_id']),
        header: json['header'] as String,
        note: json['note'] as String);
  }
}
