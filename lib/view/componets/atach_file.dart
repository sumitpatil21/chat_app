import 'package:flutter/material.dart';
import 'dart:math' as math;

class WhatsAppAttachButton extends StatefulWidget {
  @override
  _WhatsAppAttachButtonState createState() => _WhatsAppAttachButtonState();
}

class _WhatsAppAttachButtonState extends State<WhatsAppAttachButton> with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward(); // Expand
      } else {
        _controller.reverse(); // Collapse
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Attach Option 1: Document Icon
            _buildAttachOption(
              icon: Icons.insert_drive_file,
              angle: 5.7,
              distance: 100,
              color: Colors.blue,
              onTap: () => print("Document tapped"),
            ),
            // Attach Option 2: Camera Icon
            _buildAttachOption(
              icon: Icons.camera_alt,
              angle: 10, // 60 degrees
              distance: 100,
              color: Colors.red,
              onTap: () => print("Camera tapped"),
            ),
            // Attach Option 3: Gallery Icon
            _buildAttachOption(
              icon: Icons.photo,
              angle: 4.7, // 60 degrees
              distance: 100,
              color: Colors.green,
              onTap: () => print("Gallery tapped"),
            ),
            // Main Attach Button (Pin Icon)
            FloatingActionButton(
              onPressed: _toggleExpand,
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return Transform.rotate(
                    angle: _animation.value * math.pi / 4, // Rotate the pin
                    child: Icon(Icons.attach_file),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAttachOption({
    required IconData icon,
    required double angle,
    required double distance,
    required Color color,
    required VoidCallback onTap,
  }) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final offset = Offset(
          distance * math.cos(angle) * _animation.value,
          distance * math.sin(angle) * _animation.value,
        );
        return Transform.translate(
          offset: offset,
          child: Opacity(
            opacity: _animation.value,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: color,
              onPressed: onTap,
              child: Icon(icon),
            ),
          ),
        );
      },
    );
  }
}

