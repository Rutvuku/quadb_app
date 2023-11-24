import 'dart:convert';

import 'package:custom_button_builder/custom_button_builder.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quadb_app/screens/details_screen.dart';
import 'package:quadb_app/screens/home_screen.dart';

import '../models/MoviesModel.dart';
class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isSearchActive = false;
  final _focusNode = FocusNode();
  TextEditingController searchController = TextEditingController();

  void _toggleSearch() {
    setState(() {
      _isSearchActive = !_isSearchActive;
    });
    if (!_isSearchActive) {
      _focusNode.unfocus();
    }
  }
  List<TvShowModel> apiResponse = [];



  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=${searchController.text}'));
    print(response);
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
  void initState() {
    super.initState();
    setState(() {
      fetchData();
    });
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      bottomNavigationBar: CustomNavigationBar(),
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(38.0),
          child: Column(
            children: [
            GestureDetector(
            onTap: _toggleSearch,
            child: AnimatedContainer(
              duration: Duration(milliseconds: 300),
              width: _isSearchActive ? 200 : 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(50),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade800,
                    offset: Offset(1.5, 1.5),
                    blurRadius: 3.0,
                  ),
                  BoxShadow(
                    color: Colors.grey.shade600,
                    offset: Offset(-1.5, -1.5),
                    blurRadius: 3.0,
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: _isSearchActive ? 10 : 0),
                    child: Icon(Icons.search, color: Colors.white),
                  ),
                  _isSearchActive ? Expanded(child: Padding(
                    padding: EdgeInsets.only(right: 10),
                    child: TextField(
                      autofocus: true,
                      focusNode: _focusNode,
                      controller: searchController,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: "Type to search...",
                        hintStyle: TextStyle(color: Colors.white70),
                      ),
                    ),
                  )) : Container(),

                ],
              ),
            ),
          ),
          CustomButton(
            onPressed: (){
              fetchData();
            },
            width: 150,
            backgroundColor: Colors.red,
            isThreeD: true,
            height: 35,
            borderRadius: 25,
            animate: true,
            margin: const EdgeInsets.all(10),
            child: Text(
              "Search",
              style: TextStyle(color: Colors.white,fontSize: 20,fontWeight: FontWeight.bold),
            ),
          ),
            Expanded(child: ListView.builder(
              itemCount: apiResponse.length,
              itemBuilder: (context, index) {
                // setState(() {
                //   fetchData();
                // });
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
                          width: 210.0,
                          height:210.0,
                          fit: BoxFit.cover,
                        ),
                        Text(show.name,style: TextStyle(color: Colors.red,fontSize: 21,fontWeight: FontWeight.bold),),
                        Text(show.rating['average'].toString(),style: TextStyle(color: Colors.white,fontSize: 21,fontWeight: FontWeight.bold),),
                      ],
                    ),
                  ),
                );
              },
            ),)
            ],
          ),
        ),
      ),
    );
  }
}
class CustomNavigationBar extends StatelessWidget {
  const CustomNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        backgroundColor: Colors.black54,
        items: [
          BottomNavigationBarItem(icon: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
              },
              child: Icon(Icons.home,color: Colors.red,)),
              label: 'home'),
          BottomNavigationBarItem(icon: InkWell(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchScreen()));
              },
              child: Icon(Icons.search,color: Colors.red,)),label: 'search'),
          BottomNavigationBarItem(icon: Icon(Icons.settings,color: Colors.red,),label: 'settings'),
        ]);
  }
}