import 'package:flutter/material.dart';

import '../models/product.dart';

class CardProduct extends StatelessWidget {
  const CardProduct({Key? key, required this.product}) : super(key: key);

  final Product product;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(25),
      width: double.infinity,
      height: 400,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(35),
          boxShadow: const [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 6), blurRadius: 10)
          ]),
      child: Stack(
        alignment: AlignmentDirectional.bottomCenter,
        children: [
          _BackGroundImg( img:  product.picture ?? 'https://via.placeholder.com/400x300',),
          _DescriptionProduct( nameProd: product.name, idProd: product.id ?? ''),
          Positioned(top: 0, right: 0, child: _PriceCard( price: product.price,)),
          Positioned(top: 0, left: 0, child: product.available ? _AvailableIndicator() : Container()),
        ],
      ),
    );
  }
}

class _AvailableIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: Padding(
        padding: const EdgeInsets.only(right: 100),
        child: Container(
          width: 100,
          height: 70,
          decoration: BoxDecoration(
              color: Colors.yellow[800],
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  bottomRight: Radius.circular(35))),
          child: const FittedBox(
            fit: BoxFit.contain,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Text(
                'Available',
                style: TextStyle(fontSize: 25, color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _PriceCard extends StatelessWidget {
  const _PriceCard({Key? key, required this.price}) : super(key: key);
  final int price;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 100),
      child: Container(
        width: 200,
        height: 70,
        decoration: boxDecoration(),
        child:  FittedBox(
          fit: BoxFit.contain,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Text(
              price.toString(),
              style: const TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class _BackGroundImg extends StatelessWidget {
  const _BackGroundImg({Key? key, required this.img}) : super(key: key);

  final String? img;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(35),
      child: SizedBox(
        width: double.infinity,
        height: 400,
        child: img != null ? FadeInImage(
          placeholder: const AssetImage('assets/img/jar-loading.gif'),
          image: NetworkImage(img!),
          fit: BoxFit.cover,
        ) : Image.asset('assets/img/no-image.png'),
      ),
    );
  }
}

class _DescriptionProduct extends StatelessWidget {
  const _DescriptionProduct({Key? key, required this.nameProd, this.idProd})
      : super(key: key);

  final String nameProd;
  final String? idProd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 70),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: boxDecoration(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              nameProd,
              style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              idProd ?? 'ID: ',
              style: const TextStyle(fontSize: 15, color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

BoxDecoration boxDecoration() {
  return const BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(35), topRight: Radius.circular(35)));
}
