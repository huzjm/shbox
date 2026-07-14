import 'package:flutter/material.dart';

import 'chat_screen.dart';
import 'gallery_screen.dart';
import 'home_screen.dart';
import '../services/signalr_service.dart';


class MainScreen extends StatefulWidget {

  const MainScreen({super.key});


  @override
  State<MainScreen> createState()
      => _MainScreenState();

}



class _MainScreenState
extends State<MainScreen>{

  final SignalRService _signalR = SignalRService();
  int index = 0;

  final screens = [

    const ChatScreen(),

    const GalleryScreen(),

    const HomeScreen(),

  ];



  @override
  void initState() {
    super.initState();
    _signalR.connect();
  }

  @override
  Widget build(BuildContext context){

    return Scaffold(

      body:
      screens[index],



      bottomNavigationBar:

      NavigationBar(

        selectedIndex:index,


        onDestinationSelected:(value){

          setState(() {

            index=value;

          });

        },


        destinations:[


          NavigationDestination(

            icon:
            Icon(Icons.chat),

            label:"Chat",

          ),



          NavigationDestination(

            icon:
            Icon(Icons.photo),

            label:"Gallery",

          ),



          NavigationDestination(

            icon:
            Icon(Icons.home),

            label:"Home",

          ),


        ],

      ),

    );

  }

}