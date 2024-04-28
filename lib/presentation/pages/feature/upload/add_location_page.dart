import 'package:flutter/material.dart';

class AddLocationPage extends StatefulWidget {
  const AddLocationPage({super.key});

  @override
  State<AddLocationPage> createState() => _AddLocationPageState();
}

class _AddLocationPageState extends State<AddLocationPage> {
  final locations = const [
    'United States',
    'France',
    'Australia',
    'Canada',
    'Brazil',
    'China',
    'Germany',
    'India',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        surfaceTintColor: Colors.transparent,
        shape: Border(bottom: BorderSide(width: 0.5, color: Theme.of(context).colorScheme.outlineVariant)),
        titleSpacing: 4.0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: TextField(
          decoration: InputDecoration(
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
}
