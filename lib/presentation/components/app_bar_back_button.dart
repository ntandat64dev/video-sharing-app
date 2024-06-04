import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget appBarBackButton(BuildContext context) => IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(CupertinoIcons.arrow_left),
    );
