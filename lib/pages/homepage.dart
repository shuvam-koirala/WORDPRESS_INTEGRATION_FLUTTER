import "package:flutter/material.dart";
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_html/style.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:wordpress_flutter/presentor/wp-api-presentor.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "My Wordpress Blog",
          style: TextStyle(
              color: Colors.green, fontSize: 32, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.black,
      ),
      body: Container(
        child: FutureBuilder(
          future: fetchWpPost(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  Map wpPost = snapshot.data[index];
                  String postUrl = wpPost["link"];
                  return InkWell(
                    onTap: () async {
                      if (await canLaunch(postUrl)) {
                        await launch(postUrl,
                            forceWebView: false,
                            forceSafariVC: true,
                            enableJavaScript: true);
                      } else {
                        throw "could not launch url";
                      }
                    },
                    child: Card(
                      color: Colors.black,
                      elevation: 10.0,
                      shadowColor: Colors.black,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            wpPost["title"]["rendered"],
                            style: TextStyle(
                                color: Colors.lightGreen,
                                fontSize: 22,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 10),
                          Text(
                            wpPost["modified_gmt"],
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                                fontWeight: FontWeight.w500),
                          ),
                          SizedBox(height: 1),
                          Html(
                            data: wpPost["excerpt"]["rendered"],
                            style: {
                              "p": Style(
                                  alignment: Alignment.center,
                                  fontSize: FontSize.larger,
                                  color: Colors.white)
                            },
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.green,
                strokeWidth: 6.0,
                valueColor: AlwaysStoppedAnimation(Colors.yellow),
              ));
            }
          },
        ),
      ),
    );
  }
}
