import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../config/colors.dart';
import '../config/constants.dart';

class CustomButton extends StatelessWidget {
  String title;
  Color? color;
  Color? textColor;
  bool? isLoading;
  bool? hasShadow;
  Function() onClick;

  CustomButton(
      {super.key,
      required this.title,
      required this.onClick,
      this.color,
      this.textColor,
      this.isLoading = false,
      this.hasShadow = false});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isLoading! ? null : onClick,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(kBorderRadius)),
          color: color ?? AppColors.primaryDarkColor,
          boxShadow: [
            if (hasShadow!)
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(3, 3), // changes position of shadow
              ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            isLoading!
                ? const SpinKitThreeBounce(
                    color: Colors.black,
                    size: 29,
                  )
                : Text(
                    title,
                    style: TextStyle(
                        color: textColor ?? Colors.black,
                        fontSize: MediaQuery.of(context).size.height * .023,
                        fontWeight: FontWeight.w700),
                  ),
          ],
        ),
      ),
    );
  }
}
