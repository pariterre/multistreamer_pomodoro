import 'package:flutter/material.dart';

class AnimatedExpandingCard extends StatefulWidget {
  const AnimatedExpandingCard({
    super.key,
    required this.header,
    required this.builder,
    this.expandingDuration = const Duration(milliseconds: 300),
    this.onTapHeader,
    required this.expandedColor,
    required this.closedColor,
    this.initialExpandedState = false,
  });

  final Duration expandingDuration;
  final Widget header;
  final Color expandedColor;
  final Color closedColor;
  final Function(bool newState)? onTapHeader;
  final Widget Function(BuildContext context, bool isExpanded) builder;
  final bool initialExpandedState;

  @override
  State<AnimatedExpandingCard> createState() => _AnimatedExpandingCardState();
}

class _AnimatedExpandingCardState extends State<AnimatedExpandingCard>
    with TickerProviderStateMixin {
  late bool _isExpanded = widget.initialExpandedState;
  bool _isExpanding = false;

  late final AnimationController _expandingAnimationController =
      AnimationController(vsync: this, duration: widget.expandingDuration);
  late final Animation<double> _expandingAnimation = CurvedAnimation(
    parent: _expandingAnimationController,
    curve: Curves.fastOutSlowIn,
  );
  late final Tween<double> _expandingTween = Tween(begin: 0, end: 1);

  @override
  void initState() {
    super.initState();
    if (widget.initialExpandedState) {
      _expandingAnimationController.animateTo(1, duration: const Duration());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      color: _isExpanded || _isExpanding
          ? widget.expandedColor
          : widget.closedColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              _isExpanded = !_isExpanded;
              _isExpanded
                  ? _expandingAnimationController.forward()
                  : _expandingAnimationController.reverse();

              if (widget.onTapHeader != null) widget.onTapHeader!(_isExpanded);
              _isExpanding = true;
              setState(() {});
              Future.microtask(() async {
                await Future.delayed(widget.expandingDuration);
                _isExpanding = false;
                setState(() {});
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(child: widget.header),
                Padding(
                  padding: const EdgeInsets.only(left: 12.0, right: 16.0),
                  child: Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                    size: 30,
                    color:
                        _isExpanded ? widget.closedColor : widget.expandedColor,
                  ),
                )
              ],
            ),
          ),
          SizeTransition(
            sizeFactor: _expandingTween.animate(_expandingAnimation),
            child: widget.builder(context, _isExpanded || _isExpanding),
          ),
        ],
      ),
    );
  }
}
