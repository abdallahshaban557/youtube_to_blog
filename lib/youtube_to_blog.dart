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
      generationConfig: GenerationConfig(maxOutputTokens: 8192),
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

Future<String> saveBlogPost(String content, String outputFilename) async {
  final outputDir = Directory('blog_posts');
  if (!await outputDir.exists()) {
    await outputDir.create(recursive: true);
  }

  // Create a timestamp
  final timestamp = DateTime.now()
      .toIso8601String()
      .replaceAll('-', '')
      .replaceAll(':', '')
      .split('.')
      .first;

  // Get the filename without the extension
  final baseName = outputFilename.contains('.')
      ? outputFilename.substring(0, outputFilename.lastIndexOf('.'))
      : outputFilename;

  // Get the extension, defaulting to .md
  final extension = outputFilename.contains('.')
      ? outputFilename.substring(outputFilename.lastIndexOf('.'))
      : '.md';

  final finalPath = '${outputDir.path}/${baseName}_$timestamp$extension';
  await File(finalPath).writeAsString(content);
  return finalPath;
}
