/*
// Example Usage
Map<String, dynamic> map = jsonDecode(<myJSONString>);
var myRootNode = Root.fromJson(map);
*/
import 'dart:developer';

import 'headline_sentiment.dart';

class Article {
  Source? source;
  String? author;
  String? title;
  String? description;
  String? url;
  String? urlToImage;
  String? publishedAt;
  String? content;
  HeadlineSentiment? headLineSentiment;

  Article({this.source, this.author, this.title, this.description, this.url, this.urlToImage, this.publishedAt, this.content});

  Article.fromJson(Map<String, dynamic> json) {
    source = json['source'] != null ? Source?.fromJson(json['source']) : null;
    author = json['author'];
    title = json['title'];
    description = json['description'];
    url = json['url'];
    urlToImage = json['urlToImage'];
    publishedAt = json['publishedAt'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['source'] = source!.toJson();
    data['author'] = author;
    data['title'] = title;
    data['description'] = description;
    data['url'] = url;
    data['urlToImage'] = urlToImage;
    data['publishedAt'] = publishedAt;
    data['content'] = content;
    return data;
  }

  @override
  String toString() {
    return 'Article{source: $source, author: $author, title: $title, description: $description, url: $url, urlToImage: $urlToImage, publishedAt: $publishedAt, content: $content, sentiment : $headLineSentiment}';
  }

  void setSentiment(HeadlineSentiment sentiment) {
    headLineSentiment = sentiment;
  }
}

class Headline {
  String? status;
  int? totalResults;
  List<Article?>? articles;
  List<Article>? positiveList;
  List<Article>? negativeList;
  List<Article>? neutralList;

  Headline({this.status, this.totalResults, this.articles});

  Headline.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    totalResults = json['totalResults'];
    if (json['articles'] != null) {
      articles = <Article>[];
      json['articles'].forEach((v) {
        articles!.add(Article.fromJson(v));
      });
    }
  }

  @override
  String toString() {
    return 'Headline{status: $status, totalResults: $totalResults, articles: $articles}';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['totalResults'] = totalResults;
    if (articles != null) {
      data['articles'] = articles!.map((v) => v?.toJson()).toList();
    } else {
      data['articles'] = null;
    }
    return data;
  }

  List<String> getArticleHeadings() {
    List<String> list = [];
    articles?.forEach((element) {
      list.add(element!.title!);
    });
    return list;
  }

  List<Article> getFilteredArticles(String? type) {
    List<Article> list = <Article>[];
    String sentiment = switch (type) { 'Clear' => 'neutral', 'Rain' => 'neg', 'Clouds' => 'pos', _ => '' };

    log(sentiment);
    for (var i = 0; i < articles!.length; ++i) {
      var article = articles?[i];
      if (article?.headLineSentiment?.label == sentiment) list.add(article!);
    }
    log(list.toString());
    return list;
  }
}

class Source {
  String? id;
  String? name;

  Source({this.id, this.name});

  Source.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['name'] = name;
    return data;
  }

  @override
  String toString() {
    return 'Source{id: $id, name: $name}';
  }
}
