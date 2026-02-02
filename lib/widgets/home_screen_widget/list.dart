import 'package:flutter/material.dart';

class Listeeei extends StatefulWidget {
  const Listeeei({super.key});
  @override
  State<Listeeei> createState() => _ListeeeiState();
}

class _ListeeeiState extends State<Listeeei> {
  int selectedIndex = 0;

  final List<String> labels = [
    'All',
    'Trending',
    'Suggested',
    'Artists',
    'Album',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 64,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 16.5),
        itemCount: labels.length,
        itemBuilder: (context, index) {
          final isSelected = selectedIndex == index;
          return Padding(
            padding: const EdgeInsets.only(right: 10),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: isSelected
                    ? Colors.lightGreenAccent
                    : Colors.white.withOpacity(.15),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.pink,
                ),
              ),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                onPressed: () {
                  setState(() => selectedIndex = index);
                },
                child: Text(
                  labels[index],
                  style: TextStyle(
                    color: isSelected ? Colors.black : Colors.white,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    letterSpacing: 0.2,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
