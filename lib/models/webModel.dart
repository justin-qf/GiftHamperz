class ImageUrl {
  final String url;

  ImageUrl(this.url);
}

class OccasionsListModel {
  final String url;
  final String title;

  OccasionsListModel(this.url, this.title);
}

class FooterModel {
  final String title;
  final String? subTitle;
  final String? icon;

  FooterModel(this.title, {this.subTitle, this.icon});
}
