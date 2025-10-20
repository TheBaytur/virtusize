import 'dart:math' as math;

import 'package:flutter/material.dart';

List<TweenSequenceItem<Color?>> _buildColorSequence(List<Color> colors) {
  assert(colors.length >= 2, 'Provide at least two colors for animation.');
  final entries = <TweenSequenceItem<Color?>>[];
  for (var i = 0; i < colors.length; i++) {
    final begin = colors[i];
    final end = colors[(i + 1) % colors.length];
    entries.add(
      TweenSequenceItem<Color?>(
        tween: ColorTween(begin: begin, end: end),
        weight: 1,
      ),
    );
  }
  return entries;
}

class AnimatedGradientBackground extends StatefulWidget {
  const AnimatedGradientBackground({
    required this.child,
    super.key,
    this.colors = const [
      Color(0xFF4F46E5),
      Color(0xFF7C3AED),
      Color(0xFFEC4899),
      Color(0xFF38BDF8),
    ],
    this.duration = const Duration(seconds: 12),
    this.begin = Alignment.topLeft,
    this.end = Alignment.bottomRight,
    this.padding,
    this.borderRadius,
  });

  final Widget child;
  final List<Color> colors;
  final Duration duration;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;
  final EdgeInsetsGeometry? padding;
  final BorderRadius? borderRadius;

  @override
  State<AnimatedGradientBackground> createState() =>
      _AnimatedGradientBackgroundState();
}

class _AnimatedGradientBackgroundState
    extends State<AnimatedGradientBackground> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _firstColor;
  late Animation<Color?> _secondColor;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
    _configureAnimations();
  }

  @override
  void didUpdateWidget(covariant AnimatedGradientBackground oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.colors != widget.colors || oldWidget.duration != widget.duration) {
      _controller
        ..duration = widget.duration
        ..reset()
        ..repeat();
      _configureAnimations();
    }
  }

  void _configureAnimations() {
    _firstColor = TweenSequence<Color?>(_buildColorSequence(widget.colors)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    final shifted = [
      ...widget.colors.skip(1),
      widget.colors.first,
    ];
    _secondColor = TweenSequence<Color?>(_buildColorSequence(shifted)).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      builder: (_, child) {
        final decoration = BoxDecoration(
          gradient: LinearGradient(
            begin: widget.begin,
            end: widget.end,
            colors: [
              _firstColor.value ?? widget.colors.first,
              _secondColor.value ?? widget.colors.last,
            ],
          ),
          borderRadius: widget.borderRadius,
        );
        Widget content = Container(
          decoration: decoration,
          child: widget.padding != null
              ? Padding(padding: widget.padding!, child: child)
              : child,
        );
        if (widget.borderRadius != null) {
          content = ClipRRect(
            borderRadius: widget.borderRadius!,
            child: content,
          );
        }
        return content;
      },
      child: widget.child,
    );
  }
}

class AnimatedGradientText extends StatefulWidget {
  const AnimatedGradientText({
    required this.text,
    super.key,
    this.style,
    this.colors = const [
      Color(0xFFF472B6),
      Color(0xFF60A5FA),
      Color(0xFFFDE68A),
      Color(0xFFA78BFA),
    ],
    this.duration = const Duration(seconds: 6),
    this.textAlign = TextAlign.start,
  });

  final String text;
  final TextStyle? style;
  final List<Color> colors;
  final Duration duration;
  final TextAlign textAlign;

  @override
  State<AnimatedGradientText> createState() => _AnimatedGradientTextState();
}

class _AnimatedGradientTextState extends State<AnimatedGradientText>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant AnimatedGradientText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller
        ..duration = widget.duration
        ..reset()
        ..repeat();
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
      builder: (_, __) {
        final angle = _controller.value * 2 * math.pi;
        final gradient = LinearGradient(
          colors: widget.colors,
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          transform: GradientRotation(angle),
        );
        return ShaderMask(
          blendMode: BlendMode.srcIn,
          shaderCallback: (bounds) =>
              gradient.createShader(Offset.zero & bounds.size),
          child: Text(
            widget.text,
            style: widget.style ?? Theme.of(context).textTheme.bodyMedium,
            textAlign: widget.textAlign,
          ),
        );
      },
    );
  }
}

class AnimatedActionButton extends StatefulWidget {
  const AnimatedActionButton({
    required this.onPressed,
    required this.label,
    super.key,
    this.icon,
    this.loadingLabel,
    this.colors = const [
      Color(0xFF2563EB),
      Color(0xFFEC4899),
      Color(0xFFF59E0B),
      Color(0xFF10B981),
    ],
    this.duration = const Duration(seconds: 5),
    this.height = 48,
    this.padding = const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final Widget label;
  final Widget? icon;
  final Widget? loadingLabel;
  final List<Color> colors;
  final Duration duration;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool isLoading;

  @override
  State<AnimatedActionButton> createState() => _AnimatedActionButtonState();
}

class _AnimatedActionButtonState extends State<AnimatedActionButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _backgroundAnimation;
  late Animation<Color?> _hoverAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _configureAnimations();
  }

  @override
  void didUpdateWidget(covariant AnimatedActionButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration) {
      _controller
        ..duration = widget.duration
        ..reset()
        ..repeat(reverse: true);
    }
    if (oldWidget.colors != widget.colors) {
      _configureAnimations();
    }
  }

  void _configureAnimations() {
    _backgroundAnimation = TweenSequence<Color?>(_buildColorSequence(widget.colors))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    final reversed = widget.colors.reversed.toList();
    _hoverAnimation = TweenSequence<Color?>(_buildColorSequence(reversed))
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
    _scaleAnimation = Tween<double>(begin: 0.97, end: 1.03).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
      builder: (_, __) {
        final backgroundColor = _backgroundAnimation.value ?? widget.colors.first;
        final hoverColor = _hoverAnimation.value?.withOpacity(0.7) ??
            widget.colors.last.withOpacity(0.7);
        final label = widget.label;
        final loadingLabel = widget.loadingLabel ??
            Text(
              'Please wait...',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
            );
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: SizedBox(
            height: widget.height,
            child: FilledButton(
              onPressed: widget.isLoading ? null : widget.onPressed,
              style: ButtonStyle(
                padding: MaterialStatePropertyAll(widget.padding),
                backgroundColor: MaterialStatePropertyAll(backgroundColor),
                foregroundColor: const MaterialStatePropertyAll(Colors.white),
                overlayColor: MaterialStatePropertyAll(hoverColor),
                shape: MaterialStatePropertyAll(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(scale: animation, child: child),
                ),
                child:
                    widget.isLoading
                        ? Row(
                            key: const ValueKey('loading'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Flexible(child: loadingLabel),
                            ],
                          )
                        : Row(
                            key: const ValueKey('content'),
                            mainAxisAlignment: MainAxisAlignment.center,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (widget.icon != null) ...[
                                widget.icon!,
                                const SizedBox(width: 10),
                              ],
                              Flexible(
                                child: DefaultTextStyle(
                                  style: Theme.of(context).textTheme.labelLarge!.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                      ),
                                  child: label,
                                ),
                              ),
                            ],
                          ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class AnimatedPulse extends StatefulWidget {
  const AnimatedPulse({
    required this.child,
    super.key,
    this.duration = const Duration(seconds: 3),
    this.minScale = 0.96,
    this.maxScale = 1.04,
  });

  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;

  @override
  State<AnimatedPulse> createState() => _AnimatedPulseState();
}

class _AnimatedPulseState extends State<AnimatedPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat(reverse: true);
    _scaleAnimation = Tween<double>(
      begin: widget.minScale,
      end: widget.maxScale,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void didUpdateWidget(covariant AnimatedPulse oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.duration != widget.duration ||
        oldWidget.minScale != widget.minScale ||
        oldWidget.maxScale != widget.maxScale) {
      _controller
        ..duration = widget.duration
        ..reset()
        ..repeat(reverse: true);
      _scaleAnimation = Tween<double>(
        begin: widget.minScale,
        end: widget.maxScale,
      ).animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
      );
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
      builder: (_, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: widget.child,
    );
  }
}
