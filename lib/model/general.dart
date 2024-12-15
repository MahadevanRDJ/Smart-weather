class CityDetail {
  int _id = 0;
  String _name = "";

  CityDetail(this._id, this._name);

  String get name => _name;

  set name(String value) {
    _name = value;
  }

  int get id => _id;

  set id(int value) {
    _id = value;
  }

  CityDetail.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = <String, dynamic>{};
    json['id'] = _id;
    json['name'] = _name;
    return json;
  }
}