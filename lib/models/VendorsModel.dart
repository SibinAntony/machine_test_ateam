
class VendorsModel {
  String key;
  String vendorName;
  String vendorImage;
  String vendorLatitude;
  String vendorLongitude;
  String categoryKey;
  String categoryName;
  String distance;


  VendorsModel(
      this.key,
      this.vendorName,
      this.vendorImage,
      this.vendorLatitude,
      this.vendorLongitude,
      this.categoryKey,
      this.categoryName,
      this.distance,
      );

  @override
  String toString() {
    return 'VendorsModel{key: $key, vendorName: $vendorName, vendorImage: $vendorImage, vendorLatitude: $vendorLatitude, vendorLongitude: $vendorLongitude, categoryKey: $categoryKey, categoryname: $categoryName , distance: $distance }';
  }
}
