class MakerCollectModel {
  double lat, lng;
  String name, detail, pathImage, dateTime, uid;

  MakerCollectModel({
    this.lat,
    this.lng,
    this.name,
    this.detail,
    this.pathImage,
    this.dateTime,
    this.uid,
  });

  MakerCollectModel.fromMap(Map<String, dynamic> map) {
    lat = map['Lat'];
    lng = map['Lng'];
    name = map['Name'];
    detail = map['Detail'];
    pathImage = map['PathImage'];
    dateTime = map['DateTime'];
    uid = map['Uid'];
  }
}
