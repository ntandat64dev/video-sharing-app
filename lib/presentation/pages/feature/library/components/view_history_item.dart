import 'dart:math';

import 'package:flutter/material.dart';
import 'package:video_sharing_app/presentation/components/duration_chip.dart';
import 'package:video_sharing_app/presentation/components/sink_animated.dart';
import 'package:video_sharing_app/presentation/shared/asset.dart';

class ViewHistoryItem extends StatelessWidget {
  const ViewHistoryItem({super.key});

  @override
  Widget build(BuildContext context) {
    final testThumbnails = [
      Asset.thumnnail_1,
      Asset.thumnnail_2,
      Asset.thumnnail_3,
      Asset.thumnnail_4,
      Asset.thumnnail_5,
    ];
    return SinkAnimated(
      onTap: () {},
      child: SizedBox(
        width: 150.0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(16.0),
                  child: Image.asset(
                    testThumbnails[Random().nextInt(5)],
                    fit: BoxFit.cover,
                    height: 100,
                    width: double.infinity,
                  ),
                ),
                const DurationChip(isoDuration: 'PT24M12S'),
              ],
            ),
            const SizedBox(height: 6.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Expanded(
                      child: Column(
                        children: [
                          SizedBox(height: 2.0),
                          Text(
                            'International Music and Dance',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      customBorder: const CircleBorder(),
                      child: const Padding(
                        padding: EdgeInsets.all(4.0),
                        child: Icon(Icons.more_vert, size: 18.0),
                      ),
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 4.0),
                const Text(
                  'World of Music',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(fontSize: 13.0),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
