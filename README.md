# smart_learn

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


AI-Powered Quiz & Learning App
Project Title:
SmartLearn – AI-Powered Quiz & Revision App
Objective:
Build a modern, responsive quiz and revision app where students can:
Take topic-based quizzes
See their performance analytics
Use AI to generate questions from notes
Use text-to-speech and speech-to-text for accessibility

Key Features to Implement:
User Authentication
Sign up / Sign in with Firebase
Google Sign-In
Topic-Based Quizzes
Display MCQs with timer per question
Questions fetched from Firebase Firestore or local JSON
Show correct answer and explanation after each quiz
AI Feature (Bonus/Advanced)
Use OpenAI API to generate quiz questions from given input text
Allow user to paste class notes and generate 5-10 questions
Speech-to-Text & Text-to-Speech
Use speech_to_text and flutter_tts packages
Allow users to speak their answers or hear questions aloud
Performance Analytics
Show weekly quiz results in chart using fl_chart
Breakdown by topic, percentage correct, time taken
Dark/Light Theme & Responsive UI
Works on phones, tablets using LayoutBuilder and MediaQuery
Local Notifications
Remind students to revise daily using flutter_local_notifications
Offline Support
Store last attempted quiz data locally using hive or shared_preferences
Tech Stack & Tools:
Flutter (latest stable version)
Firebase (Auth, Firestore)
OpenAI GPT API (for question generation – optional for intern)
Hive or SharedPreferences (local storage)
fl_chart, flutter_tts, speech_to_text packages
Learning Outcomes:
Real-world app architecture (MVVM or clean architecture)
Firebase integration
API consumption (OpenAI)
Accessibility and offline-first design
UI/UX best practices