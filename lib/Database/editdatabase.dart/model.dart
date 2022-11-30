class EditModel {
  int? id;
  int? blc;
  int? initialblc;
  int? totalblc;
  String? name;
  String? date;
  int? mode;
  EditModel(
      {this.id, required this.blc, required this.name, required this.date, required this.mode, required this.initialblc, required this.totalblc});

  EditModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    blc = json['blc'];
    date = json['date'];
    name = json['name'];
    mode = json['mode'];
    initialblc = json['initialblc'];
    totalblc = json['totalblc'];
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['blc'] = blc;
    data['name'] = name;
    data['date'] = date;
    data['mode'] = mode;
    data['initialblc'] = initialblc;
    data['totalblc'] = totalblc;
    return data;
  }
}
