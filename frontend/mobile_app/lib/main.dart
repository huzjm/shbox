import 'package:flutter/material.dart';
import 'screens/main_screen.dart';


void main(){

  runApp(
    const SHBoxApp()
  );

}



class SHBoxApp extends StatelessWidget{

  const SHBoxApp({super.key});


  @override
  Widget build(BuildContext context){

    return MaterialApp(

      debugShowCheckedModeBanner:false,

      title:"SHBox",

      theme:
      ThemeData.dark(),

      home:
      const MainScreen(),

    );

  }

}