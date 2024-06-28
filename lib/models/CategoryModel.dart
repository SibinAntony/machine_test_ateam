class CategoryModel {
  String key;
  String name;
  String image;

  CategoryModel(this.key, this.name, this.image);

  @override
  String toString() {
    return 'CategoryModel{key: $key, name: $name, image: $image}';
  }
}
