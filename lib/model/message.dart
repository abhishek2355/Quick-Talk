class Messages {
  Messages({
    required this.fromId,
    required this.sent,
    required this.msg,
    required this.toId,
    required this.type,
    required this.read,
  });
  late final String fromId;
  late final String sent;
  late final String msg;
  late final String toId;
  late final Type type;
  late final String read;

  Messages.fromJson(Map<String, dynamic> json) {
    fromId = json['from_id'].toString();
    sent = json['sent '].toString();
    msg = json['msg'].toString();
    toId = json['to_id'].toString();
    type = json['type '].toString() == Type.image.name ? Type.image : Type.text;
    read = json['read'].toString();
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['from_id'] = fromId;
    data['sent '] = sent;
    data['msg'] = msg;
    data['to_id'] = toId;
    data['type '] = type.name;
    data['read'] = read;
    return data;
  }
}

enum Type { text, image }
