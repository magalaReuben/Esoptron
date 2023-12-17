import 'dart:developer';

import 'package:awesome_icons/awesome_icons.dart';
import 'package:esoptron_salon/constants/constants.dart';
import 'package:esoptron_salon/constants/size_config.dart';
import 'package:esoptron_salon/widgets/app_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ignore: must_be_immutable
class BottomNavWidget extends ConsumerStatefulWidget {
  const BottomNavWidget({
    super.key,
    required this.onChange,
    required this.currentIndex,
    required this.isCustomer,
  });
  final ValueChanged<int> onChange;
  final int currentIndex;
  final bool isCustomer;

  @override
  ConsumerState<BottomNavWidget> createState() => _BottomNavWidgetState();
}

class _BottomNavWidgetState extends ConsumerState<BottomNavWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        width: MediaQuery.of(context).size.width,
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
              height: 1,
              width: MediaQuery.of(context).size.width,
              color: Colors.white.withOpacity(0.8)),
          Padding(
            padding: EdgeInsets.all(getProportionateScreenWidth(2)),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: () => widget.onChange(0),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenWidth(5)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FontAwesomeIcons.home,
                              size: 25,
                              color: widget.currentIndex == 0
                                  ? kPrimaryColor
                                  : Colors.black.withOpacity(0.5),
                            ),
                            AppText.small(
                              'Home',
                              fontSize: 13,
                              color: widget.currentIndex == 0
                                  ? kPrimaryColor
                                  : Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: InkWell(
                      onTap: () => widget.onChange(1),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            vertical: getProportionateScreenWidth(5)),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              FontAwesomeIcons.userClock,
                              size: 25,
                              color: widget.currentIndex == 1
                                  ? kPrimaryColor
                                  : Colors.black.withOpacity(0.5),
                            ),
                            AppText.small(
                              'Services',
                              fontSize: 13,
                              color: widget.currentIndex == 1
                                  ? kPrimaryColor
                                  : Colors.black.withOpacity(0.5),
                              fontWeight: FontWeight.w600,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  widget.isCustomer!
                      ? Expanded(
                          child: InkWell(
                              onTap: () => widget.onChange(2),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: getProportionateScreenWidth(5)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.car,
                                      size: 25,
                                      color: widget.currentIndex == 2
                                          ? kPrimaryColor
                                          : Colors.black.withOpacity(0.5),
                                    ),
                                    AppText.small(
                                      'Track',
                                      fontSize: 13,
                                      color: widget.currentIndex == 3
                                          ? kPrimaryColor
                                          : Colors.black.withOpacity(0.5),
                                      fontWeight: FontWeight.w600,
                                    )
                                  ],
                                ),
                              )))
                      : Expanded(
                          child: InkWell(
                              onTap: () => widget.onChange(2),
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    vertical: getProportionateScreenWidth(5)),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      FontAwesomeIcons.coins,
                                      size: 25,
                                      color: widget.currentIndex == 2
                                          ? kPrimaryColor
                                          : Colors.black.withOpacity(0.5),
                                    ),
                                    AppText.small(
                                      'Earn',
                                      fontSize: 13,
                                      color: widget.currentIndex == 3
                                          ? kPrimaryColor
                                          : Colors.black.withOpacity(0.5),
                                      fontWeight: FontWeight.w600,
                                    )
                                  ],
                                ),
                              ))),
                  Expanded(
                      child: InkWell(
                          onTap: () => widget.onChange(3),
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                vertical: getProportionateScreenWidth(5)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FontAwesomeIcons.user,
                                  size: 25,
                                  color: widget.currentIndex == 3
                                      ? kPrimaryColor
                                      : Colors.black.withOpacity(0.5),
                                ),
                                AppText.small(
                                  'Profile',
                                  fontSize: 13,
                                  color: widget.currentIndex == 4
                                      ? kPrimaryColor
                                      : Colors.black.withOpacity(0.5),
                                  fontWeight: FontWeight.w600,
                                )
                              ],
                            ),
                          )))
                ]),
          )
        ]));
  }
}
