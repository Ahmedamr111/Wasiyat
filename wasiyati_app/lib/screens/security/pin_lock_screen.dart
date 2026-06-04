import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../config/theme.dart';
import '../../providers/security_provider.dart';

/// PIN lock / unlock dialog — shown when a message is PIN-protected
class PinLockScreen extends ConsumerStatefulWidget {
  final String title;
  final String subtitle;
  final bool isSetup; // true = create PIN, false = verify PIN
  final VoidCallback onSuccess;
  final VoidCallback onCancel;

  const PinLockScreen({
    super.key,
    this.title = 'Enter PIN',
    this.subtitle = 'Enter your 4-digit PIN to unlock',
    this.isSetup = false,
    required this.onSuccess,
    required this.onCancel,
  });

  @override
  ConsumerState<PinLockScreen> createState() => _PinLockScreenState();
}

class _PinLockScreenState extends ConsumerState<PinLockScreen>
    with SingleTickerProviderStateMixin {
  final List<String> _digits = [];
  String? _firstPin; // for setup/confirm flow
  bool _isConfirming = false;
  bool _hasError = false;
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _shakeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticOut),
    );

    if (!widget.isSetup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _triggerBiometric();
      });
    }
  }

  Future<void> _triggerBiometric() async {
    final state = ref.read(securityProvider);
    if (state.isBiometricEnabled) {
      final success = await ref
          .read(securityProvider.notifier)
          .authenticateBiometric('Unlock Wasiyati');
      if (success) {
        widget.onSuccess();
      }
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  void _onDigit(String d) {
    if (_digits.length >= 4) return;
    setState(() {
      _digits.add(d);
      _hasError = false;
    });
    if (_digits.length == 4) {
      Future.delayed(const Duration(milliseconds: 120), _checkPin);
    }
  }

  void _onDelete() {
    if (_digits.isEmpty) return;
    setState(() {
      _digits.removeLast();
      _hasError = false;
    });
  }

  void _checkPin() {
    final entered = _digits.join();

    if (widget.isSetup) {
      if (!_isConfirming) {
        // Store first entry, ask to confirm
        setState(() {
          _firstPin = entered;
          _isConfirming = true;
          _digits.clear();
        });
      } else {
        if (entered == _firstPin) {
          ref.read(securityProvider.notifier).enablePin(entered).then((_) {
            widget.onSuccess();
          });
        } else {
          _fail();
        }
      }
    } else {
      // Verify mode — check against real stored PIN
      final correct = ref.read(securityProvider.notifier).verifyPin(entered);
      if (correct) {
        ref.read(securityProvider.notifier).unlockVault();
        widget.onSuccess();
      } else {
        _fail();
      }
    }
  }

  void _fail() {
    setState(() {
      _hasError = true;
      _digits.clear();
    });
    _shakeController.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    final prompt = widget.isSetup
        ? (_isConfirming ? 'Confirm your new PIN' : 'Create a 4-digit PIN')
        : widget.subtitle;

    return Scaffold(
      backgroundColor: WasiyatiColors.background,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onCancel,
                    child: Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: WasiyatiColors.warmTaupe.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(WasiyatiRadius.md),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        color: WasiyatiColors.charcoal,
                        size: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const Spacer(flex: 2),

            // Candle icon + title
            const Text('🔐', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 16),
            Text(
              widget.isSetup
                  ? (_isConfirming ? 'Confirm PIN' : widget.title)
                  : widget.title,
              style: WasiyatiTypography.headlineLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              prompt,
              style: WasiyatiTypography.bodySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 36),

            // PIN dots with shake animation
            AnimatedBuilder(
              animation: _shakeAnimation,
              builder: (_, v) {
                final shake =
                    (_shakeAnimation.value * 8 * 2 * 3.1415).sin() * 10;
                return Transform.translate(
                  offset: Offset(shake, 0),
                  child: _PinDots(
                    filled: _digits.length,
                    hasError: _hasError,
                  ),
                );
              },
            ),

            // Error message
            AnimatedOpacity(
              opacity: _hasError ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 200),
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(
                  widget.isSetup
                      ? 'PINs don\'t match. Try again.'
                      : 'Incorrect PIN. Try again.',
                  style: TextStyle(
                    fontFamily: WasiyatiTypography.bodyFont,
                    fontSize: 13,
                    color: WasiyatiColors.error,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),

            const Spacer(flex: 2),

            // Numpad
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48),
              child: Column(
                children: [
                  _NumRow(digits: ['1', '2', '3'], onDigit: _onDigit),
                  const SizedBox(height: 16),
                  _NumRow(digits: ['4', '5', '6'], onDigit: _onDigit),
                  const SizedBox(height: 16),
                  _NumRow(digits: ['7', '8', '9'], onDigit: _onDigit),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Biometric trigger
                      _NumKey(
                        onTap: _triggerBiometric,
                        child: Icon(
                          Icons.fingerprint_rounded,
                          size: 26,
                          color: ref.watch(securityProvider).isBiometricEnabled
                              ? WasiyatiColors.deepRose
                              : WasiyatiColors.muted,
                        ),
                      ),
                      _NumKey(label: '0', onTap: () => _onDigit('0')),
                      _NumKey(
                        onTap: _onDelete,
                        onLongPress: () => setState(() => _digits.clear()),
                        child: const Icon(
                          Icons.backspace_outlined,
                          size: 22,
                          color: WasiyatiColors.charcoal,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 48),
          ],
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _PinDots extends StatelessWidget {
  final int filled;
  final bool hasError;

  const _PinDots({required this.filled, required this.hasError});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(4, (i) {
        final isFilled = i < filled;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          width: isFilled ? 18 : 16,
          height: isFilled ? 18 : 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: hasError
                ? WasiyatiColors.error
                : isFilled
                    ? WasiyatiColors.deepRose
                    : Colors.transparent,
            border: Border.all(
              color: hasError
                  ? WasiyatiColors.error
                  : isFilled
                      ? WasiyatiColors.deepRose
                      : WasiyatiColors.warmTaupe.withValues(alpha: 0.4),
              width: 2,
            ),
            boxShadow: isFilled && !hasError
                ? [
                    BoxShadow(
                      color: WasiyatiColors.deepRose.withValues(alpha: 0.3),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        );
      }),
    );
  }
}

class _NumRow extends StatelessWidget {
  final List<String> digits;
  final ValueChanged<String> onDigit;

  const _NumRow({required this.digits, required this.onDigit});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: digits
          .map((d) => _NumKey(label: d, onTap: () => onDigit(d)))
          .toList(),
    );
  }
}

class _NumKey extends StatefulWidget {
  final String? label;
  final Widget? child;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  const _NumKey({
    this.label,
    this.child,
    required this.onTap,
    this.onLongPress,
  });

  @override
  State<_NumKey> createState() => _NumKeyState();
}

class _NumKeyState extends State<_NumKey> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) => setState(() => _pressed = false),
      onTapCancel: () => setState(() => _pressed = false),
      onTap: widget.onTap,
      onLongPress: widget.onLongPress,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        width: 72,
        height: 72,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _pressed
              ? WasiyatiColors.deepRose.withValues(alpha: 0.1)
              : Colors.white,
          boxShadow: _pressed
              ? []
              : [
                  BoxShadow(
                    color: WasiyatiColors.warmTaupe.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Center(
          child: widget.label != null
              ? Text(
                  widget.label!,
                  style: TextStyle(
                    fontFamily: WasiyatiTypography.displayFont,
                    fontSize: 26,
                    fontWeight: FontWeight.w500,
                    color: WasiyatiColors.charcoal,
                  ),
                )
              : widget.child,
        ),
      ),
    );
  }
}

// Extension for sin
extension on double {
  double sin() {
    // dart:math is needed but we avoid importing it globally
    // Use a simple approximation that's good enough for shake
    // sin(x) ≈ x for small x, but for shake we just want oscillation
    // Use Taylor series approximation
    final x = this % (2 * 3.14159265358979);
    return x - (x * x * x) / 6 + (x * x * x * x * x) / 120;
  }
}
