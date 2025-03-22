import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class StoryIntermissionScreen extends StatefulWidget {
  final VoidCallback onContinue;

  const StoryIntermissionScreen({Key? key, required this.onContinue}) : super(key: key);

  @override
  _StoryIntermissionScreenState createState() => _StoryIntermissionScreenState();

  // State<StoryIntermissionScreen> createState() => _StoryIntermissionScreenState();
}

class _StoryIntermissionScreenState extends State<StoryIntermissionScreen> {
  PageController _pageController = PageController();
  int _currentIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _startSlideshow();
  }

  void _startSlideshow(){
    _timer = Timer.periodic(Duration(seconds: 3), (timer){
      if (_currentIndex < 9) {
        _currentIndex++;
        _pageController.animateToPage(
          _currentIndex, 
          duration: Duration(milliseconds: 500), 
          curve: Curves.easeInOut,
        );
      } else {
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose(){
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: 10,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index){
              return Image.asset(
                'assets/images/intermission/frame{index+1}.jpg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              );
            },
          ),

          if (_currentIndex == 9)
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ElevatedButton(
                  onPressed: widget.onContinue, 
                  child: Text("Continue"),
                ),
              )
            )
        ],
      ),
    );
  }
}