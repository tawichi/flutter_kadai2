import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutterkadai2/main.dart';



// You can pass any object to the arguments parameter.
// In this example, create a class that contains a customizable
// title and message.
Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}
Future<Album1> createAlbum1(String linoft_id) async {
  final http.Response response = await http.post(
    'https://linoft.com/dev1/api/linoft_practice_profile.php',
    headers: {
      // 'Content-Type': 'application/json; charset=UTF-8',
    },
    body: {
      'linoft_id': linoft_id,
    });


  if (response.statusCode == 201) {
    return Album1.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create Album1.');
  }
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

void main() {
  runApp(ExtractArgumentsScreen());
}

class ExtractArgumentsScreen extends StatefulWidget {
  static const routeName = '/extractArguments';
  ExtractArgumentsScreen({Key key}) : super(key: key);

  @override
  _ExtractArgumentsScreenState createState() {
    return _ExtractArgumentsScreenState();
  }
}

class _ExtractArgumentsScreenState extends State<ExtractArgumentsScreen> {
  final TextEditingController _controller = TextEditingController();
  Future<Album1> _futureAlbum1;

  @override
  Widget build(BuildContext context) {

    final Album args = ModalRoute.of(context).settings.arguments;
    _futureAlbum1 = createAlbum1(args.linoft_id);




    return MaterialApp(
      title: 'Create Data Example',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home:
      Center(
        child: FutureBuilder<Album1>(
          future: _futureAlbum1,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data.profile_picture==null)
                return Container();
              Uint8List bytes = base64.decode(snapshot.data.profile_picture);


              return Scaffold(
                appBar: AppBar(),
                body: Column(
                  children: <Widget>[

                    Image.memory(bytes),



                    Text(snapshot.data.profile_text),
                    Text(snapshot.data.linoft_id.toString())
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
