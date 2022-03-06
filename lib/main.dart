import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shop/bloc_observer.dart';
import 'package:shop/layout/screen/home_page.dart';
import 'package:shop/modules/login/bloc/cubit.dart';
import 'package:shop/modules/login/screen/login_screen.dart';
import 'package:shop/modules/on_boarding/screen.dart';
import 'package:shop/modules/register/bloc/cubit.dart';
import 'package:shop/modules/search/bloc/cubit.dart';
import 'package:shop/shared/components/constants.dart';
import 'package:shop/shared/network/local/local.dart';
import 'package:shop/shared/network/remote/dio.dart';

import 'layout/cubit/shop_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  bool onBoarding = CacheHelper.getData(key: 'onBoarding') ?? false;
  TOKEN = CacheHelper.getData(key: 'token') ?? 'noToken';

  Widget start;

  if (onBoarding == true) {
    if (TOKEN == 'noToken') {
      start = LoginScreen();
    } else {
      start = const HomePage();
    }
  } else {
    start = const OnBoarding();
  }

  await DioHelper.init();
  BlocOverrides.runZoned(
    () {
      runApp(Shop(
        startPage: start,
      ));
    },
    blocObserver: MyBlocObserver(),
  );
}

class Shop extends StatelessWidget {
  final Widget startPage;

  // this object has been created to handling primary swatch color
  final MaterialColor myColor = const MaterialColor(0xFF262626, <int, Color>{
    50: Color(0xFF262626),
    100: Color(0xFF262626),
    200: Color(0xFF262626),
    300: Color(0xFF262626),
    400: Color(0xFF262626),
    500: Color(0xFF262626),
    600: Color(0xFF262626),
    700: Color(0xFF262626),
    800: Color(0xFF262626),
    900: Color(0xFF262626),
  });

  const Shop({Key? key, required this.startPage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => ShopCubit()
              ..getHomeData()
              ..getCategoriesData()
              ..getFavorites()
              ..getUser()),
        BlocProvider(create: (context) => LoginCubit()),
        BlocProvider(create: (context) => RegisterCubit()),
        BlocProvider(create: (context) => SearchCubit()),
      ],
      child: MaterialApp(
        theme: ThemeData(
          appBarTheme: const AppBarTheme(
            color: Colors.white,
            titleTextStyle: TextStyle(
              color: Colors.black87,
              fontFamily: 'Rowdies',
              fontSize: 18,
              letterSpacing: 1.2,
            ),
            elevation: 0.0,
          ),
          scaffoldBackgroundColor: Colors.white,
          primarySwatch: myColor,
          bottomNavigationBarTheme: BottomNavigationBarThemeData(
            backgroundColor: Colors.white,
            unselectedItemColor: Colors.grey.shade700,
            selectedItemColor: Colors.deepOrangeAccent,
            elevation: 0.0,
          ),
          textTheme: const TextTheme(
            bodyText2: TextStyle(
              fontSize: 18,
              fontFamily: 'Ubuntu',
              color: Colors.black,
            ),
            bodyText1: TextStyle(
              fontSize: 16,
              fontFamily: 'Ubuntu',
              color: Colors.black,
            ),
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: AnimatedSplashScreen(
          duration: 3000,
          splash: 'assets/images/splash.png',
          nextScreen: startPage,
          splashTransition: SplashTransition.scaleTransition,
          centered: true,
          backgroundColor: Colors.white,
        ),
      ),
    );
  }
}
