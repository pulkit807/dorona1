class NewsModel {
  final String newsUrl;
  final String source;
  final String imgUrl;
  final String title;
  final String description;
  final String timestamp;
  final String content;

  NewsModel(
      {this.newsUrl,
      this.source,
      this.imgUrl,
      this.title,
      this.description,
      this.timestamp,
      this.content});
}
