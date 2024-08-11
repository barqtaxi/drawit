import 'dart:typed_data';
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'screens/take_picture_screen.dart';
import 'screens/onboarding/onboarding_screen.dart';
import 'screens/splash/splash_screen.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Drawit AI',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String _analysis = '';
  bool _isLoading = false;

  Future<Uint8List> loadImage(String path) async {
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
  }



  Future<void> _incrementCounter() async {
    const apiKey = 'AIzaSyCz_r7q5BzN029RHxu5Ag-Moh4D1jfwdDs';

    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);

    /*

    Observe the child's expression and body language as they draw the person figure. Look for signs of concentration, like furrowed brows or a focused gaze, balanced with an overall relaxed, engaged posture. Take note of any smiles, giggles, or other positive facial expressions that emerge while they work.

Examine the strokes and lines used to depict the person - are they confident and flowing, or tentative and jerky? Confident, expressive strokes can indicate the child is enjoying the process. Also consider the proportions and details they choose to include - does the person look lively and animated, or flat and lifeless? Vibrant, dynamic renderings often reflect the child's own sense of happiness and energy.

Pay attention to color choices as well. Bright, bold colors used generously throughout the drawing can signal the child is feeling upbeat. Conversely, muted tones or limited use of color may suggest a more subdued mood.

Overall, look for a combination of physical, emotional, and artistic cues that demonstrate the child is finding pleasure and fulfillment in drawing this person figure. Their happiness should shine through both in their actions and the final product.

      Analyze this kids drawing draw conclusions about their emotions, and personality.
      Observe the child's expression and body language as they draw the person figure.
      Give me a paragraph on the overall impression of the drawing analysis.
      Give me a paragraph on how to improve the child overall psychological state and personality based on the analysis.
     */

    /*

      Delve into the intricate details of this child's drawing,
      unraveling the hidden layers to unveil profound insights
      into their emotional landscape and unique personality traits.
      Explore how the choice of colors, shapes, and themes serves
      as a window into their inner world, offering a nuanced understanding
      of their feelings, desires, and individuality

     */
    final prompts = [
      TextPart('''
      Delve into the intricate details of this child's drawing,
      unraveling the hidden layers to unveil profound insights into their 
      emotional landscape and unique personality traits.
      Explore how the choice of colors, shapes, and themes serves as a windo 
      into their inner world, offering a nuanced understanding of their 
      feelings, desires, and individuality. Analyze the overall color scheme, 
      subject matter, composition, body elements, line quality, and overall 
      impression to identify a wide range of emotions and personality traits, 
      including happiness, sadness, anger, fear, surprise, disgust, confusion, 
      excitement, shyness, concentration, confidence, nervousness, frustration, 
      curiosity, boredom, determination, vulnerability, playfulness, anxiety, 
      and contemplation. Consider the age of the child, their individual 
      personality and artistic style, cultural context, 
      and the broader context of their life and circumstances. 
      This comprehensive analysis will provide a deeper understanding of the 
      child's emotional tapestry, fostering empathy and connection.
      '''),
    ];
    final firstImage = await loadImage('assets/images/2a/64.jpg');
    final imageParts = [
      DataPart('image/jpeg', firstImage),
    ];

    setState(() {
      _isLoading = true;
    });

    final response = await model.generateContent([
      Content.multi([...prompts, ...imageParts])
    ]);

    setState(() {
      _analysis = response.text!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: const Color(0xFF2CB1C9),
      appBar: null,
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.asset(
              'assets/images/drawing.png',
              width: 300,
            ),
            SizedBox(height: 30),
            const Text(
              'Explore Children\'s Drawings',
              style: TextStyle(
                color: Color(0xFFF0F7F4),
                fontSize: 26,
              ),
            ),
            const Text(
              'Uncover the meaning of shapes and scribbles',
              style: TextStyle(
                color: Color(0xFFF0F7F4),
                fontSize: 16,
              ),
            ),
            Visibility(
              visible: !_isLoading,
              child: Text(
              '$_analysis',
              style: Theme.of(context).textTheme.titleMedium,
            ),
              replacement: const CircularProgressIndicator(),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Visibility(
        visible: !_isLoading,
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: FloatingActionButton.extended(
            onPressed: () async {
              final cameras = await availableCameras();
              final firstCamera = cameras.first;

              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const SplashScreen(),
                ),
              );
              /*
              await Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      TakePictureScreen(camera: firstCamera),
                ),
              );

               */
            },
            label: Text('Continue with Google'),
          ),
        ),
      ),
    );
  }
}
