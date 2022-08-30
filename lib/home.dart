import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, String> nekos = {};

  Future<String?> _fetchNeko(int index) async {
    if (nekos[index] != null) return nekos[index]!;
    var res = await http.get(Uri.parse('https://nekos.life/api/neko'));
    if (res.statusCode != 200) return null;
    var json = jsonDecode(res.body);
    nekos[index] = json['neko'];
    return '${json['neko']}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.title),
        ),
        body: ListView.builder(itemBuilder: (context, i) {
          return Center(
              child: FutureBuilder<String?>(
            future: _fetchNeko(i),
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(4.0),
                child: snapshot.data != null
                    ? GestureDetector(
                        onTap: () {},
                        child: Stack(children: [
                          Image.network(snapshot.data!, height: 250),
                          const Icon(Icons.favorite, color: Color(0xffffeb54)),
                        ]),
                      )
                    : const SizedBox(height: 250),
              );
            },
          ));
        }));
  }
}
