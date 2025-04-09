import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled2/services/chat_web_service.dart';

import '../tools/colors.dart';

class Answers extends StatefulWidget {
  const Answers({super.key});

  @override
  State<Answers> createState() => _AnswersState();
}

class _AnswersState extends State<Answers> {
  bool isloading = true;
  String fullresponse = '''
As of the end of Day 1 in the fourth Test match between India and Australia, the score stands at **Australia 311/6**. The match is being held at the Melbourne Cricket Ground (MCG) on December 26, 2024.

## Match Overview
- **Toss**: Australia won the toss and opted to bat first.
- **Top Performers**:
  - **Steve Smith** is currently unbeaten on **68 runs** from **111 balls**.
  - **Sam Konstas**, making his Test debut, scored a significant **60 runs** from **65 balls**, contributing to a strong start for Australia.
  - Other notable contributions include Usman Khawaja and Marnus Labuschagne, both adding valuable runs to the total.

''';
  @override
  void initState() {

    super.initState();
    ChatWebService().contentstream.listen((data){
      if(isloading){
        fullresponse = '';
      }
     setState(() {
       fullresponse += data['data'];
       isloading = false;
     });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        Skeletonizer(
          enabled: isloading,
          effect:  ShimmerEffect(
            baseColor:  Colors.grey.shade500,
            highlightColor: Colors.grey.shade100,
            duration: Duration(seconds: 1),
          ),
          child: MarkdownBody(data: fullresponse,
          shrinkWrap: true,
            styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
              codeblockDecoration:  BoxDecoration(
                color: AppColors.cardColor,
                borderRadius: BorderRadius.circular(10)
          
              ),
              code: const TextStyle(fontSize: 16)
            )),
        ),

      ],
    );
  }
}
