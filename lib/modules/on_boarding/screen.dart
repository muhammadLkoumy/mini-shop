import 'package:flutter/material.dart';
import 'package:shop/layout/screen/home_page.dart';
import 'package:shop/models/on_boarding.dart';
import 'package:shop/modules/login/screen/login_screen.dart';
import 'package:shop/modules/products/products_screen.dart';
import 'package:shop/shared/components/component.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/local/local.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnBoarding extends StatefulWidget {
  const OnBoarding({Key? key}) : super(key: key);

  @override
  _OnBoardingState createState() => _OnBoardingState();
}

class _OnBoardingState extends State<OnBoarding> {
  List<OnBoardingModel> screen = [
    OnBoardingModel(
      image: 'assets/images/first.png',
      title: 'Title Title Title 1',
      description: 'description description 1',
    ),
    OnBoardingModel(
      image: 'assets/images/second.png',
      title: 'Title Title Title 2',
      description: 'description description 2',
    ),
    OnBoardingModel(
      image: 'assets/images/third.png',
      title: 'Title Title Title 3',
      description: 'description description 3',
    ),
  ];

  var pageController = PageController();

  bool isLast = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            itemBuilder: (context, index) => _pages(screen[index]),
            itemCount: screen.length,
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            onPageChanged: (index) {
              if (index == screen.length - 1) {
                setState(() {
                  isLast = true;
                });
              } else {
                setState(() {
                  isLast = false;
                });
              }
            },
          ),
          Positioned(
            left: 32,
            bottom: MediaQuery.of(context).size.height * .1,
            child: SmoothPageIndicator(
              controller: pageController,
              count: screen.length,
              effect: const WormEffect(
                dotHeight: 16,
                dotWidth: 16,
                type: WormType.thin,
                activeDotColor: Colors.black87,
                // strokeWidth: 5,
              ),
            ),
          ),
          Positioned(
            bottom: MediaQuery.of(context).size.height * .08,
            right: 32,
            child: TextButton(
              child: Text(
                isLast ? 'skip'.toUpperCase() : 'Next'.toUpperCase(),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 18,
                  fontFamily: 'Rowdies',
                  letterSpacing: 1.2,
                ),
              ),
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all(Colors.black87),
                overlayColor: MaterialStateProperty.all(Colors.grey.shade300),
              ),
              onPressed: () {
                if (isLast) {
                  if (TOKEN == 'noToken') {
                    CacheHelper.setData(key: 'onBoarding', value: true).then((value) {
                      if(value){
                        navigateAndFinish(context, LoginScreen());
                      }
                    });
                  } else {
                    navigateAndFinish(context, const HomePage());
                  }
                }
                setState(() {
                  pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
                    curve: Curves.fastOutSlowIn,
                  );
                });
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _pages(OnBoardingModel model) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Stack(
        children: [
          Positioned(
            top: MediaQuery.of(context).size.height * .15,
            bottom: MediaQuery.of(context).size.height * .3,
            left: 10,
            right: 10,
            child: Image(
              height: 300,
              image: AssetImage(model.image),
              fit: BoxFit.contain,
            ),
          ),
          Transform.translate(
            offset: Offset(20, MediaQuery.of(context).size.height * .65),
            child: Text(
              model.title.toUpperCase(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Rowdies',
                letterSpacing: 1.2,
              ),
            ),
          ),
          Transform.translate(
            offset: Offset(20, MediaQuery.of(context).size.height * 0.70),
            child: Text(
              model.description,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
                fontFamily: 'Ubuntu',
                letterSpacing: 1.2,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
