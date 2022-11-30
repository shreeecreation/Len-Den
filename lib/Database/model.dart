class PartyModel {
  int? id;
  String? name;
  String? phone;
  int? blc;
  String? address;
  String? date;
  int? mode;
  int? totalblc;

  PartyModel(
      {this.id,
      required this.name,
      required this.totalblc,
      required this.phone,
      required this.blc,
      required this.address,
      required this.date,
      required this.mode});

  PartyModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    phone = json['phone'];
    blc = json['blc'];
    date = json['date'];
    address = json['address'];
    mode = json['mode'];
    totalblc = json['totalblc'];
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    data['phone'] = phone;
    data['blc'] = blc;
    data['address'] = address;
    data['date'] = date;
    data['mode'] = mode;
    data['totalblc'] = totalblc;
    return data;
  }
}
