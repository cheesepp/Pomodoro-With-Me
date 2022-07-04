import 'package:pomodoro/providers/category.dart';

List<Categories>? jsonToEnum(List<dynamic> jsonCategories) {
  List<Categories> jsonToEnum = [];
  for (int i = 0; i < jsonCategories.length; i++) {
    if (jsonCategories[i].compareTo('Anime') == 0) {
      jsonToEnum.add(Categories.Anime);
    }
    if (jsonCategories[i].compareTo('Cafe') == 0) {
      jsonToEnum.add(Categories.Cafe);
    }
    if (jsonCategories[i].compareTo('City') == 0) {
      jsonToEnum.add(Categories.City);
    }
    if (jsonCategories[i].compareTo('Lofi') == 0) {
      jsonToEnum.add(Categories.Lofi);
    }
    if (jsonCategories[i].compareTo('Kpop') == 0) {
      jsonToEnum.add(Categories.Kpop);
    }
    if (jsonCategories[i].compareTo('Nature') == 0) {
      jsonToEnum.add(Categories.Nature);
    }
    if (jsonCategories[i].compareTo('Space') == 0) {
      jsonToEnum.add(Categories.Space);
    }
    if (jsonCategories[i].compareTo('Window') == 0) {
      jsonToEnum.add(Categories.Window);
    }
    if (jsonCategories[i].compareTo('Code') == 0) {
      jsonToEnum.add(Categories.Code);
    }
    if (jsonCategories[i].compareTo('Beach') == 0) {
      jsonToEnum.add(Categories.Beach);
    }
    return jsonToEnum;
  }
}
