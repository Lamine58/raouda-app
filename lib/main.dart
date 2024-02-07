import 'dart:async';
import 'package:raouda_collecte/auth/login.dart';
import 'package:raouda_collecte/dashboard/dashboard.dart';
import 'package:raouda_collecte/function/function.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const App());
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> with TickerProviderStateMixin{

  final _navigatorKey = GlobalKey<NavigatorState>();
  late AnimationController _controller;
  late Animation<double> _animation;

  _start() async {

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    
    if(prefs.getString('cutomerData')==null){
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) => Login())); 
    }else{
      _navigatorKey.currentState?.pushReplacement(MaterialPageRoute(builder: (context) =>const Dashboard()));
    }
  }

  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      _start();
    });

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: _navigatorKey,
      title: 'Raoudat Collecte',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // fontFamily: 'Toboggan',
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor()),
        useMaterial3: true,
      ),
      home:
        Container(
          color: Colors.white,
          child: Center(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo.png',width: 200),
                paddingTop(20),
                SizedBox(
                  width: 120,
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(50)),
                    child: 
                    AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return LinearProgressIndicator(
                          minHeight: 5,
                          backgroundColor: Color.fromARGB(82, 4, 67, 20),
                          valueColor: const AlwaysStoppedAnimation<Color>(Color(0xff044314)),
                          value: _animation.value,
                        );
                      },
                    ),
                  ),
                ),
              ],
            )
                ),
        )
    );

  }
}

