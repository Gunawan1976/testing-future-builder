import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  List<Map<String, dynamic>> allUser = [];

  Future getAllUser() async {
    try {
      var response = await http.get(Uri.parse("https://reqres.in/api/users"));
      List data = (json.decode(response.body) as Map<String, dynamic>)["data"];
      data.forEach(
        (element) {
          allUser.add(element);
        },
      );
      print(allUser);
    } catch (e) {
      print("terjadi kesalahn atau koneksi buruk");
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("testing future builder "),
      ),
      body: Center(
        child: FutureBuilder(
          future: getAllUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: Text("Loading....."),
              );
            } else {
              return ListView.builder(
                itemCount: allUser.length,
                itemBuilder: (context, index) => ListTile(
                  leading: CircleAvatar(
                    backgroundImage:
                        NetworkImage("${allUser[index]['avatar']}"),
                    backgroundColor: Colors.grey,
                  ),
                  title: Text(
                      "${allUser[index]['first_name']}${allUser[index]['last_name']}"),
                  subtitle: Text("${allUser[index]["email"]}"),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
