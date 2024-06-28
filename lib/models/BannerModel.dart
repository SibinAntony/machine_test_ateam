
class BannerModel {
  String key;
  String bannerImage;
  String categoryKey;
  String categoryName;


  BannerModel(
      this.key,
      this.bannerImage,
      this.categoryKey,
      this.categoryName);

  @override
  String toString() {
    return 'BannerModel{key: $key, bannerImage: $bannerImage, categoryKey: $categoryKey, categoryName: $categoryName}';
  }
}
