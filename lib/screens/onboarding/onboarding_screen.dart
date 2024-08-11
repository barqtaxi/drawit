import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../take_picture_screen.dart';
import '../profile/profile_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {

  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount!.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);
      final User? user = userCredential.user;
      // Use the user object for further operations or navigate to a new screen.
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFE),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              SvgPicture.asset("assets/images/backgrounds/kids_background.svg"),
              const Spacer(),
              Text(
                'Art Meets Psychology',
                style: textTheme.headlineMedium!.copyWith(
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700
                ),
                textAlign: TextAlign.center,
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Merge the worlds of art and psychology as we guide you through the process of analyzing children\'s drawings',
                  style: textTheme.bodyLarge!.copyWith(
                    fontFamily: 'Quicksand',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const Spacer(),
              InkWell(
                onTap: () async {
                  await signInWithGoogle();
                  final cameras = await availableCameras();
                  final firstCamera = cameras.first;
                  await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          TakePictureScreen(camera: firstCamera),
                    ),
                    /*
                    MaterialPageRoute(builder: (context) => const ProfileScreen()),
                     */
                  );
                },
                child: Container(
                    height: 60,
                    width: 260,
                    decoration: BoxDecoration(
                      color: const Color(0xFF68C9F2),
                      borderRadius: BorderRadius.circular(30)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SvgPicture.asset('assets/images/svgs/google.svg', height: 20, width: 20,),
                        const SizedBox(width: 15),
                        Text(
                          'Continue with Google',
                          style: textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF5FAFE),
                          ),
                        ),
                      ],
                    )
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ),
      /*
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/backgrounds/drawing_background.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(40.0),
                topLeft: Radius.circular(40.0),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 9, sigmaY: 9),
                child: Container(
                  height: 230,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Color(0xFF2CB1C9).withOpacity(0.6),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(40.0),
                      topLeft: Radius.circular(40.0),
                    )
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 30),
                      Text(
                        'Explore Children\'s Drawings',
                        style: textTheme.headlineSmall!.copyWith(
                          color: const Color(0xFFF0F7F4),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Understand shapes and scribbles',
                        style: textTheme.titleMedium!.copyWith(
                          color: const Color(0xFFF0F7F4),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const SizedBox(height: 30),
                      InkWell(
                        onTap: () async {
                          await signInWithGoogle();
                          final cameras = await availableCameras();
                          final firstCamera = cameras.first;
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) =>
                                  TakePictureScreen(camera: firstCamera),
                            ),
                          );
                        },
                        child: Container(
                          height: 60,
                          width: 260,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF0F7F4),
                              borderRadius: BorderRadius.circular(30)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset('assets/images/svgs/google.svg', height: 20, width: 20,),
                              const SizedBox(width: 15),
                              Text(
                                'Continue with Google',
                                style: textTheme.titleMedium,
                              ),
                            ],
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),

       */
    );
  }
}
