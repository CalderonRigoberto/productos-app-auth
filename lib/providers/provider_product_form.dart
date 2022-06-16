import 'package:flutter/material.dart';
import 'package:productos_app/models/product.dart';

class ProviderProductForm extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  Product product;

  ProviderProductForm(this.product);

  updatedAvailableProduct(bool value) {
    product.available = value;
    notifyListeners();
  }

  bool isValidForm() {
    return formKey.currentState?.validate() ?? false;
  }
}
