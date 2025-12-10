import 'package:flutter/material.dart';
// Card dengan hover effect
class CourseCardWithHover extends StatefulWidget {
  final String title;
  final double rating;
  final String price;
  final String imageUrl;
  final List<String> tags;

  const CourseCardWithHover({
    super.key,
    required this.title,
    required this.rating,
    required this.price,
    required this.imageUrl,
    required this.tags,
  });

  @override
  State<CourseCardWithHover> createState() => _CourseCardWithHoverState();
}

class _CourseCardWithHoverState extends State<CourseCardWithHover> {
  bool _isHovering = false;
  
  double get _scale => _isHovering ? 1.05 : 1.0; 

  final Color primaryGreen = const Color.fromRGBO(7, 126, 96, 1);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity().scaled(_scale, _scale), 
          
          width: 200,
          margin: const EdgeInsets.only(right: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: _isHovering ? Colors.grey.shade400 : Colors.grey.shade200,
                spreadRadius: _isHovering ? 3 : 2,
                blurRadius: _isHovering ? 10 : 7,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: Image.asset(widget.imageUrl,
                    height: 100, width: double.infinity, fit: BoxFit.cover),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 6,
                  children: widget.tags
                      .map((tag) => Chip(
                            label: Text(tag),
                            backgroundColor: Colors.green.shade100,
                            labelStyle: TextStyle(
                                color: Colors.green.shade900, fontSize: 11),
                            visualDensity: VisualDensity.compact,
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(widget.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 14)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 6),
                child: Row(
                  children: [
                    const Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    const Text('4.5'),
                    const Spacer(),
                    Text(widget.price,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.black54)),
                  ],
                ),
              )
            ],
          ),
        ),
    );
  }
}

class HoverEffectWrapper extends StatefulWidget {
  final Widget child;
  final double width;
  final double scaleOnHover;

  const HoverEffectWrapper({
    super.key,
    required this.child,
    required this.width,
    this.scaleOnHover = 1.05,
  });

  @override
  State<HoverEffectWrapper> createState() => _HoverEffectWrapperState();
}

class _HoverEffectWrapperState extends State<HoverEffectWrapper> {
  bool _isHovering = false;
  double get _scale => _isHovering ? widget.scaleOnHover : 1.0; 

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovering = true),
      onExit: (_) => setState(() => _isHovering = false),
      
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity().scaled(_scale, _scale), 
        width: widget.width,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: _isHovering ? Colors.grey.shade400 : Colors.grey.shade200,
              spreadRadius: _isHovering ? 3 : 2,
              blurRadius: _isHovering ? 7 : 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: widget.child,
      ),
    );
  }
}