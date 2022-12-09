import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class baner extends StatefulWidget {
  @override
  _banerState createState() => _banerState();
}

class _banerState extends State<baner> {
  List data = [
    {
      "url":
          "https://www.amikompurwokerto.ac.id/images/slides/2021/_KonsepCarouselA.webp"
    },
    {
      "url":
          "https://www.amikompurwokerto.ac.id/images/slides/2021/_KonsepCarouselB.webp"
    },
    {
      "url":
          "https://www.amikompurwokerto.ac.id/images/slides/2021/_KonsepCarouselC.webp"
    },
  ];

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Center(
      child: Container(
        height: height * 0.2 ,
        width: width,
        color: Colors.purple.shade400,
        child: CarouselSlider.builder(
          options: CarouselOptions(autoPlay: true, viewportFraction: 1),
          itemCount: data.length,
          itemBuilder: (context, index, realindex) {
            return Image.network(
              data[index]['url'],
              fit: BoxFit.fill,
            );
          },
        ),
      ),
    );
  }
}
