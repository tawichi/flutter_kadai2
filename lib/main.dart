import 'dart:async';
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutterkadai2/SecondRoute.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


//データを格納するアルバムを作る
// You can pass any object to the arguments parameter.
// In this example, create a class that contains a customizable
// title and message.
/*class ScreenArguments {
  final String linoft_id;


  ScreenArguments(this.linoft_id,);
}*/

class Album {
  final String linoft_id;
  final String sex;
  final String last_name;
  final String first_name;



  Album({this.linoft_id, this.sex, this.last_name,this.first_name});


  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      linoft_id: json['linoft_id'].toString(),
      sex: json['sex'].toString(),
      last_name: json['last_name'].toString(),
      first_name: json['first_name'].toString(),
    );

  }
}


class CustomListView extends StatelessWidget {




  List users = [];

  CustomListView(this.users);

  @override
  Widget build(BuildContext context) {
    return (
        ListView.builder(
          itemCount: users.length,
          itemBuilder: (BuildContext context, int index) {
            return createviewItem(users[index], context);
          },
        )
    );
  }

  Widget createviewItem(Album users, BuildContext context) {
    return ListTile(
      title: new Card(
          child: new Container(
            decoration: BoxDecoration(border: Border.all(color: Colors.lightBlue)),
            padding: EdgeInsets.all(20.0),
            margin: EdgeInsets.all(20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(children: <Widget>[
                  Text(users.linoft_id),


                  Text ( users.last_name+' '+users.first_name , ),

                ],),
                if(users.sex=="0") Text("M",
                style:  TextStyle(color: Colors.blue.withOpacity(0.6),
                fontWeight: FontWeight.bold),),
                if(users.sex=="1") Text("F",
                  style:  TextStyle(color: Colors.red.withOpacity(0.6),
                  fontWeight: FontWeight.bold),),

                /*Text( (() {



                  switch (users.sex) {
                    case "0":


                      return 'M';
                    case "1":
                      return 'F';
                  }
                }()))*/

              ],


            ),
          )
      ),

      leading: Icon(Icons.perm_identity),
      onTap:(){
        // When the user taps the button, navigate to a named route
        // and provide the arguments as an optional parameter.
        Navigator.pushNamed(
          context,
          ExtractArgumentsScreen.routeName,
          arguments: users.linoft_id
        );
      },

    );
  }

}
class SecondRoute extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return MaterialApp(
      routes: {
        ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
      },
      title: "画面遷移",
      home: Text('ここにIDを渡す'),
    );
  }

}

/*Future<Album> createAlbum(String title) async {
  final http.Response response = await http.post(
    'https://jsonplaceholder.typicode.com/albums',
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(<String, String>{
      'title': title,
    }),
  );
  if (response.statusCode == 201) {
    // If the server did return a 201 CREATED response,
    // then parse the JSON.
    return Album.fromJson(json.decode(response.body));
  } else {
    // If the server did not return a 201 CREATED response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}*/

Future<List<Album>> fetchAlbum() async {//ネットワークへのリクエスト文
  final response =//　httpのページからのレスポンスをresponseに格納
  await http.get('https://linoft.com/dev1/api/linoft_practice_userlist.php');

  if (response.statusCode == 200) {//レスポンスをAlbumに格納
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return compute(parseProfile, response.body);

  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}
/*List<Album> parseUser(String body){
  print(body);
  final parsed = json.decode(body)['UserList'].cast<Map<String,dynamic>>();
  return parsed.map<Album>((json)=> Album.fromJson(json)).toList();


}*/

List<Album> parseProfile(String body){
  print(body);
  final parsed = json.decode(body)['UserList'].cast<Map<String,dynamic>>();
  return parsed.map<Album>((json) => Album.fromJson(json)).toList();
}


void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);


  @override
  _MyAppState createState() => _MyAppState();

}

class _MyAppState extends State<MyApp> {

  Future<List<Album>> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchAlbum();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        ExtractArgumentsScreen.routeName: (context) => ExtractArgumentsScreen(),
      },
      title: 'Fetch Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Fetch Data Example'),
        ),
        body: Center(
          child: FutureBuilder<List<Album>>(
            future: futureAlbum,
            builder: (context, snapshot) {

              if (snapshot.hasData) {
                List<Album> users = snapshot.data;
                return new CustomListView(users);
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }

              // By default, show a loading spinner.
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
