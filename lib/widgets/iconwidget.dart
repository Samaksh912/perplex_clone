import 'package:flutter/material.dart';

import '../tools/colors.dart';

class iconbutton extends StatelessWidget {
 final bool iscollapsed;
 final IconData icon;
 final String text;

  const iconbutton({super.key, required this.iscollapsed, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: iscollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [

        Container(
          margin: EdgeInsets.symmetric(horizontal: 14,vertical: 15),
          child: Icon(icon,
            color: AppColors.iconGrey,
            size: 25,
          ),
        ),
        iscollapsed ? const SizedBox() : Text(text,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold

          ),
        ),
      ],
    );
  }
}
