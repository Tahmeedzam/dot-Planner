import 'package:flutter/material.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.transparent,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {},
            child: Icon(
              Icons.menu_rounded,
              color: Theme.of(context).colorScheme.tertiary,
              size: 30,
            ),
          ),
          SizedBox(width: 8),
          Text(
            'Good Morning,',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 18,
              color: Theme.of(context).colorScheme.surfaceDim,
            ),
          ),
          Text(
            //todo: Change the name to user name
            'Tahmeed',
            style: TextStyle(
              fontFamily: 'InterBold',
              fontSize: 18,
              color: Theme.of(context).colorScheme.surfaceDim,
            ),
          ),
        ],
      ),
    );
  }
}
