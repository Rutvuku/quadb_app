import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/MoviesModel.dart';
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<TvShowModel> apiResponse = [];

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=all'));
    if (response.statusCode == 200) {
      setState(() {
        apiResponse = (json.decode(response.body) as List)
            .map((data) => TvShowModel.fromJson(data))
            .toList();
      });
    } else {
      // Handle error
      print('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TV Shows'),
      ),
      body: ListView.builder(
        itemCount: apiResponse.length,
        itemBuilder: (context, index) {
          var show = apiResponse[index].show;

          return Container(
            height: 300,
            width: 200,
            child: Card(

              child: Column(
                children: [
                  Image.network(
                    show.image['original'],
                    width: 150.0,
                    height:150.0,
                    fit: BoxFit.cover,
                  ),
                  Text(show.name),
                  Text(show.rating['average'].toString()),
                ],
              )
            ),
          );
        },
      ),
    );
  }
}
