import 'package:flutter/material.dart';
class CustomAppBarNoImageWithBackground extends StatelessWidget implements PreferredSizeWidget {
  final Widget firstIcon;
  final String title;
  final double height;
  final String backgroundImageAsset;

  CustomAppBarNoImageWithBackground({
    required this.title,
    this.height = 100.0,
    required this.firstIcon,
    required this.backgroundImageAsset,
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
                  width: double.infinity,
                  height: preferredSize.height,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage(backgroundImageAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      firstIcon,
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.menu, color: Colors.black),
                        onPressed: () {},
                      ),
                    ],
                  ),
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