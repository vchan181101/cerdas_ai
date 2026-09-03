import 'package:flutter/material.dart';

extension WidgetExtension on Widget {
  Widget paddingAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
        padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this,
      );

  Widget get center => Center(child: this);

  Widget visible(bool visible, {Widget? fallback}) {
    return visible ? this : (fallback ?? const SizedBox.shrink());
  }

  Widget cornerRadius(double radius) => ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: this,
      );

  Widget expanded({int flex = 1}) => Expanded(
        flex: flex,
        child: this,
      );
}
