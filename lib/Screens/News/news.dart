import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:dorona/Model/newsModel.dart';
import 'package:dorona/Screens/News/NewsDetailsPage.dart';
import 'package:dorona/colors1.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:timeago/timeago.dart' as timeago;

class News extends StatefulWidget {
  @override
  _NewsState createState() => _NewsState();
}

class _NewsState extends State<News> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: http.get(
          "http://newsapi.org/v2/top-headlines?q=covid-19&country=in&apiKey=330f3c2a3aa54e76a4c53dc1bc77196a&pageSize=10&page=1",
        ),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: Container(
                width: 20,
                height: 20,
                margin: EdgeInsets.only(top: 10),
                child: CircularProgressIndicator(
                  strokeWidth: 1,
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          http.Response response = snapshot.data;
          final data = json.decode(response.body);
          List<NewsModel> allNews = [];
          data['articles'].forEach((article) {
            if (article['description'] != null &&
                article['urlToImage'] != null &&
                article['url'] != null &&
                article['source']['name'] != null &&
                article['publishedAt'] != null &&
                article['title'] != null &&
                article['content'] != null) {
              allNews.add(NewsModel(
                  description: article['description'],
                  imgUrl: article['urlToImage'],
                  newsUrl: article['url'],
                  source: article['source']['name'],
                  timestamp: article['publishedAt'],
                  title: article['title'],
                  content: article['content']));
            }
          });
          return Container(
            child: ListView.builder(
              itemCount: allNews.length,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return FadeIn(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NewsDetailsPage(
                            allNews[index],
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.all(8),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Hero(
                            tag: allNews[index].imgUrl,
                            child: Container(
                              width: 100,
                              height: 100,
                              child: Card(
                                elevation: 3,
                                child: Image.network(
                                  allNews[index].imgUrl,
                                  width: 100,
                                  height: 100,
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                              top: 8,
                              left: 8,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width - 125,
                                  child: Text(
                                    allNews[index].title,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.aleo(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                    top: 4,
                                  ),
                                  width:
                                      MediaQuery.of(context).size.width - 125,
                                  child: Text(
                                    allNews[index].description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.aleo(
                                        fontWeight: FontWeight.w200),
                                  ),
                                ),
                                SizedBox(
                                  height: 2,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          color: blueColor.withOpacity(0.2),
                                        ),
                                        child: Text(
                                          allNews[index].source,
                                          style: GoogleFonts.aleo(
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.all(5),
                                        child: Text(
                                          timeago.format(
                                            DateTime.parse(
                                              allNews[index].timestamp,
                                            ),
                                          ),
                                          style: GoogleFonts.aleo(
                                            fontWeight: FontWeight.w200,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
