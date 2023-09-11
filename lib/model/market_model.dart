class MarketModel {
  String? lat, lon, name, road_addr, addr, phone;
  MarketModel({
    this.lat,
    this.lon,
  });
  void fromJson(Map<String, dynamic> json) {
    name = json['name']; //type error
    road_addr = json['road_addr'];
    addr = json["addr"];
    phone = json['Phone'];
  }
}
