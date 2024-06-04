import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:video_sharing_app/presentation/components/app_bar_back_button.dart';
import 'package:video_sharing_app/presentation/components/custom_text_field.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  var locations = const <String>[];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        titleSpacing: 0.0,
        leading: appBarBackButton(context),
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: CustomTextField(
            onChanged: findLocation,
            hintText: AppLocalizations.of(context)!.findLocation,
            contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
            prefixIcon: const Icon(CupertinoIcons.search),
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: locations.length,
        itemBuilder: (context, index) {
          final location = locations[index];
          return InkWell(
            onTap: () {
              Navigator.pop(context, location);
            },
            child: ListTile(
              leading: Icon(
                Icons.location_pin,
                color: Theme.of(context).colorScheme.primary,
              ),
              title: Text(
                location,
                style: const TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  void findLocation(String keyword) {
    final data = [
      'United States',
      'France',
      'Australia',
      'Canada',
      'Brazil',
      'China',
      'Germany',
      'India',
      'Vietnam',
      'England',
      'Poland',
      'Russia',
      'Thailand',
      'Malaysia',
      'Japan',
    ];
    setState(() {
      if (keyword.isEmpty) {
        locations = [];
      } else {
        locations = data.where((e) => e.toLowerCase().contains(keyword.toLowerCase())).toList();
      }
    });
  }
}
