import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:quadb_app/screens/details_screen.dart';

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

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<void> fetchData() async {
    final response = await http.get(Uri.parse('https://api.tvmaze.com/search/shows?q=${searchController}'));
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
                color: Colors.black,
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
            Expanded(child: ListView.builder(
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
            ),)
            ],
          ),
        ),
      ),
    );
  }
}
// class AnimatedSearchBar extends StatefulWidget {
//   @override
//   _AnimatedSearchBarState createState() => _AnimatedSearchBarState();
// }
//
// class _AnimatedSearchBarState extends State<AnimatedSearchBar> {
//   bool _isSearchActive = false;
//   final _focusNode = FocusNode();
//
//   void _toggleSearch() {
//     setState(() {
//       _isSearchActive = !_isSearchActive;
//     });
//     if (!_isSearchActive) {
//       _focusNode.unfocus();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: _toggleSearch,
//       child: AnimatedContainer(
//         duration: Duration(milliseconds: 300),
//         width: _isSearchActive ? 200 : 40,
//         height: 40,
//         decoration: BoxDecoration(
//           color: Colors.black,
//           borderRadius: BorderRadius.circular(50),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.shade800,
//               offset: Offset(1.5, 1.5),
//               blurRadius: 3.0,
//             ),
//             BoxShadow(
//               color: Colors.grey.shade600,
//               offset: Offset(-1.5, -1.5),
//               blurRadius: 3.0,
//             ),
//           ],
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Padding(
//               padding: EdgeInsets.only(left: _isSearchActive ? 10 : 0),
//               child: Icon(Icons.search, color: Colors.white),
//             ),
//             _isSearchActive ? Expanded(child: Padding(
//               padding: EdgeInsets.only(right: 10),
//               child: TextField(
//                 autofocus: true,
//                 focusNode: _focusNode,
//                 style: TextStyle(color: Colors.white),
//                 decoration: InputDecoration(
//                   border: InputBorder.none,
//                   hintText: "Type to search...",
//                   hintStyle: TextStyle(color: Colors.white70),
//                 ),
//               ),
//             )) : Container(),
//           ],
//         ),
//       ),
//     );
//   }
// }