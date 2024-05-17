class Category {
  String? categoryId;
  String? image;
  String title;
  String titleAr;
  bool visible ;
  int weight;
  List<String> subcategories;
  List<String> subcategoriesAr;

  Category({
    this.categoryId,
    this.image,
    required this.weight,
    required this.title,
    required this.titleAr,
    required this.subcategoriesAr,
    required this.visible,
    required this.subcategories,
  });

  factory Category.fromMap(Map<String, dynamic> responseData,String categoryId) {
    return Category(
      categoryId: categoryId ?? '',
      image: responseData['image'] ?? '',
      weight: responseData['weight'] ?? 0,
      visible: responseData['visible'] ?? false,
      title: responseData['title'] ?? '',
      titleAr: responseData['titleAr'] ?? '',
      subcategoriesAr: responseData['subcategoriesAr']?.cast<String>() ?? [],
      subcategories: responseData['subcategories']?.cast<String>() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['categoryId'] = this.categoryId;
    data['image'] = this.image;
    data['title'] = this.title;
    data['titleAr'] = this.titleAr;
    data['weight'] = this.weight;
    data['visible'] = this.visible;
    data['subcategoriesAr'] = this.subcategoriesAr;
    data['subcategories'] = this.subcategories;
    return data;
  }

  Map<String, dynamic> toJsonForUpdate({String? image , String? title,String? titleAr ,subcategoriesAr, subcategories,bool? visible,int? weight}) {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['image'] = image!;
    data['title'] = title!;
    data['titleAr'] = titleAr!;
    data['visible'] = visible;
    data['weight'] = weight;
    data['subcategories'] = subcategories;
    data['subcategoriesAr'] = subcategoriesAr;
    return data;
  }
}
