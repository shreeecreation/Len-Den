class ExpensesModel {
  int? id;
  String? category;
  int? blc;
  String? payment;
  String? notes;
  String? date;
  ExpensesModel({this.id, required this.blc, required this.date, required this.category, required this.payment, required this.notes});

  ExpensesModel.fromMap(Map<String, dynamic> json) {
    id = json['id'];
    blc = json['blc'];
    date = json['date'];
    category = json['category'];
    notes = json['notes'];
    payment = json['payment'];
  }
  Map<String, dynamic> toMap() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['blc'] = blc;
    data['date'] = date;
    data['category'] = category;
    data['notes'] = notes;
    data['payment'] = payment;
    return data;
  }
}
