import 'package:flutter/material.dart';

import '../constant/app_images.dart';

class CustomImage extends StatelessWidget {
  final String imgURL;
  final double height;
  final double width;
  final String placeholderImg;
  CustomImage(
      {required this.imgURL,
      required this.height,
      required this.width,
      this.placeholderImg = AppImages.loader});

//Normal Image...
  Widget _buildImage() {
    return FadeInImage.assetNetwork(
      fadeInDuration: const Duration(milliseconds: 450),
      placeholder: placeholderImg,
      image: imgURL,
      width: width,
      height: height,
      fit: BoxFit.cover,
    );
  }

  Widget _buildImageWithCircular() {
    return Image.network(
      imgURL,
      width: width,
      height: height,
      fit: BoxFit.cover,
      loadingBuilder: (ctx, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildImageWithCircular(); //_buildImage();
  }
}
