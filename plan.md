# YouTube to Blog Generator Plan

## 1. YouTube Transcript Fetching

- **Goal:** Obtain the transcript from a given YouTube video URL.
- **Method:** Utilize a custom transcript fetcher (`lib/transcript_fetcher.dart`) that interacts directly with YouTube's internal API. This approach provides more control and avoids external library dependencies for this critical step. I got the code from [here](https://github.com/Hexer10/youtube_explode_dart/issues/349#issuecomment-2965582545)

## 2. Gemini API Integration

- **Goal:** Connect to the Gemini API to process the transcript and generate content.
- **Method:** Use the `google_generative_ai` package for Dart. This will allow us to send prompts to the Gemini model and receive the generated blog post.

## 3. Core Logic - The "YouTuber"

- **Goal:** Create a central class or function that orchestrates the process.
- **Steps:**
    1.  Accept a YouTube URL as input.
    2.  Use the YouTube library to fetch the video's transcript.
    3.  Construct a prompt for Gemini, combining a user-defined system prompt with the fetched transcript.
    4.  Send the combined prompt to the Gemini API.
    5.  Receive the generated blog post as a response.

## 4. Command-Line Interface (CLI)

- **Goal:** Allow users to interact with the tool from the command line.
- **Method:** Use the `args` package to parse command-line arguments.
- **Arguments:**
    -   `--url` or `-u`: The YouTube video URL (required).
    -   `--prompt` or `-p`: A path to a file containing the system prompt (optional). If not provided, a default prompt will be used.
    -   `--output` or `-o`: The file path to save the generated blog post to (optional). If not provided, the output will be printed to the console.

## 5. Configuration and Setup

- **Goal:** Manage API keys and other configurations.
- **Method:**
    -   Require the user to provide their Gemini API key as an environment variable (e.g., `GEMINI_API_KEY`). This is a secure way to handle credentials.
    -   Provide clear instructions in the `README.md` on how to set up the environment variable.

## 6. Error Handling

- **Goal:** Gracefully handle potential issues.
- **Scenarios:**
    -   Invalid YouTube URL.
    -   Transcript not available for the video.
    -   API errors from Gemini.
    -   File system errors (e.g., when saving the output).
- **Method:** Implement `try-catch` blocks and provide clear, user-friendly error messages.

## 7. Project Structure

```
/
|-- bin/
|   |-- youtube_to_blog.dart  // Main executable
|-- lib/
|   |-- youtube_to_blog.dart  // Core logic
|   |-- transcript_fetcher.dart // Custom YouTube transcript fetcher
|-- test/
|   |-- youtube_to_blog_test.dart // Unit tests
|-- .gitignore
|-- analysis_options.yaml
|-- CHANGELOG.md
|-- pubspec.yaml
|-- README.md
|-- plan.md
```

## Implementation Steps

- [x] **Step 1: Set up Dependencies**
    - [x] Add `http`, `google_generative_ai`, and `args` to `pubspec.yaml`.
    - [x] Run `dart pub get`.

- [x] **Step 2: Fetch YouTube Transcript**
    - [x] Create a function in `lib/youtube_to_blog.dart` that takes a YouTube URL.
    - [x] Use the custom `YouTubeTranscriptFetcher` to get the transcript.
    - [x] Handle cases where a transcript is unavailable.

- [x] **Step 3: Implement Gemini Logic**
    - [x] Create a class or function to interact with the Gemini API.
    - [x] It should take the transcript and a system prompt as input.
    - [x] Use `google_generative_ai` to send the prompt and return the generated text.
    - [x] Load the Gemini API key from the `GEMINI_API_KEY` environment variable.
    - [x] add tests

- [ ] **Step 4: Build the CLI**
    - [ ] In `bin/youtube_to_blog.dart`, set up argument parsing using the `args` package.
    - [ ] Define the `--url`, `--prompt`, and `--output` arguments.
    - [ ] Read the system prompt from a file if the `--prompt` argument is provided, otherwise use a default.

- [ ] **Step 5: Orchestrate the Workflow**
    - [ ] In `bin/youtube_to_blog.dart`, connect the pieces:
        1.  Parse the command-line arguments.
        2.  Call the YouTube transcript fetcher.
        3.  Call the Gemini logic with the transcript and system prompt.
        4.  Handle the output: print to console or save to a file based on the `--output` argument.

- [ ] **Step 6: Add Error Handling and Polish**
    - [ ] Implement robust error handling for network issues, invalid inputs, and API errors.
    - [ ] Write clear usage instructions in the `README.md`.
    - [ ] Add comments to the code where necessary.

- [ ] **Step 7: Write Tests (Optional but Recommended)**
    - [ ] Create unit tests in `test/youtube_to_blog_test.dart`.
    - [ ] Mock the YouTube and Gemini API calls to test the core logic without making real network requests.