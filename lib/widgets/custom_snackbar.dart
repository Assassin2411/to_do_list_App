import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class CustomSnackbar extends StatelessWidget {
  const CustomSnackbar(
      {super.key, required this.heading, required this.content});

  final String heading;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          padding: const EdgeInsets.all(16.0),
          height: 90,
          decoration: const BoxDecoration(
              color: Color(0xffc72c41),
              borderRadius: BorderRadius.all(Radius.circular(20.0))),
          child: Row(
            children: [
              const SizedBox(
                width: 48,
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      heading,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Text(
                      content,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 0,
          child: ClipRRect(
            borderRadius:
                const BorderRadius.only(bottomLeft: Radius.circular(20.0)),
            child: SvgPicture.asset(
              'assets/images/svgs/bubbles.svg',
              height: 48,
              width: 40,
              color: const Color(0xff801336),
            ),
          ),
        ),
        Positioned(
          top: -10.0,
          left: 0,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SvgPicture.asset(
                'assets/images/svgs/fail.svg',
                height: 40,
              ),
              Positioned(
                top: 10.0,
                child: SvgPicture.asset(
                  'assets/images/svgs/close.svg',
                  height: 16,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
