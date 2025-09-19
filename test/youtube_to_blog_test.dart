import 'dart:io';
import 'package:youtube_to_blog/youtube_to_blog.dart';
import 'package:test/test.dart';

void main() {
  group('YouTube Transcript Fetching', () {
    test('should fetch transcript for a valid YouTube URL', () async {
      // This video has known English captions.
      final url = 'https://www.youtube.com/watch?v=Wr2crpug1j4';
      final transcript = await getTranscript(url);
      
      print('Fetched Transcript: $transcript');

      expect(transcript, isNotEmpty);
      expect(transcript, isNot(startsWith('Error')));
      // Check for a known phrase from the video.
      expect(transcript, contains('She just broke her leg.'));
    }, timeout: Timeout(Duration(seconds: 30)));

    test('should return an error for a video with no captions', () async {
      // This video is a simple animation with no speech.
      final url = 'https://www.youtube.com/watch?v=1-2_v-3-4-5'; // Example of a non-existent or captionless video
      final transcript = await getTranscript(url);
      
      print('Fetched Transcript for captionless video: $transcript');

      expect(transcript, startsWith('Error'));
    }, timeout: Timeout(Duration(seconds: 30)));
  });

  group('Gemini Blog Post Generation', () {
    setUpAll(() {
      // This check runs once before any tests in this group.
      // It makes the API key a mandatory prerequisite for the test suite.
      if (!Platform.environment.containsKey('GEMINI_API_KEY') || Platform.environment['GEMINI_API_KEY']!.isEmpty) {
        throw StateError(
            'FATAL: GEMINI_API_KEY environment variable not set. This is required for integration tests.');
      }
    });

    test('should generate a blog post from a transcript', () async {
      final transcript = 'This is a test transcript about the Dart programming language. Dart is fun.';
      final systemPrompt = 'You are a helpful assistant. Create a short blog post from the following transcript.';
      
      final result = await generateBlogPost(transcript, systemPrompt);

      print('Generated Blog Post: $result');

      expect(result, isNotEmpty);
      expect(result, isNot(startsWith('Error')));
      expect(result.toLowerCase(), contains('dart')); // Check if the topic is mentioned.
    }, timeout: Timeout(Duration(seconds: 60)));
  });
}