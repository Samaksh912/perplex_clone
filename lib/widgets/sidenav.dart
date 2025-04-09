import 'package:flutter/material.dart';
import 'package:untitled2/tools/colors.dart';
import 'package:untitled2/widgets/iconwidget.dart';

class sidebar extends StatefulWidget {
  const sidebar({super.key});

  @override
  State<sidebar> createState() => _sidebarState();
}

class _sidebarState extends State<sidebar> {
  bool iscollapsed = true;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      width: iscollapsed ? 55 : 128,
      color: AppColors.sideNav,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: iscollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20,),

            Container(
              margin: EdgeInsets.symmetric(horizontal: 18),
              child: Icon(Icons.auto_awesome_mosaic_rounded,
                color: Colors.white,
                size: 30,
              ),
            ),
            const SizedBox(height: 50,),
            iconbutton(iscollapsed: iscollapsed, icon: Icons.add, text: "Home"),

            iconbutton(iscollapsed: iscollapsed, icon: Icons.search, text: "Search"),

            iconbutton(iscollapsed: iscollapsed, icon: Icons.language, text: "Language"),

            iconbutton(iscollapsed: iscollapsed, icon: Icons.auto_awesome, text: "Discover"),

            iconbutton(iscollapsed: iscollapsed, icon: Icons.cloud_outlined, text: "Library"),
            const Spacer(),
            GestureDetector(
              onTap: (){
                setState(() {
                  iscollapsed = !iscollapsed;
                });
              },
              child: Container(
                margin: EdgeInsets.symmetric(vertical: 35,horizontal: 25),
                child:
                Icon(iscollapsed? Icons.keyboard_arrow_right : Icons.keyboard_arrow_left,
                  color: AppColors.iconGrey,
                  size: 25,
                ),

              ),
            )
          ],
        ),
      ),

    );
  }
}
