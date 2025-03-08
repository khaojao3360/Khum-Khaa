import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class carosel_sliding extends StatefulWidget {
  const carosel_sliding({Key? key}) : super(key: key);
  @override
  _carosel_sliding createState() => _carosel_sliding();
}

class _carosel_sliding extends State<carosel_sliding> {
  int _current = 0;
  final List<String> imgList = [
    'assets/1.jpg',
    'assets/2.jpg',
    'assets/3.jpg',
    'assets/4.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
            decoration: BoxDecoration(
              color: const Color.fromARGB(255, 234, 234, 234),
              borderRadius: BorderRadius.all(Radius.circular(10))
            ),
            child: CarouselSlider(
              items: imgList.map((imagePath) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 234, 234, 234),
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                      child: Image.asset(
                        imagePath, 
                        fit: BoxFit.cover
                        ),
                    );
                  },
                );
              }).toList(),
              options: CarouselOptions(
                aspectRatio: 16/9,
                autoPlay: true,
                enlargeCenterPage: true,
                viewportFraction: 1,
                onPageChanged: (index, reason) => {
                  setState(() {
                    _current = index;
                  })},
                ),
              ),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: imgList.asMap().entries.map((entry){
                return GestureDetector(
                  onTap: () => setState(() {
                    _current = entry.key;
                  }),
                  child: Container(
                    width: 8.0,
                    height: 8.0,
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (_current == entry.key
                        ? const Color.fromARGB(255, 0, 0, 0)
                        : Colors.black).withOpacity(_current == entry.key ? 0.9 : 0.4),
                    ),
                  ),
                );
              }).toList(),
              ),
            ],
            )
        );
  }
}