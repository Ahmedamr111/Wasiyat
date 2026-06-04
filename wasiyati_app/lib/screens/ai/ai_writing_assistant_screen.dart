import 'package:flutter/material.dart';
import '../../config/theme.dart';

/// AI Writing Assistant — helps compose heartfelt legacy messages
class AIWritingAssistantScreen extends StatefulWidget {
  final VoidCallback onBack;
  final Function(String content) onUseContent;

  const AIWritingAssistantScreen({
    super.key,
    required this.onBack,
    required this.onUseContent,
  });

  @override
  State<AIWritingAssistantScreen> createState() =>
      _AIWritingAssistantScreenState();
}

class _AIWritingAssistantScreenState extends State<AIWritingAssistantScreen> {
  final _promptController = TextEditingController();
  bool _isGenerating = false;
  String? _generatedContent;
  String _selectedTone = 'Warm & Loving';
  String _selectedType = 'Letter to child';

  static const _tones = [
    'Warm & Loving',
    'Formal & Dignified',
    'Spiritual & Islamic',
    'Poetic & Literary',
    'Simple & Direct',
  ];

  static const _messageTypes = [
    'Letter to child',
    'Letter to spouse',
    'Letter to parent',
    'Final wishes',
    'Life advice',
    'Apology & Forgiveness',
    'Gratitude letter',
  ];

  // Mock generated content based on type
  static const _mockContent = {
    'Letter to child':
        'My dearest child,\n\nBy the time you read these words, I will have returned to my Lord — and know that I carry nothing but gratitude and love for every moment we shared.\n\nYou were my greatest gift. Watching you grow, stumble, and rise again has been the privilege of my life. I have not always had the right words, but my heart was always with you.\n\nRemember that you are enough. You were always enough.\n\nDo not mourn too long. Grieve, yes — but then live. Live fully, love deeply, and be kind beyond what feels possible. That is the legacy I hope to leave in you.\n\nWith all my love, now and beyond,\n\nYour parent 🕊️',
    'Letter to spouse':
        'My love,\n\nIf you are reading this, know that you were the best part of every chapter of my life. The morning tea, the quiet evenings, the way you laughed at your own jokes — I would choose it all again, a thousand times.\n\nThank you for being my home.\n\nLive well. Let yourself be happy again. You deserve every beautiful thing.\n\nAlways yours,\n🕯️',
    'Final wishes':
        'بسم الله الرحمن الرحيم\n\nThese are my final wishes, written in full clarity of mind and peace of heart.\n\nI ask that my affairs be handled with simplicity and dignity. Please give from what I leave to those who are in need — it will be sadaqah jariyah that reaches me, inshAllah.\n\nForgive those who wronged me, as I forgive them. Hold no grudges in my name.\n\nMay Allah have mercy on my soul and unite us all in Jannatul Firdaus.\n\nآمين',
    'Life advice':
        'To whoever reads this,\n\nIf I could give you one piece of wisdom distilled from a lifetime:\n\nChoose people over things. Choose presence over productivity. Choose kindness over being right.\n\nPray — not because it will fix everything, but because it will fix you.\n\nAnd when life breaks your heart, know that broken things let the light in.\n\nWith love and hope,\n✍️',
  };

  Future<void> _generate() async {
    if (_isGenerating) return;
    setState(() {
      _isGenerating = true;
      _generatedContent = null;
    });

    // Simulate AI generation delay
    await Future.delayed(const Duration(milliseconds: 2200));

    if (!mounted) return;

    // Pick mock content based on type, fall back to first
    final content = _mockContent[_selectedType] ??
        _mockContent['Letter to child']!;

    setState(() {
      _isGenerating = false;
      _generatedContent = content;
    });
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      appBar: AppBar(
        backgroundColor: WasiyatiColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_rounded),
          color: WasiyatiColors.charcoal,
          onPressed: widget.onBack,
        ),
        title: Row(
          children: [
            Text('✨', style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text('AI Writing Assistant',
                style: WasiyatiTypography.headlineSmall),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Intro card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    WasiyatiColors.softAmber.withValues(alpha: 0.08),
                    WasiyatiColors.deepRose.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(color: WasiyatiColors.cardBorder),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('🤖', style: TextStyle(fontSize: 28)),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Wasiyati AI', style: WasiyatiTypography.labelLarge),
                        const SizedBox(height: 4),
                        Text(
                          'I\'ll help you write a heartfelt, dignified message. You guide the tone — I\'ll find the words.',
                          style: WasiyatiTypography.bodySmall
                              .copyWith(height: 1.5),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Message type selector
            Text('MESSAGE TYPE', style: WasiyatiTypography.overline),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _messageTypes.map((t) {
                final isSelected = _selectedType == t;
                return GestureDetector(
                  onTap: () => setState(() {
                    _selectedType = t;
                    _generatedContent = null;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? WasiyatiColors.primaryGradient
                          : null,
                      color: isSelected ? null : Colors.white,
                      borderRadius:
                          BorderRadius.circular(WasiyatiRadius.pill),
                      border: isSelected
                          ? null
                          : Border.all(color: WasiyatiColors.cardBorder),
                      boxShadow:
                          isSelected ? WasiyatiColors.buttonShadow : null,
                    ),
                    child: Text(
                      t,
                      style: TextStyle(
                        fontFamily: WasiyatiTypography.bodyFont,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isSelected
                            ? Colors.white
                            : WasiyatiColors.warmTaupe,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 24),

            // Tone selector
            Text('TONE', style: WasiyatiTypography.overline),
            const SizedBox(height: 10),
            SizedBox(
              height: 40,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: _tones.length,
                separatorBuilder: (_, i) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final t = _tones[i];
                  final isSelected = _selectedTone == t;
                  return GestureDetector(
                    onTap: () => setState(() {
                      _selectedTone = t;
                      _generatedContent = null;
                    }),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? WasiyatiColors.deepRose
                            : Colors.white,
                        borderRadius:
                            BorderRadius.circular(WasiyatiRadius.pill),
                        border: Border.all(
                          color: isSelected
                              ? WasiyatiColors.deepRose
                              : WasiyatiColors.cardBorder,
                        ),
                      ),
                      child: Text(
                        t,
                        style: TextStyle(
                          fontFamily: WasiyatiTypography.bodyFont,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : WasiyatiColors.warmTaupe,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),

            // Additional context
            Text('ADDITIONAL CONTEXT (optional)',
                style: WasiyatiTypography.overline),
            const SizedBox(height: 10),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                border: Border.all(color: WasiyatiColors.inputBorder),
              ),
              child: TextField(
                controller: _promptController,
                maxLines: 3,
                style: WasiyatiTypography.bodyMedium,
                decoration: InputDecoration(
                  hintText:
                      'e.g. "Focus on my love for travel and how it shaped me..."',
                  hintStyle: WasiyatiTypography.bodySmall
                      .copyWith(color: WasiyatiColors.muted),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.all(16),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Generate button
            GestureDetector(
              onTap: _isGenerating ? null : _generate,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16),
                decoration: BoxDecoration(
                  gradient: _isGenerating
                      ? null
                      : WasiyatiColors.primaryGradient,
                  color: _isGenerating
                      ? WasiyatiColors.warmTaupe.withValues(alpha: 0.15)
                      : null,
                  borderRadius: BorderRadius.circular(WasiyatiRadius.pill),
                  boxShadow:
                      _isGenerating ? [] : WasiyatiColors.buttonShadow,
                ),
                child: Center(
                  child: _isGenerating
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(
                                color: WasiyatiColors.deepRose,
                                strokeWidth: 2,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Crafting your message...',
                              style: TextStyle(
                                fontFamily: WasiyatiTypography.bodyFont,
                                fontSize: 14,
                                color: WasiyatiColors.deepRose,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          '✨  Generate Message',
                          style: WasiyatiTypography.labelLarge
                              .copyWith(color: Colors.white),
                        ),
                ),
              ),
            ),

            // Generated content
            if (_generatedContent != null) ...[
              const SizedBox(height: 28),
              Text('GENERATED MESSAGE', style: WasiyatiTypography.overline),
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: WasiyatiColors.parchmentGradient,
                  borderRadius: BorderRadius.circular(WasiyatiRadius.xl),
                  border: Border.all(
                    color: WasiyatiColors.softAmber.withValues(alpha: 0.3),
                  ),
                  boxShadow: WasiyatiColors.cardShadow,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _generatedContent!,
                      style: WasiyatiTypography.editorContent
                          .copyWith(height: 1.8),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() {
                              _generatedContent = null;
                              _generate();
                            }),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.6),
                                borderRadius: BorderRadius.circular(
                                    WasiyatiRadius.xl),
                                border: Border.all(
                                    color: WasiyatiColors.cardBorder),
                              ),
                              child: Center(
                                child: Text(
                                  '🔄 Regenerate',
                                  style: WasiyatiTypography.labelSmall,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () =>
                                widget.onUseContent(_generatedContent!),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12),
                              decoration: BoxDecoration(
                                gradient: WasiyatiColors.primaryGradient,
                                borderRadius: BorderRadius.circular(
                                    WasiyatiRadius.xl),
                                boxShadow: WasiyatiColors.buttonShadow,
                              ),
                              child: Center(
                                child: Text(
                                  '✓ Use This',
                                  style: WasiyatiTypography.labelSmall
                                      .copyWith(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: WasiyatiColors.goldenHour.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(WasiyatiRadius.md),
                  border: Border.all(
                    color: WasiyatiColors.goldenHour.withValues(alpha: 0.2),
                  ),
                ),
                child: Row(
                  children: [
                    const Text('💡', style: TextStyle(fontSize: 14)),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is AI-generated. Review and personalize before using.',
                        style: WasiyatiTypography.caption
                            .copyWith(height: 1.4),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 40),
            ],
          ],
        ),
      ),
    );
  }
}
