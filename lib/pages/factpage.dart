import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:untitled2/services/chat_web_service.dart';

class Factpage extends StatefulWidget {
  const Factpage({super.key});

  @override
  State<Factpage> createState() => _FactpageState();
}

class _FactpageState extends State<Factpage> {


  String reasoning = "Waiting for reasoning...";
  double percent = 50;
  String conclusion = "UNCERTAIN";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    ChatWebService().connectFactcheck();

    // Listen to WebSocket stream for fact-checking response
    ChatWebService().factcheckstream.listen((data) {
      if (data['type'] == 'factcheck_result') {
        final result = data['data'];

        double parsedPercent = 50;
        if (result['percentage'] is String) {
          parsedPercent = double.tryParse(result['percentage']) ?? 50;
        } else if (result['percentage'] is num) {
          parsedPercent = result['percentage'].toDouble();
        }



        setState(() {


          reasoning = result['reasoning'] ?? "No reasoning provided.";
          percent = parsedPercent;
          conclusion = result['verdict'] ?? "UNCERTAIN";
          isLoading = false;
        });
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${percent.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: percent > 50 ? Colors.green : Colors.red,
                      ),
                    ),

                    const SizedBox(width: 25,),

                    Text(conclusion,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),


                  ],
                ),
                const SizedBox(height: 24),
                Text(
                  "Truth Score",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                LinearPercentIndicator(
                  lineHeight: 12,
                  percent: percent/100,

                  linearGradient: const LinearGradient(colors: [Colors.red, Colors.green]),
                  backgroundColor: Colors.grey[300]!,
                  barRadius: const Radius.circular(4),
                ),
                const SizedBox(height: 16),
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16.0),
                    child: Text(
                      "Reason",
                      style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text(
                    reasoning,
                    style: const TextStyle(fontSize: 16, color: Colors.white70),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
