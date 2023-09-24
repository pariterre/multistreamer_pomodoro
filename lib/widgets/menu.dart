import 'package:flutter/material.dart';
import 'package:multistreamer_pomodoro/main.dart';

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
  late int _current = widget.tabController.index;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: widget.items
              .asMap()
              .keys
              .map(
                (index) => _TabItem(
                  title: widget.items[index],
                  onTap: () {
                    widget.tabController.animateTo(index);
                    setState(() => _current = index);
                  },
                  isActive: index == _current,
                ),
              )
              .toList()),
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
