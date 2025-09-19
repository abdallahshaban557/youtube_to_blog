import 'transcript_fetcher.dart';

Future<String> getTranscript(String videoUrl, {String languageCode = 'en'}) async {
  final fetcher = YouTubeTranscriptFetcher();
  try {
    final captionXml = await fetcher.fetchCaptions(videoUrl, languageCode: languageCode);
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