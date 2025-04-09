import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:untitled2/services/chat_web_service.dart';
import 'package:untitled2/tools/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class sources extends StatefulWidget {
  const sources({super.key});

  @override
  State<sources> createState() => _sourcesState();
}

class _sourcesState extends State<sources> {
  bool isloading = true;
  List searchResults = [
    {
      'title': 'Ind vs Aus Live Score 4th Test',
      'url':
      'https://www.moneycontrol.com/sports/cricket/ind-vs-aus-live-score-4th-test-shubman-gill-dropped-australia-win-toss-opt-to-bat-liveblog-12897631.html',
    },
    {
      'title': 'Ind vs Aus Live Boxing Day Test',
      'url':
      'https://timesofindia.indiatimes.com/sports/cricket/india-vs-australia-live-score-boxing-day-test-2024-ind-vs-aus-4th-test-day-1-live-streaming-online/liveblog/116663401.cms',
    },
    {
      'title': 'Ind vs Aus - 4 Australian Batters Score Half Centuries',
      'url':
      'https://economictimes.indiatimes.com/news/sports/ind-vs-aus-four-australian-batters-score-half-centuries-in-boxing-day-test-jasprit-bumrah-leads-indias-fightback/articleshow/116674365.cms',
    },
  ];

  @override
  void initState() {
    super.initState();

    ChatWebService().searchresultstream.listen((data) {
      print("🌐 Received search results:");
      print(data['data']);
      setState(() {
        searchResults = data['data'];
        isloading = false;
      });
    });
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    try {
      final bool launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        print("❌ Could not launch $url");
      }
    } catch (e) {
      print("🚨 Exception launching URL: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.source, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Sources",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),

        Skeletonizer(
          enabled: isloading,
          effect:  ShimmerEffect(
            baseColor:  Colors.grey.shade500,
            highlightColor: Colors.grey.shade100,
            duration: Duration(seconds: 1),
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: searchResults.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 per row
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              childAspectRatio: 3 / 2,
            ),
            itemBuilder: (context, index) {
              final res = searchResults[index];
              return InkWell(
                onTap: () => _launchURL(res['url']),
                child: Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.cardColor,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        res['title'],
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 5),
                      Text(
                        res['url'],
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}
