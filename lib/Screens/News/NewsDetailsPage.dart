import 'package:dorona/Model/newsModel.dart';
import 'package:dorona/colors1.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';

class NewsDetailsPage extends StatefulWidget {
  NewsModel news;
  NewsDetailsPage(this.news);
  @override
  _NewsDetailsPageState createState() => _NewsDetailsPageState();
}

class _NewsDetailsPageState extends State<NewsDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: Colors.white,
              iconTheme: IconThemeData(
                color: Colors.black,
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                collapseMode: CollapseMode.parallax,
                titlePadding: EdgeInsets.only(left: 20),
                background: Hero(
                  tag: widget.news.imgUrl,
                  child: Image.network(
                    widget.news.imgUrl,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ];
        },
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  widget.news.title,
                  style: GoogleFonts.aleo(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8),
                child: Container(
                  padding: EdgeInsets.all(3),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: blueColor.withOpacity(0.2)),
                  child: Text(
                    timeago.format(DateTime.parse(
                      widget.news.timestamp,
                    )),
                    style: GoogleFonts.aleo(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
                child: Text(
                  widget.news.description,
                  textAlign: TextAlign.justify,
                  style: GoogleFonts.aleo(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, bottom: 8, right: 8),
                child: RichText(
                  textAlign: TextAlign.justify,
                  text: TextSpan(
                      text: widget.news.content,
                      style: GoogleFonts.aleo(
                          fontWeight: FontWeight.w300, color: Colors.black),
                      children: [
                        TextSpan(
                            text: " Read more",
                            style: GoogleFonts.aleo(color: blueColor),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () async {
                                if (await canLaunch(widget.news.newsUrl)) {
                                  launch(widget.news.newsUrl);
                                }
                              }),
                      ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
