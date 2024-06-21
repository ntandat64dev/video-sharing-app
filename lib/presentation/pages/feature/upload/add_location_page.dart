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
      'New York, United States',
      'Paris, France',
      'Sydney, Australia',
      'Toronto, Canada',
      'São Paulo, Brazil',
      'Beijing, China',
      'Berlin, Germany',
      'Mumbai, India',
      'Ho Chi Minh City, Vietnam',
      'London, England',
      'Warsaw, Poland',
      'Moscow, Russia',
      'Bangkok, Thailand',
      'Kuala Lumpur, Malaysia',
      'Tokyo, Japan',
      'Rome, Italy',
      'Madrid, Spain',
      'Mexico City, Mexico',
      'Johannesburg, South Africa',
      'Cairo, Egypt',
      'Buenos Aires, Argentina',
      'Istanbul, Turkey',
      'Seoul, South Korea',
      'Jakarta, Indonesia',
      'Riyadh, Saudi Arabia',
      'Amsterdam, Netherlands',
      'Zurich, Switzerland',
      'Stockholm, Sweden',
      'Oslo, Norway',
      'Auckland, New Zealand',
      'Athens, Greece',
      'Brussels, Belgium',
      'Budapest, Hungary',
      'Copenhagen, Denmark',
      'Dubai, United Arab Emirates',
      'Dublin, Ireland',
      'Helsinki, Finland',
      'Hong Kong, Hong Kong',
      'Lisbon, Portugal',
      'Lima, Peru',
      'Manila, Philippines',
      'Nairobi, Kenya',
      'Prague, Czech Republic',
      'Santiago, Chile',
      'Singapore, Singapore',
      'Tehran, Iran',
      'Vienna, Austria',
      'Vancouver, Canada',
      'Zurich, Switzerland'
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
