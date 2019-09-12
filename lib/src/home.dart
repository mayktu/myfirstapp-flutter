import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:pipa/src/repositories.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String _search = "mayktu";

  Future<Map> _getUsers() async {
    http.Response response;
    response = await http
        .get("https://api.github.com/search/users?q=${_search}&per_page=20");
    return json.decode(response.body);
  }

  Future<List> _getRepositories(user) async {
    http.Response response;
    response = await http
        .get("https://api.github.com/users/${user}/repos");
    return json.decode(response.body);
  }
  
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Busca"),
        centerTitle: true,
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: TextField(
              decoration: InputDecoration(
                  suffixIcon: Icon(Icons.search),
                  labelText: "Pesquisar",
                  labelStyle: TextStyle(color: Colors.black, fontSize: 18),
                  border: OutlineInputBorder()),
              onSubmitted: (text) {
                setState(() {
                  _search = text;
                });
              },
            ),
          ),
          _search != ''
              ? Expanded(
                  child: FutureBuilder<Map>(
                    future: _getUsers(),
                    builder: (context, snapshot) {
                      switch (snapshot.connectionState) {
                        case ConnectionState.waiting:
                        case ConnectionState.none:
                          return Container(
                            alignment: Alignment.center,
                            child: CircularProgressIndicator(),
                          );
                        default:
                          if (snapshot.hasError && !snapshot.hasData) {
                            return Container();
                          } else {
                            return _createGitTable(context, snapshot);
                          }
                      }
                    },
                  ),
                )
              : Container()
        ],
      ),
    );
  }

  Widget _createGitTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 0.65,
        ),
        itemCount: snapshot.data["items"].length,
        itemBuilder: (context, index) {
          return InkWell(
            //Ao clicar no usuario ele armazena o nome na variavel user
            onTap: (){
              var user = snapshot.data["items"][index]["login"];
              _getRepositories(user).then((res){
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => Repositories(user, res)));
              });
              
            },
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  AspectRatio(
                    aspectRatio: 0.8,
                    child: Image.network(
                        snapshot.data["items"][index]["avatar_url"],
                        fit: BoxFit.cover),
                  ),
                  Expanded(
                    child: Center(
                      child: Text(
                        snapshot.data["items"][index]["login"],
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }
}
