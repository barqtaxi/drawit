import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:iconsax/iconsax.dart';

class DisplayPictureScreen extends StatefulWidget {
  final String imagePath;

  const DisplayPictureScreen({
    super.key,
    required this.imagePath,
  });

  @override
  State<DisplayPictureScreen> createState() => _DisplayPictureScreenState();
}

class _DisplayPictureScreenState extends State<DisplayPictureScreen> {
  final apiKey = 'AIzaSyCz_r7q5BzN029RHxu5Ag-Moh4D1jfwdDs';
  final emotionsPrompt = '''
    You will play the role of a psychologist.
    Analyze this drawing, give me only insights into the child emotional state.
    ''';
  final personalityPrompt = '''
    You will play the role of a psychologist.
    Analyze this drawing, give me only insights into the child personality traits.
    ''';

  final  List<Color> _kDefaultRainbowColors = const [
    Colors.red,
    Colors.orange,
    Colors.yellow,
    Colors.green,
    Colors.blue,
    Colors.indigo,
    Colors.purple,
  ];
  String _analysis = '';
  bool _isLoading = true;

  Future<Uint8List> loadImage(String path) async {

    File file = File(path);
    return file.readAsBytesSync();
    /*
    final ByteData data = await rootBundle.load(path);
    return data.buffer.asUint8List();
    
     */
  }

  Future<String> _analyzeDrawing({ required String prompt}) async {
    final model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
    final prompts = [
      /*
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
       */
      TextPart(prompt),
    ];

    final firstImage = await loadImage(widget.imagePath);
    final imageParts = [
      DataPart('image/jpeg', firstImage),
    ];

    final response = await model.generateContent([
      Content.multi([...prompts, ...imageParts])
    ]);

    return response.text!;
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: Stack(
                children: [
                  Image.file(File(widget.imagePath)),
                  Center(
                    child: Visibility(
                      visible: _isLoading,
                      child: SizedBox(
                        height: 150,
                        child: LoadingIndicator(
                          indicatorType: Indicator.ballPulseRise,
                          colors: _kDefaultRainbowColors,
                          strokeWidth: 2,
                          backgroundColor: Colors.transparent,
                          pathBackgroundColor: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Colors.amber.shade50,
                        borderRadius: BorderRadius.circular(15)
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              const Icon(Iconsax.emoji_happy),
                              const SizedBox(width: 10),
                              Text(
                                'Emotions',
                                style: textTheme.headlineSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 30),
                          FutureBuilder(
                            future: _analyzeDrawing(prompt: emotionsPrompt),
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                final happinessAnalysis = snapshot.data;
                                return Text(
                                  happinessAnalysis!,
                                  style: textTheme.bodyLarge,
                                );
                              } else {
                                return const Center(child: CircularProgressIndicator());
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            const Icon(Iconsax.star),
                            const SizedBox(width: 10),
                            Text(
                              'Personality',
                              style: textTheme.headlineSmall,
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        FutureBuilder(
                          future: _analyzeDrawing(prompt: personalityPrompt),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              final confidenceAnalysis = snapshot.data;

                              return Text(
                                confidenceAnalysis!,
                                style: textTheme.bodyLarge,
                              );
                            } else {
                              return const Center(child: CircularProgressIndicator());
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
            const SizedBox(height: 30)
          ],
        ),
      ),
    );
  }
}
