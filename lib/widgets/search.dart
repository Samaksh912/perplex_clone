import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/pages/chatpage.dart';
import 'package:untitled2/services/chat_web_service.dart';
import 'package:untitled2/tools/colors.dart';
import 'package:untitled2/widgets/searchbutton.dart';

class search extends StatefulWidget {
  const search({super.key});

  @override
  State<search> createState() => _searchState();
}

class _searchState extends State<search> {
  final querycontroller = TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    querycontroller.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Think of Something!",
          style: GoogleFonts.ibmPlexMono(
            fontSize: 25,
            fontWeight: FontWeight.w400,
          ),
        ),
        const SizedBox(height: 32,),

        Container(
          padding: EdgeInsets.all(8),
          width: 300,
          decoration: BoxDecoration(color: AppColors.searchBar,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.searchBarBorder,width: 1.5)
          ),

          child: Column(
            children: [
              TextField(
                controller: querycontroller,
                decoration: InputDecoration(hintText: "  Search something...",hintStyle: TextStyle(color: AppColors.textGrey,fontSize: 18,),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
              Row(
                children: [
                  searchbutton(
                    icon: Icons.auto_awesome_rounded,
                    text: "Focus",
                  ),
                  const SizedBox(width: 12,),
                  searchbutton(
                    icon: Icons.add_circle_outline_outlined,
                    text: "Attach",
                  ),
                  const Spacer(),
                  GestureDetector(

                      onTap: (){
                        ChatWebService().chat(querycontroller.text.trim());
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) => Chatpage(question: querycontroller.text.trim())),);
                      },

                    child: Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(color: AppColors.submitButton,borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(Icons.arrow_forward,color: AppColors.background,size: 18,),
                    ),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
