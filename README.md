# YouTube to Blog Post Generator

This is a command-line tool written in Dart that automatically generates a blog post from a YouTube video. It fetches the video's transcript, sends it to the Gemini AI model with a system prompt, and then outputs the generated content as a markdown file or to the console.

## Features

- Fetches transcripts from any public YouTube video.
- Uses the Gemini API to generate high-quality blog posts.
- Customizable system prompt to control the style and tone of the generated content.
- Output to a file or directly to the console.
- Robust error handling.

## Prerequisites

- [Dart SDK](https://dart.dev/get-dart) installed on your machine.
- A [Gemini API Key](https://aistudio.google.com/app/apikey).

## Setup

1.  **Clone the repository (or download the source code):**
    ```bash
    git clone <repository-url>
    cd youtube_to_blog
    ```

2.  **Install dependencies:**
    ```bash
    dart pub get
    ```

3.  **Set up your Gemini API Key:**
    You must set your Gemini API key as an environment variable named `GEMINI_API_KEY`.

    **macOS / Linux:**
    ```bash
    export GEMINI_API_KEY="YOUR_API_KEY_HERE"
    ```
    *(To make this permanent, add the line to your `~/.bashrc`, `~/.zshrc`, or shell configuration file.)*

    **Windows (Command Prompt):**
    ```bash
    setx GEMINI_API_KEY "YOUR_API_KEY_HERE"
    ```
    *(You may need to restart your terminal for the change to take effect.)*

## Usage

The tool is run from the command line using `dart run`.

### Command-Line Arguments

- `--url` (or `-u`): **(Required)** The full URL of the YouTube video.
- `--output` (or `-o`): (Optional) The file path to save the generated blog post (e.g., `my-post`). If omitted, the output will be printed to the console.
- `--prompt` (or `-p`): (Optional) The path to a text file containing a custom system prompt. If omitted, a default prompt for creating a blog post will be used.

### Examples

**1. Generate a blog post and print it to the console:**
```bash
dart run bin/youtube_to_blog.dart --url "https://www.youtube.com/watch?v=some_video_id"
```

**2. Generate a blog post and save it to a file:**
```bash
dart run bin/youtube_to_blog.dart -u "https://www.youtube.com/watch?v=some_video_id" -o "my_awesome_post"
```

**3. Generate a blog post using a custom prompt:**
First, create a file named `my_prompt.md` with your desired prompt, for example:
```
You are a technical writer. Create a step-by-step tutorial based on the provided transcript. Use code blocks and numbered lists.
```
Then, run the command:
```bash
dart run bin/youtube_to_blog.dart -u "https://www.youtube.com/watch?v=JTk2Exr7FO4" -p "my_prompt.md" -o "universal"
```