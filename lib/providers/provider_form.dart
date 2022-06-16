import 'package:flutter/material.dart';

class ProviderForm extends ChangeNotifier {
  GlobalKey<FormState> globalKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  bool _isLoading = false;

  bool isValidForm() {
    return globalKey.currentState?.validate() ?? false;
  }

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
