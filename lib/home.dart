import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

final _urls = [
  'neko',
  'fox_girl',
  'avatar',
  'pat',
  'smug',
  'cuddle',
  'slap',
  'hug',
  'meow',
  'waifu',
];

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<int, String> images = {};
  String category = 'neko';

  Future<String?> _fetchNeko(int index) async {
    if (images[index] != null) return images[index]!;
    var res =
        await http.get(Uri.parse('https://nekos.life/api/v2/img/$category'));
    if (res.statusCode != 200) return null;
    var json = jsonDecode(res.body);
    if (json['url'] == null) return null;
    images[index] = json['url'];
    return '${json['url']}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Deez Nuts'),
          actions: [
            DropdownButton(
                onChanged: (data) {
                  if (data != category) {
                    setState(() {
                      category = data.toString();
                      images = {};
                    });
                  }
                },
                value: category,
                items: _urls
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList())
          ],
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
                        onTap: () {
                          Share.share(snapshot.data!);
                        },
                        child: Image.network(snapshot.data!, height: 250),
                      )
                    : const SizedBox(height: 250),
              );
            },
          ));
        }));
  }
}
