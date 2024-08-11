import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isBoySelected = false;
  bool isGirlSelected = false;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFE),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              Spacer(),
              Text(
                'Select the child gender',
                style: textTheme.titleLarge!.copyWith(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height:30),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isBoySelected = !isBoySelected;
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: isBoySelected ? const Color(0xFF68C9F2) : const Color(0xFFF5FAFE),
                        border: Border.all(
                          color: const Color(0xFF68C9F2),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SvgPicture.asset("assets/images/svgs/boy.svg"),
                    ),
                  ),
                  const SizedBox(width: 30),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isGirlSelected = !isGirlSelected;
                      });
                    },
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: isGirlSelected ? const Color(0xFF68C9F2) : const Color(0xFFF5FAFE),
                        border: Border.all(
                          color: const Color(0xFF68C9F2),
                        ),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: SvgPicture.asset("assets/images/svgs/girl.svg"),
                    ),
                  ),
                ],
              ),
              Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
