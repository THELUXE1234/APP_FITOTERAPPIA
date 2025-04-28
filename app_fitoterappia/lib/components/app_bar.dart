import 'package:flutter/material.dart';
import 'dart:io';


class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget firstIcon;
  final Widget child;
  final String title;
  final double height;
  final double childHeight;
  final Color color;

  CustomAppBar({
    
    required this.title,
    this.height = 190.0,
    required this.childHeight,
    required this.color,
    required this.firstIcon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.fromSize(
      size: preferredSize,
      child: LayoutBuilder(
        builder: (context, constraint) {
          return Stack(
            children: <Widget>[
              ClipPath(
                clipper: CustomAppBarClipper(),
                child: Container(
                  width: double.maxFinite,
                  height: preferredSize.height - childHeight,
                  color: color,
                  alignment: Alignment.topCenter,
                  child: Row(
                    children: <Widget>[
                      if (firstIcon != null) firstIcon,
                      if (firstIcon != null) Expanded(child: Container()),
                      Expanded(child: Container()),
                      PopupMenuButton<String>(
                        color: const Color(0xFFE6E652),
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onSelected: (value) {
                          if (value == 'inicio') {
                            Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false); // Ir a inicio
                          } else if (value == 'salir') {
                            // Salir de la app
                            Future.delayed(Duration(milliseconds: 200), () {
                              // O directamente:
                              //import 'dart:io';
                              exit(0);
                            });
                          }
                        },
                        itemBuilder: (context) => [
                          const PopupMenuItem(
                            value: 'inicio',
                            child: Center(child: Text('INICIO')),
                          ),
                          const PopupMenuItem(
                            value: 'salir',
                            child: Center(child: Text('SALIR')),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Positioned.fill(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: child,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}


// Custom ClipPath para redondear el AppBar
class CustomAppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var height = size.height;
    var width = size.width;

    double radius = 25;

    Path path = Path()
      ..lineTo(0, height)
      ..arcToPoint(Offset(20, height - 20), radius: Radius.circular(radius))
      ..lineTo(width - 20, height - 20)
      ..arcToPoint(Offset(width, height), radius: Radius.circular(radius))
      ..lineTo(width, 0)
      ..close();

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}