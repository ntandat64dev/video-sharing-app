import 'package:flutter/material.dart';

class SelectAudiencePage extends StatefulWidget {
  const SelectAudiencePage({
    super.key,
    required bool? madeForKids,
    required bool ageRestricted,
  })  : _madeForKids = madeForKids,
        _ageRestricted = ageRestricted;

  final bool? _madeForKids;
  final bool _ageRestricted;

  @override
  State<SelectAudiencePage> createState() => _SelectAudiencePageState();
}

const kMadeForKids = 'made_for_kids';
const kAgeRestricted = 'age_restricted';

enum MadeForKids { yes, no }

enum AgeRestricted { yes, no }

class _SelectAudiencePageState extends State<SelectAudiencePage> {
  late MadeForKids? madeForKids;
  late AgeRestricted? ageRestricted;

  @override
  void initState() {
    super.initState();
    madeForKids = (widget._madeForKids != null)
        ? widget._madeForKids!
            ? MadeForKids.yes
            : MadeForKids.no
        : null;
    ageRestricted = widget._ageRestricted ? AgeRestricted.yes : AgeRestricted.no;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Select Audience',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Is this video made for kid?',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      RadioListTile<MadeForKids>(
                        value: MadeForKids.yes,
                        groupValue: madeForKids,
                        onChanged: (MadeForKids? value) => setState(() {
                          madeForKids = value;
                          ageRestricted = AgeRestricted.no;
                        }),
                        title: const Text('Yes, it\'s made for kids'),
                      ),
                      RadioListTile<MadeForKids>(
                        value: MadeForKids.no,
                        groupValue: madeForKids,
                        onChanged: (MadeForKids? value) => setState(() => madeForKids = value),
                        title: const Text('No, it\'s not made for kids'),
                      ),
                      Divider(
                        thickness: 0.5,
                        indent: 16.0,
                        endIndent: 16.0,
                        color: Theme.of(context).colorScheme.outlineVariant,
                      ),
                      const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Do you want to restrict your video to an adult audience?',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                        ),
                      ),
                      RadioListTile<AgeRestricted>(
                        value: AgeRestricted.yes,
                        groupValue: ageRestricted,
                        onChanged: madeForKids == MadeForKids.yes
                            ? null
                            : (AgeRestricted? value) => setState(() => ageRestricted = value),
                        title: const Text('Yes, restrict my video to viewers over 18'),
                      ),
                      RadioListTile<AgeRestricted>(
                        value: AgeRestricted.no,
                        groupValue: ageRestricted,
                        onChanged: madeForKids == MadeForKids.yes
                            ? null
                            : (AgeRestricted? value) => setState(() => ageRestricted = value),
                        title: const Text('No, don\'t restrict my video to viewers over 18'),
                      ),
                    ],
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () {
                          final Map<String, bool> data = {
                            kMadeForKids: madeForKids == MadeForKids.yes,
                            kAgeRestricted: ageRestricted == AgeRestricted.yes,
                          };
                          Navigator.pop(context, data);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primary,
                          foregroundColor: Theme.of(context).colorScheme.onPrimary,
                          padding: const EdgeInsets.all(16.0),
                        ),
                        child: const Text('Apply'),
                      ),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
