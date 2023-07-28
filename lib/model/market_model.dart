class MarketModel {
  String? lat, lon, name, road_addr, addr, phone;
  MarketModel({
    this.lat,
    this.lon,
  });
  MarketModel.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        road_addr = json['road_addr'],
        addr = json["addr"],
        phone = json['number'];
}
