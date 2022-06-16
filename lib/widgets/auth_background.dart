import 'package:flutter/material.dart';

class AuthBackground extends StatelessWidget {
  const AuthBackground({Key? key, required this.child}) : super(key: key);

  final Widget child;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Stack(
        children: [
          const _PurpleBox(),
          const _HeaderIcon(),
          child
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(top: 30),
        height: 200,
        child: const Icon(Icons.person_pin, size: 100, color: Colors.white),
      ),
    );
  }
}

class _PurpleBox extends StatelessWidget {
  const _PurpleBox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: double.infinity,
      height: size.height * 0.4,
      decoration: _BuildBoxDecoration(),
      child: Stack(
        children: const [
          Positioned(child: _Bubble(), bottom: 40, right: -30),
          Positioned(child: _Bubble(), bottom: -40, left: 20),
          Positioned(child: _Bubble(), top: 30, right: 30),
          Positioned(child: _Bubble(), top: 10, left: -30),
        ],
      ),
    );
  }

  BoxDecoration _BuildBoxDecoration() => const BoxDecoration(
          gradient: LinearGradient(colors: [
        Color.fromRGBO(63, 63, 156, 1),
        Color.fromRGBO(90, 70, 178, 1)
      ]));
}

class _Bubble extends StatelessWidget {
  const _Bubble({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: const Color.fromRGBO(255, 255, 255, .05)),
    );
  }
}
