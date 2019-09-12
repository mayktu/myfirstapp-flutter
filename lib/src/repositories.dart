import 'package:flutter/material.dart';
import "package:url_launcher/url_launcher.dart";

class Repositories extends StatelessWidget {
  final String user;
  final List repo;
  Repositories(this.user, this.repo);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Repositorios"),
          centerTitle: true,
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.all(15),
                itemCount: repo.length,
                itemBuilder: (context, index) {
                  return _repositoriesCard(context, index, repo);
                }),
          )
        ]));
  }

  Widget _repositoriesCard(BuildContext context, int index, List repo) {
    return InkWell(
      onTap: () {
        _launchURL(repo[index]["html_url"]);
      },
      child: Card(
          child: Row(
        children: <Widget>[
          Flexible(
              flex: 1,
              child: Container(
                padding: EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "${repo[index]["name"]}",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 17,
                          fontWeight: FontWeight.bold),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Text(
                          "${repo[index]["description"] == null ? "Sem descrição" : repo[index]["description"]}"),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: <Widget>[
                          Icon(
                            Icons.language,
                            size: 15,
                          ),
                          Text(
                              "${repo[index]["language"] == null ? "N/D" : repo[index]["language"]}"),
                          VerticalDivider(),
                          Icon(
                            Icons.star,
                            size: 15,
                          ),
                          Text("${repo[index]["watchers_count"]}"),
                          VerticalDivider(),
                          Icon(
                            Icons.device_hub,
                            size: 15,
                          ),
                          Text("${repo[index]["forks_count"]}")
                        ],
                      ),
                    )

                  ],
                ),
              )),
        ],
      )),
    );
  }


  _launchURL(url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Não foi possível abrir o link desejado. :(';
    }
  }
}
