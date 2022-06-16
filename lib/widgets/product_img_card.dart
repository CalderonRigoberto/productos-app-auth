import 'dart:io';

import 'package:flutter/material.dart';

class ProductImgCard extends StatelessWidget {
  const ProductImgCard({Key? key, required this.img}) : super(key: key);
  final String? img;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
        child: Opacity(
          opacity: 0.7,
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(35), topRight: Radius.circular(35)),
            child: Container(
                width: double.infinity,
                height: 450,
                decoration: _boxDecoration(),
                child: _GetImage(
                  picture: img,
                )),
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() => const BoxDecoration(boxShadow: [
        BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))
      ], color: Colors.red);
}

class _GetImage extends StatelessWidget {
  const _GetImage({Key? key, this.picture}) : super(key: key);

  final String? picture;
  @override
  Widget build(BuildContext context) {
    if (picture == null){
      return const Image(image: AssetImage('assets/img/no-image.png'), fit: BoxFit.cover,);
    }

    if (picture!.startsWith('http')) {
      return FadeInImage(
          placeholder: const AssetImage('assets/img/jar-loading.gif'),
          image: NetworkImage(picture!),
          fit: BoxFit.cover,
      );
    }
    return Image.file(
      File(picture!),
      fit: BoxFit.cover,
    );
  }
}
