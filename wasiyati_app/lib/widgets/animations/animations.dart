import 'package:flutter/material.dart';

/// Animated candle flame for splash screen
class CandleFlicker extends StatefulWidget {
  final double size;
  const CandleFlicker({super.key, this.size = 64});

  @override
  State<CandleFlicker> createState() => _CandleFlickerState();
}

class _CandleFlickerState extends State<CandleFlicker>
    with TickerProviderStateMixin {
  late final AnimationController _controller;
  late final AnimationController _glowController;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat(reverse: true);
    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    _glowController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_controller, _glowController]),
      builder: (context, child) {
        final scale = 1.0 + (_controller.value * 0.05);
        final rotation = (_controller.value - 0.5) * 0.04;
        final glowRadius = 15.0 + (_glowController.value * 15.0);
        final glowOpacity = 0.5 + (_glowController.value * 0.3);

        return Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFF2C46D).withValues(alpha: glowOpacity),
                blurRadius: glowRadius,
                spreadRadius: glowRadius * 0.3,
              ),
            ],
          ),
          child: Transform.scale(
            scale: scale,
            child: Transform.rotate(
              angle: rotation,
              child: Text(
                '🕯️',
                style: TextStyle(fontSize: widget.size),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Wax seal animation — scales in with a stamp effect when message is saved
class WaxSealAnimation extends StatefulWidget {
  final bool isVisible;
  final VoidCallback? onComplete;
  const WaxSealAnimation({super.key, this.isVisible = false, this.onComplete});

  @override
  State<WaxSealAnimation> createState() => _WaxSealAnimationState();
}

class _WaxSealAnimationState extends State<WaxSealAnimation>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotateAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.6, curve: Curves.elasticOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: -0.3, end: 0.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOut),
      ),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        widget.onComplete?.call();
      }
    });
  }

  @override
  void didUpdateWidget(WaxSealAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isVisible && !oldWidget.isVisible) {
      _controller.forward(from: 0);
    } else if (!widget.isVisible && oldWidget.isVisible) {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Transform.rotate(
            angle: _rotateAnimation.value,
            child: Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const RadialGradient(
                  colors: [Color(0xFFC4736A), Color(0xFF9B4F47)],
                ),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF9B4F47).withValues(alpha: 0.4),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                  BoxShadow(
                    color: Colors.white.withValues(alpha: 0.2),
                    blurRadius: 1,
                    offset: const Offset(0, -1),
                  ),
                ],
              ),
              child: const Center(
                child: Text('🕊️', style: TextStyle(fontSize: 22)),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Fade + slide transition for screen elements
class FadeSlideTransition extends StatefulWidget {
  final Widget child;
  final Duration delay;
  final Duration duration;
  final Offset beginOffset;

  const FadeSlideTransition({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 500),
    this.beginOffset = const Offset(0, 20),
  });

  @override
  State<FadeSlideTransition> createState() => _FadeSlideTransitionState();
}

class _FadeSlideTransitionState extends State<FadeSlideTransition>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: widget.beginOffset,
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: _slideAnimation.value,
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// Pulse glow for status indicators
class PulseGlow extends StatefulWidget {
  final Color color;
  final double size;
  final Widget? child;

  const PulseGlow({
    super.key,
    this.color = const Color(0xFF7DB87D),
    this.size = 6,
    this.child,
  });

  @override
  State<PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<PulseGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: widget.color,
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.4 + _controller.value * 0.3),
                blurRadius: 4 + _controller.value * 4,
              ),
            ],
          ),
          child: widget.child,
        );
      },
    );
  }
}
