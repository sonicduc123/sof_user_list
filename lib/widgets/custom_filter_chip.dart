import 'package:flutter/material.dart';
import 'package:sof_user_list/constants.dart';

class CustomFilterChip extends StatefulWidget {
  const CustomFilterChip({
    super.key,
    required this.listLabel,
    required this.listWidget,
    required this.listCountElement,
  });

  final List<String> listLabel;
  final List<int> listCountElement;
  final List<Widget> listWidget;

  @override
  State<CustomFilterChip> createState() => _CustomFilterChipState();
}

class _CustomFilterChipState extends State<CustomFilterChip> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(
            widget.listLabel.length,
            (index) => Padding(
              padding: const EdgeInsets.only(right: Space.marginComponent),
              child: FilterChip(
                label: Text(
                  "${widget.listLabel[index]} (${widget.listCountElement[index]})",
                ),
                selected: selectedIndex == index,
                onSelected: (value) {
                  if (index != selectedIndex) {
                    setState(() {
                      selectedIndex = index;
                    });
                  }
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: Space.marginElement),
        Expanded(child: widget.listWidget[selectedIndex]),
      ],
    );
  }
}
