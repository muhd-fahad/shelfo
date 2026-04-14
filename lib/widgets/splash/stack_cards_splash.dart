import 'package:flutter/material.dart';

class CardStacksSplash extends StatelessWidget {
  const CardStacksSplash({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.only(top: 70),
        decoration: ShapeDecoration(
          color: const Color(0x4C16A34A),
          shape: RoundedSuperellipseBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(30),
            ),
          ),
        ),
        child: Container(
          padding: EdgeInsets.only(top: 70),
          decoration: ShapeDecoration(
            color: const Color(0x7F16A34A),
            shape: RoundedSuperellipseBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(30),
              ),
            ),
          ),
          child: Container(
            padding: EdgeInsets.only(top: 70),
            decoration: ShapeDecoration(
              color: const Color(0xB216A34A),
              shape: RoundedSuperellipseBorder(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(30),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
