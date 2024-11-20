import 'package:flutter/material.dart';

import 'dashboard_screen.dart';
import 'login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    //check if user is already logged in
    //if logged in, navigate to dashboard
    //else navigate to login screen
    Future.delayed(Duration(seconds: 5), () {
      openLogin();
    });
    super.initState();
  }

  void openDashboard() {
    Navigator.pushReplacement(context, MaterialPageRoute(
        builder: (context){
          return DashboardScreen();
        }));
  }

  void openLogin() {
    Navigator.push(context, MaterialPageRoute(
        builder: (context) {
          return LoginScreen();
        }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Splash Screen'),
      ),
    );
  }
}
