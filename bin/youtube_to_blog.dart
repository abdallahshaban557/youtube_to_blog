import 'dart:io';
import 'package:args/args.dart';
import 'package:youtube_to_blog/youtube_to_blog.dart';

const String defaultSystemPrompt =
    'You are an expert blogger. Create a comprehensive, engaging, and well-structured blog post from the following YouTube video transcript. Use clear headings, paragraphs, and bullet points where appropriate. The tone should be informative and slightly informal.';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('url',
        abbr: 'u', help: 'The URL of the YouTube video.', mandatory: true)
    ..addOption('prompt',
        abbr: 'p',
        help: 'A path to a markdown file (.md) containing the system prompt.')
    ..addOption('output',
        abbr: 'o', help: 'The path to save the generated blog post file.');

  try {
    final argResults = parser.parse(arguments);

    final url = argResults['url'] as String;
    final promptPath = argResults['prompt'] as String?;
    final outputPath = argResults['output'] as String?;

    // 1. Determine the system prompt
    print('Determining system prompt...');
    String systemPrompt;
    if (promptPath != null) {
      systemPrompt = await File(promptPath).readAsString();
    } else {
      systemPrompt = defaultSystemPrompt;
    }

    // 2. Fetch the transcript
    print('Fetching transcript for: $url');
    final transcript = await getTranscript(url);
    if (transcript.startsWith('Error:')) {
      print(transcript);
      exit(1);
    }
    print('Transcript fetched successfully.');

    // 3. Generate the blog post
    print('Generating blog post with Gemini...');
    final blogPost = await generateBlogPost(transcript, systemPrompt);
    if (blogPost.startsWith('Error:')) {
      print(blogPost);
      exit(1);
    }
    print('Blog post generated successfully.');

    // 4. Handle the output
    if (outputPath != null) {
      await File(outputPath).writeAsString(blogPost);
      print('Blog post saved to: $outputPath');
    } else {
      print('\n--- GENERATED BLOG POST ---\n');
      print(blogPost);
    }
    
  } on FormatException catch (e) {
    print('Error: ${e.message}');
    print(parser.usage);
    exit(1);
  } catch (e) {
    print('An unexpected error occurred: $e');
    exit(1);
  }
}
