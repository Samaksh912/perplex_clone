import 'package:flutter/material.dart';
import 'package:untitled2/widgets/answers.dart';
import 'package:untitled2/widgets/sidenav.dart';
import 'package:untitled2/widgets/sources.dart';

class Chatpage extends StatelessWidget {
  final String question;
  const Chatpage({super.key, required this.question});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          //sidebar(),
          const SizedBox(width: 10,),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(

                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10,),
                    Text(question,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 24,),
                    sources(),
                    const SizedBox(height: 24,),
                    Answers(),
                  ],
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
}
