import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  const Background({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Color(0xFFFF8800)),
      width: MediaQuery.of(context).size.width,
      child: Center(
        child: Container(
          width: 800,
          decoration: const BoxDecoration(color: Color(0xFFFF8800)),
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.loose,
            children: [
              Positioned(
                left: 0,
                top: 0,
                child: Padding(
                  padding: const EdgeInsets.only(left: 12.0, top: 12.0),
                  child: SizedBox(
                      height: 100,
                      child: Image.asset('assets/tomato_timer.png',
                          fit: BoxFit.contain)),
                ),
              ),
              Positioned(
                top: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, right: 12.0),
                  child: SizedBox(
                      height: 100,
                      child:
                          Image.asset('assets/cup.png', fit: BoxFit.contain)),
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, right: 12.0),
                  child: SizedBox(
                      height: 250,
                      child: Opacity(
                        opacity: 0.5,
                        child: Image.asset(
                          'assets/leef1.png',
                          fit: BoxFit.contain,
                        ),
                      )),
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, right: 12.0),
                  child: SizedBox(
                      height: 150,
                      child: Opacity(
                        opacity: 0.3,
                        child: Image.asset(
                          'assets/leef2.png',
                          fit: BoxFit.contain,
                        ),
                      )),
                ),
              ),
              Positioned(
                top: 12.0,
                child: Padding(
                  padding: const EdgeInsets.only(top: 12.0, right: 12.0),
                  child: SizedBox(
                      height: 60,
                      child: Image.asset(
                        'assets/title.png',
                        fit: BoxFit.contain,
                      )),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
