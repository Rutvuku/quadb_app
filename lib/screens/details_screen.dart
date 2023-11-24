import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String name;
  final String summary;
  final String rating;
  final String imgurl;
  const DetailScreen({Key? key,required this.rating,required this.name,required this.imgurl,required this.summary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(38.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Image.network(
                  imgurl,
                  width: 250.0,
                  height:250.0,
                  fit: BoxFit.cover,
                ),
                Text(name,style: TextStyle(color: Colors.red,fontSize: 25,fontWeight: FontWeight.bold),),
                Text(rating,style: TextStyle(color: Colors.white,fontSize: 25,fontWeight: FontWeight.bold),),
                Text(summary,style: TextStyle(color: Colors.white,fontSize: 21,),),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
