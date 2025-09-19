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
}