/// AI Writing Assistant service — Claude API integration (Phase 3)
/// Helps users write heartfelt messages with tone control and translation
abstract class AIWritingService {
  /// Generate a message draft based on context
  Future<String> generateDraft({
    required String recipientName,
    required String relationship,
    required String occasion,
    required String tone,
    required String language,
    String? additionalContext,
  });

  /// Adjust the tone of an existing message
  Future<String> adjustTone({
    required String message,
    required String targetTone,
    required String language,
  });

  /// Translate a message to another language
  Future<String> translateMessage({
    required String message,
    required String fromLanguage,
    required String toLanguage,
  });

  /// Summarize all messages for review
  Future<String> summarizeMessages(List<String> messages);
}

class MockAIWritingService implements AIWritingService {
  @override
  Future<String> generateDraft({
    required String recipientName,
    required String relationship,
    required String occasion,
    required String tone,
    required String language,
    String? additionalContext,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    // Return mock drafts based on tone
    final toneMessages = {
      'loving': 'My dearest $recipientName,\n\n'
          'Every moment I spent with you was a gift I will cherish forever. '
          'You brought so much light and joy into my life.\n\n'
          'I want you to know that you are loved beyond measure. '
          'No matter what life brings, remember that someone loved you '
          'with their whole heart.\n\n'
          'With all my love.',
      'formal': 'Dear $recipientName,\n\n'
          'I am writing to express my deepest wishes for your continued '
          'well-being and success. It has been my privilege to know you.\n\n'
          'Please know that you have made a significant impact on my life, '
          'and I am grateful for every interaction we have shared.\n\n'
          'With sincere regards.',
      'casual': 'Hey $recipientName! 👋\n\n'
          'If you\'re reading this, well... I guess I\'m not around anymore. '
          'But don\'t be sad! I had an amazing life, and you were a huge part of it.\n\n'
          'Remember all the good times we had? Those memories are forever.\n\n'
          'Take care of yourself. And smile — that\'s what I\'d want.\n\n'
          'See you on the other side! ✌️',
      'poetic': 'Dear $recipientName,\n\n'
          'Like the stars that light the darkened sky,\n'
          'Your presence was my guiding light.\n'
          'Though seasons change and rivers flow,\n'
          'My love for you will always grow.\n\n'
          'In the garden of my memories,\n'
          'You bloom eternal, bright and free.\n'
          'These words I leave as seeds of hope,\n'
          'To help you heal, to help you cope.\n\n'
          'Forever yours.',
    };

    return toneMessages[tone] ?? toneMessages['loving']!;
  }

  @override
  Future<String> adjustTone({
    required String message,
    required String targetTone,
    required String language,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1000));
    // Mock: return original with a note
    return '[$targetTone version]\n\n$message';
  }

  @override
  Future<String> translateMessage({
    required String message,
    required String fromLanguage,
    required String toLanguage,
  }) async {
    await Future.delayed(const Duration(milliseconds: 1200));
    // Mock: return original with language note
    return '[Translated to $toLanguage]\n\n$message';
  }

  @override
  Future<String> summarizeMessages(List<String> messages) async {
    await Future.delayed(const Duration(milliseconds: 800));
    return 'You have ${messages.length} messages prepared for your loved ones. '
        'They cover themes of love, gratitude, and hope for the future.';
  }
}
