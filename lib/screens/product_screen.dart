import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'package:productos_app/providers/provider_product_form.dart';
import 'package:productos_app/services/product_service.dart';
import 'package:productos_app/ui/input_decorations.dart';
import 'package:productos_app/widgets/widgets.dart';

class ProductScreen extends StatelessWidget {
  const ProductScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<ProductService>(context);
    return ChangeNotifierProvider(
      create: (context) => ProviderProductForm(product.selectedProduct),
      child: _ProductScreenBody(product: product),
    );
  }
}

class _ProductScreenBody extends StatelessWidget {
  const _ProductScreenBody({
    Key? key,
    required this.product,
  }) : super(key: key);

  final ProductService product;

  @override
  Widget build(BuildContext context) {
    final productFormProvider =
        Provider.of<ProviderProductForm>(context, listen: true);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ProductImgCard(img: product.selectedProduct.picture),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          size: 40,
                          color: Colors.white,
                        ))),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                        onPressed: () async {
                          final picker = ImagePicker();
                          final XFile? pickedFile = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 100);
                          if (pickedFile != null) {
                            product.updateSelectedProductImage(pickedFile.path);
                          }
                        },
                        icon: const Icon(
                          Icons.camera_alt_outlined,
                          size: 40,
                          color: Colors.white,
                        )))
              ],
            ),
            const _FormProduct(),
            const SizedBox(height: 100)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: product.isSaving
            ? null
            : () async {
                if (!productFormProvider.isValidForm()) return;

                final String? imageUrl = await product.uploadImage();

                if (imageUrl != null)
                  productFormProvider.product.picture = imageUrl;

                await product.saveOrCreateProduct(productFormProvider.product);

                product.pictureFile = null;
              },
        child: product.isSaving
            ? const CircularProgressIndicator(color: Colors.white)
            : const Icon(Icons.save),
      ),
    );
  }
}

class _FormProduct extends StatelessWidget {
  const _FormProduct({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final productForm = Provider.of<ProviderProductForm>(context);
    final product = productForm.product;

    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        width: double.infinity,
        decoration: _boxDecoration(),
        child: Form(
          key: productForm.formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            children: [
              const SizedBox(height: 10),
              TextFormField(
                initialValue: product.name,
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Nombre del producto',
                    labelText: 'Nombre',
                    icon: Icons.text_format),
                onChanged: (value) => product.name = value,
                validator: (value) {
                  if (value == null || value.isEmpty)
                    return 'El nombre es obligatorio';
                },
              ),
              const SizedBox(height: 30),
              TextFormField(
                initialValue: '${product.price}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^(\d+)?\d{0,2}'))
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecorations.authInputDecoration(
                    hintText: '\$150 precio',
                    labelText: 'Precio',
                    icon: Icons.text_format),
                onChanged: (value) {
                  if (int.tryParse(value) == null) {
                    product.price = 0;
                  } else {
                    product.price = int.parse(value);
                  }
                },
              ),
              const SizedBox(height: 30),
              SwitchListTile.adaptive(
                  title: const Text('Disponible'),
                  activeColor: Colors.indigo,
                  value: product.available,
                  onChanged: productForm.updatedAvailableProduct),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() => const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(35),
              bottomRight: Radius.circular(35)),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, blurRadius: 10, offset: Offset(0, 6))
          ]);
}
