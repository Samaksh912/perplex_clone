import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:untitled2/pages/chatpage.dart';
import 'package:untitled2/pages/factpage.dart'; // Import FactPage
import 'package:untitled2/services/chat_web_service.dart';
import 'package:untitled2/tools/colors.dart';
import 'package:untitled2/widgets/searchbutton.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final querycontroller = TextEditingController();
  bool isFactCheckerChecked = false;

  @override
  void dispose() {
    super.dispose();
    querycontroller.dispose();

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Think of Something!",
          style: GoogleFonts.ibmPlexMono(fontSize: 25, fontWeight: FontWeight.w400),
        ),
        const SizedBox(height: 32),
        Container(
          padding: EdgeInsets.all(8),
          width: 300,
          decoration: BoxDecoration(
            color: AppColors.searchBar,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.searchBarBorder, width: 1.5),
          ),
          child: Column(
            children: [
              TextField(
                controller: querycontroller,
                decoration: InputDecoration(
                  hintText: "  Search something...",
                  hintStyle: TextStyle(color: AppColors.textGrey, fontSize: 18),
                  border: InputBorder.none,
                  isDense: true,
                ),
              ),
              Row(
                children: [
                  // Fact Checker checkbox
                  Checkbox(
                    value: isFactCheckerChecked,
                    onChanged: (bool? value) {
                      setState(() {
                        isFactCheckerChecked = value!;
                      });
                    },
                  ),
                  Text("Fact Checker", style: TextStyle(fontSize: 16)),

                  const Spacer(),

                  GestureDetector(
                    onTap: () {
                      final query = querycontroller.text.trim();

                      // Check if query is non-empty
                      if (query.isEmpty) {
                        // If empty, show an error or handle as needed
                        return;
                      }

                      if (isFactCheckerChecked == true) {
                        // Connect to fact-checking WebSocket and send query
                        ChatWebService().connectFactcheck();
                        ChatWebService().sendFactcheckQuery(query);

                        // Navigate to Factpage
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Factpage()),
                        );
                      } else {
                        // Connect to chat WebSocket and send query
                        ChatWebService().connectChat(query);


                        // Navigate to Chatpage
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (context) => Chatpage(question: query)),
                        );
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: AppColors.submitButton,
                        borderRadius: BorderRadius.circular(40),
                      ),
                      child: Icon(
                        Icons.arrow_forward,
                        color: AppColors.background,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
}
