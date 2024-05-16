import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
        toolbarHeight: 80.0,
        surfaceTintColor: Colors.transparent,
        titleSpacing: 4.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: TextField(
            onChanged: findLocation,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.findLocation,
              fillColor: Theme.of(context).colorScheme.onInverseSurface,
              filled: true,
              prefixIcon: const Icon(Icons.search),
              contentPadding: const EdgeInsets.all(8.0),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16.0),
                borderSide: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(30)),
              ),
            ),
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
