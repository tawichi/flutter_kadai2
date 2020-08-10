import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutterkadai2/main.dart';
import 'package:flutter/foundation.dart';


// You can pass any object to the arguments parameter.
// In this example, create a class that contains a customizable
// title and message.

Future<Map> createAlbum1(String linoft_id) async {
  final http.Response response = await http.post(
    'https://linoft.com/dev1/api/linoft_practice_profile.php',
    headers: {
      // 'Content-Type': 'application/json; charset=UTF-8',
    },
    body: {
      'linoft_id': linoft_id,
    });


  if (response.statusCode == 200) {
    //print(json.decode(response.body));
    final parsed2 = json.decode(response.body)['UserProfile'][0];
    print(parsed2);
    print(parsed2['linoft_id']);
    print(parsed2['profile_text']);
    print(parsed2['profile_picture']);
    return parsed2;
  } else {
    throw Exception('Failed to create Album1.');
  }
}

Album1 parseUser(String body){

  final parsed1 = json.decode(body)['UserProfile'].cast<Map<String,dynamic>>();
  final parsed2 = json.decode(body)['UserProfile'][0];
  return parsed2;
  return parsed1.map<Album1>((json)=> Album1.fromJson(json)).toList();


}

class Album1 {
  final String linoft_id;
  final String profile_text;
  final String profile_picture;


  Album1({this.linoft_id, this.profile_text,this.profile_picture});

  factory Album1.fromJson(Map<String, dynamic> json) {
    return Album1(
      linoft_id: json['linoft_id'].toString(),
      profile_text: json['profile_text'].toString(),
      profile_picture: json['profile_picture'].toString()


    );
  }
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

void main() {
  runApp(ExtractArgumentsScreen());
}

class ExtractArgumentsScreen extends StatefulWidget {
  static const routeName = '/extractArguments';
  ExtractArgumentsScreen({Key key}) : super(key: key);
  List profile = [];

  @override
  _ExtractArgumentsScreenState createState() {
    return _ExtractArgumentsScreenState();
  }
}

class _ExtractArgumentsScreenState extends State<ExtractArgumentsScreen> {

  Future<Map> _futureAlbum1;


  @override
  Widget build(BuildContext context) {

    final String args = ModalRoute.of(context).settings.arguments;
    _futureAlbum1 = createAlbum1(args);


    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      Center(
        child: FutureBuilder<Map>(
          future: _futureAlbum1,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              //List<Album1> profile = snapshot.data;
              if (snapshot.data['profile_picture']==null)
                return Container();
              Uint8List bytes = base64.decode(snapshot.data['profile_picture']);
              //print(snapshot.data.profile_text);//ここには来てない


              return Scaffold(
                appBar: AppBar(
                  title: Text('プロフィール'),
                ),
                body: Column(
                  children: <Widget>[

                    Image.memory(bytes),//bytesはイメージそのもの




                    Text(snapshot.data['profile_text']),
                    Text(snapshot.data['linoft_id'])


                  ],
                ),
              );
            } else if (snapshot.hasError) {
              return Text("${snapshot.error}");
            }

            return CircularProgressIndicator();
          },
        ),
      ),
    );

  }
}
