class PdfData {
  String title;
  String link;

  PdfData({
    required this.title,
    required this.link,
  });

  PdfData.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        link = json['link'];
}
