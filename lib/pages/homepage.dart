import 'package:flutter/material.dart';
import 'package:untitled2/services/chat_web_service.dart';
import 'package:untitled2/widgets/search.dart';
import 'package:untitled2/widgets/sidenav.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isFactCheckerSelected  = false;



  @override
  void initState() {
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Row(

        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          Column(

            children: [
              const SizedBox(height: 300,),
              Expanded(
                child: SingleChildScrollView( // 🔹 Enables scrolling
                  child: Column(
                    mainAxisSize: MainAxisSize.min, // 🔹 Prevents layout issues
                    children: [
                      Search(),

                      const SizedBox(height: 20), // 🔹 Spacer to avoid UI squeezing
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
