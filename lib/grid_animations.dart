import 'package:flutter/material.dart';

class GridAnimations extends StatefulWidget {
  const GridAnimations({super.key});

  @override
  State<GridAnimations> createState() => _GridAnimationsState();
}

class _GridAnimationsState extends State<GridAnimations>
    with TickerProviderStateMixin {
  List<int> items = List.generate(8, (index) => index);
  String animationType = 'slide';

  void _shuffleWithAnimation(String type) {
    setState(() {
      animationType = type;
      items.shuffle();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Grid View Animations")),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              key: ValueKey(items.join(',')), // Force rebuild
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return AnimatedGridItem(
                  key: ValueKey(items[index]),
                  number: items[index],
                  animationType: animationType,
                );
              },
            ),
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: [
              ElevatedButton(
                onPressed: () => _shuffleWithAnimation('slide'),
                child: Text("Slide In"),
              ),
              ElevatedButton(
                onPressed: () => _shuffleWithAnimation('fall'),
                child: Text("Fall Down"),
              ),
              ElevatedButton(
                onPressed: () => _shuffleWithAnimation('rotate'),
                child: Text("Rotate"),
              ),
              ElevatedButton(
                onPressed: () => _shuffleWithAnimation('switch'),
                child: Text("Switch Pos"),
              ),
            ],
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

class AnimatedGridItem extends StatefulWidget {
  final int number;
  final String animationType;

  const AnimatedGridItem({
    super.key,
    required this.number,
    required this.animationType,
  });

  @override
  _AnimatedGridItemState createState() => _AnimatedGridItemState();
}

class _AnimatedGridItemState extends State<AnimatedGridItem>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _controller.forward();

    animation = CurvedAnimation(parent: _controller, curve: Curves.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    Widget child = Container(
      margin: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.blue[widget.number * 100 + 100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Text(
          widget.number.toString(),
          style: TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );

    switch (widget.animationType) {
      case 'slide':
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case 'fall':
        return SlideTransition(
          position: Tween<Offset>(
            begin: Offset(0, -1),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      case 'rotate':
        return RotationTransition(turns: animation, child: child);
      case 'switch':
        return ScaleTransition(scale: animation, child: child);
      default:
        return child;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
