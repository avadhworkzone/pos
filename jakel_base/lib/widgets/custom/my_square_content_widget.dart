import 'package:flutter/material.dart';

class MySquareContentWidget extends StatefulWidget {
  final String title;
  final String value;
  final Color color;
  final bool isSelected;
  final double size;

  const MySquareContentWidget({Key? key,
    required this.title,
    required this.value,
    required this.color,
    required this.isSelected,
    required this.size})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _MySquareContentWidgetState();
  }
}

class _MySquareContentWidgetState extends State<MySquareContentWidget>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;

  @override
  void initState() {
    _controller = AnimationController(vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.size,
      width: widget.size,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // if you need this
          side: BorderSide(
            color: Colors.grey.withOpacity(0.2),
            width: 1,
          ),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: widget.size * 0.5,
              height: widget.size * 0.5,
              decoration: BoxDecoration(
                color: widget.color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(5.0),
              child: Center(
                child: Text(
                  widget.value,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: widget.color,
                      fontWeight: FontWeight.bold,
                      fontSize: 10),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(padding: EdgeInsets.only(left: 5, right: 5), child: Text(
              widget.title.toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: widget.color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12),
            ),)
          ],
        ),
      ),
    );
  }
}
