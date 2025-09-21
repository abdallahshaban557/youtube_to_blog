import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'transcript_fetcher.dart';

Future<String> getTranscript(
  String videoUrl, {
  String languageCode = 'en',
}) async {
  final fetcher = YouTubeTranscriptFetcher();
  try {
    final captionXml = await fetcher.fetchCaptions(
      videoUrl,
      languageCode: languageCode,
    );
    final parsedCaptions = CaptionParser.parseXml(captionXml);

    if (parsedCaptions.isEmpty) {
      return 'Error: Transcript was found but contained no text.';
    }

    // Join the caption text together, separated by a space.
    return parsedCaptions.map((c) => c.text).join(' ');
  } on YouTubeTranscriptException catch (e) {
    return 'Error: $e';
  } catch (e) {
    return 'An unexpected error occurred: $e';
  } finally {
    fetcher.dispose();
  }
}

Future<String> generateBlogPost(String transcript, String systemPrompt) async {
  // 1. Get the API Key from the environment variables.
  final apiKey = Platform.environment['GEMINI_API_KEY'];
  if (apiKey == null || apiKey.isEmpty) {
    return 'Error: GEMINI_API_KEY environment variable not set.';
  }

  try {
    // 2. Create the generative model.
    final model = GenerativeModel(
      model: 'gemini-2.5-flash',
      apiKey: apiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 10000),
    );

    // 3. Combine the system prompt and transcript into a single prompt.
    final fullPrompt =
        '$systemPrompt\n\nHere is the transcript:\n\n$transcript';
    final prompt = [Content.text(fullPrompt)];

    // 4. Generate the content.
    final response = await model.generateContent(prompt);

    // 5. Return the generated text.
    return response.text ?? 'Error: No content was generated.';
  } catch (e) {
    return 'Error generating blog post: $e';
  }
}
