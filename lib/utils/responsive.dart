/*+------------------------------------------------------------------------------+*/
/*|                            © 2024 Syed Ammar Ahmed                           |*/
/*+------------------------------------------------------------------------------+*/
/*+------------------------------------------------------------------------------+*/
/*| File: responsive.dart                                                        |*/
/*| Path: lib/utils/responsive.dart                                              |*/
/*| Author: Syed Ammar Ahmed                                                     |*/
/*| Content: Responsive Design                                                   |*/
/*| Output: Implement Responsive Design                                          |*/
/*| Description: Implement a responsive design for the application               |*/
/*+------------------------------------------------------------------------------+*/


import 'package:flutter/widgets.dart';

class Responsive {
  final BuildContext context;

  Responsive(this.context);

  // Width percentage
  double wp(double percent) {
    return MediaQuery.of(context).size.width * percent / 100;
  }

  // Height percentage
  double hp(double percent) {
    return MediaQuery.of(context).size.height * percent / 100;
  }

  // Dynamic font size based on screen size
  double sp(double percent) {
    // Assuming a base size of 720px height for scaling
    double baseHeight = 720;
    return (MediaQuery.of(context).size.height / baseHeight) * percent;
  }

  // Text scaling factor for dynamic text
  TextScaler get textScaleFactor => MediaQuery.of(context).textScaler;

  bool isMobile() {
    return MediaQuery.of(context).size.width < 600;
  }

  bool isTablet() {
    return MediaQuery.of(context).size.width >= 600 && MediaQuery.of(context).size.width < 1200;
  }

  bool isDesktop() {
    return MediaQuery.of(context).size.width >= 1200;
  }
}
