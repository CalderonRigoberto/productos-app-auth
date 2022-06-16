import 'package:flutter/material.dart';
import 'package:productos_app/models/product.dart';
import 'package:productos_app/services/auth_service.dart';
import 'package:productos_app/services/product_service.dart';
import 'package:productos_app/widgets/widgets.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final products = Provider.of<ProductService>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Center(child: Text('Productos')),
        actions: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: GestureDetector(
                onTap: () async{
                  await authService.logOut();
                  Navigator.pushReplacementNamed(context, 'login');
                },
                child: const Icon(Icons.exit_to_app)),
          )
        ],
      ),
      body: products.isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Colors.indigo,
            ))
          : ListView.builder(
              itemCount: products.products.length,
              itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    products.selectedProduct = products.products[index].copy();
                    Navigator.pushNamed(context, 'product');
                  },
                  child: CardProduct(
                    product: products.products[index],
                  ))),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          products.selectedProduct = Product(
            available: true,
            name: '',
            price: 0,
          );
          Navigator.pushNamed(context, 'product');
        },
      ),
    );
  }
}
