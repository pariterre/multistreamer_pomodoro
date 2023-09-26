import 'package:flutter/material.dart';
import 'package:pomo_latte_pumpkin/main.dart';

class Menu extends StatefulWidget {
  const Menu({
    super.key,
    required this.items,
    required this.tabController,
  });

  final List<String> items;
  final TabController tabController;

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  final _scrollController = ScrollController();
  late int _current = widget.tabController.index;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(() {
      if (widget.tabController.index != _current) {
        setState(() {
          _current = widget.tabController.index;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SingleChildScrollView(
          controller: _scrollController,
          scrollDirection: Axis.horizontal,
          child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: widget.items
                  .asMap()
                  .keys
                  .map((index) => _TabItem(
                        title: widget.items[index],
                        onTap: () {
                          widget.tabController.animateTo(index);
                          setState(() => _current = index);
                        },
                        isActive: index == _current,
                      ))
                  .toList()),
        ),
        if (MediaQuery.of(context).size.width < 200 * widget.items.length)
          Positioned(
            left: 4.0,
            child: InkWell(
              onTap: () {
                _scrollController.animateTo(_scrollController.offset - 80,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25)),
                child: const Icon(
                  Icons.keyboard_arrow_left_outlined,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ),
          ),
        if (MediaQuery.of(context).size.width < 200 * widget.items.length)
          Positioned(
            right: 4.0,
            child: InkWell(
              onTap: () {
                _scrollController.animateTo(_scrollController.offset + 80,
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.ease);
              },
              borderRadius: BorderRadius.circular(25),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(25)),
                child: const Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: Colors.black,
                  size: 40,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _TabItem extends StatelessWidget {
  const _TabItem({
    required this.title,
    required this.onTap,
    required this.isActive,
  });

  final String title;
  final Function() onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 5,
          child: Container(
              width: 180,
              height: 60,
              decoration: BoxDecoration(
                  color: isActive ? selectedColor : unselectedColor),
              child: Center(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.center,
                ),
              )),
        ),
      ),
    );
  }
}
