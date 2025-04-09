import 'package:flutter/material.dart';
import 'package:untitled2/tools/colors.dart';
class searchbutton extends StatefulWidget {
  final IconData icon;
  final String text;
  const searchbutton({super.key, required this.icon, required this.text});

  @override
  State<searchbutton> createState() => _searchbuttonState();
}

class _searchbuttonState extends State<searchbutton> {
  bool istapped = false;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (event){
        setState(() {
          istapped = true;
        });
      },
      onTapUp: (event) {
        setState(() {
          istapped = false;
        });
      },

      child: AnimatedContainer(
        duration: Duration(milliseconds: 100),
        padding: EdgeInsets.symmetric(vertical: 4 ,horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular( 6),
          color: istapped ? AppColors.proButton : Colors.transparent,
        ),
        child: Row(
          children: [
            Icon(widget.icon,color: AppColors.iconGrey,size: 12,),
            const SizedBox(width: 5,),
            Text(widget.text,style: TextStyle(color: AppColors.textGrey),)
          ],
        ),
      ),
    );
  }
}
