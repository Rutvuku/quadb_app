import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quadb_app/screens/details_screen.dart';
import 'package:quadb_app/screens/search_screen.dart';

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
        backgroundColor: Colors.black87,
        title: Text('QuadB Tech',style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.bold),),
        actions: [Padding(
          padding: const EdgeInsets.all(18.0),
          child: InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
            },
              child: Icon(Icons.search,color: Colors.red,)),
        ),
    ]
      ),
      backgroundColor: Colors.black87,
      body: ListView.builder(
        itemCount: apiResponse.length,
        itemBuilder: (context, index) {
          var show = apiResponse[index].show;

          return InkWell(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (builder)=>DetailScreen(rating: show.rating['average'].toString(), name: show.name, imgurl: show.image['original'], summary: show.summary)));
            },
            child: Container(
              height: 300,
              width: 200,
              child: Column(
                children: [
                  Image.network(
                    show.image['original'],
                    width: 190.0,
                    height:190.0,
                    fit: BoxFit.cover,
                  ),
                  Text(show.name,style: TextStyle(color: Colors.red,fontSize: 21,fontWeight: FontWeight.bold),),
                  Text(show.rating['average'].toString(),style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.bold),),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
