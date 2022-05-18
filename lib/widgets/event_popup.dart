import 'package:cached_network_image/cached_network_image.dart';
import 'package:event_app/constants/constants.dart';
import 'package:event_app/models/models.dart';
import 'package:event_app/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EventPopup extends StatelessWidget {
  final Point point;
  const EventPopup({Key? key, required this.point}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: point.opened,
      child: Stack(
        children: [
          Container(
            height: 100,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: accentColorOpaque),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: BackdropFilter(
                filter: imageFilter,
                child: Padding(
                  padding: standardPadding,
                  child: Row(
                    children: [
                      Expanded(
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(2),
                            child: CachedNetworkImage(
                              imageUrl: point.imageUrl,
                              fit: BoxFit.cover,
                              height: double.infinity,
                            )),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppText(
                              text: point.name,
                              fontWeight: bold,
                            ),
                            const SizedBox(height: 5),
                            IntrinsicHeight(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SvgPicture.asset(
                                    'assets/events/calendar.svg',
                                    height: 10,
                                  ),
                                  const SizedBox(width: 5),
                                  const AppText(text: '05/13/2022')
                                ],
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                SvgPicture.asset(
                                  'assets/events/clock.svg',
                                  height: 10,
                                ),
                                const SizedBox(width: 5),
                                const AppText(text: '16:37')
                              ],
                            ),
                            standardHeight,
                            AppText(text: point.description)
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
