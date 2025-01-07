
class Itemcate {
  String? title;
  String? tage;
  String? imageUrl;
  Itemcate({
    required this.title,
    required this.tage,
    required this.imageUrl,
  });
  Itemcate.fromJSON(Map<String,dynamic> items) {
    title = items["title"] ??"";
    tage = items["tag"] ??"";
    imageUrl = items["image"]??"";
  }
}
