import 'package:flutter/material.dart';

Widget appBarBackButton(BuildContext context) => IconButton(
      onPressed: () => Navigator.pop(context),
      icon: const Icon(Icons.arrow_back),
    );
