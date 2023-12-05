import 'package:flutter/material.dart';

class BackgroundContainerObscure extends StatelessWidget {
  final Widget child;

  const BackgroundContainerObscure({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff000000),
            Color(0xff614497),
            Color(0xff8b4497),
            Color(0xff97447a),
          ],
          stops: [0.25, 0.75, 0.87, 0.93],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}

class BackgroundContainerWhithe extends StatelessWidget {
  final Widget child;

  const BackgroundContainerWhithe({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xffc4c4c4), // Color más claro
            Color(0xffa3a3a3),
            Color(0xff7e7e7e),
            Color(0xff5b5b5b), // Color más claro
          ],
          stops: [0.25, 0.5, 0.75, 0.93], // Ajusta según sea necesario
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: child,
    );
  }
}
