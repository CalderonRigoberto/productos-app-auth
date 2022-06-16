import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

import '../models/product.dart';

class ProductService extends ChangeNotifier {
  final String _urlBase = 'flutter-app-prod-8e8dc-default-rtdb.firebaseio.com';
  final List<Product> products = [];
  late Product selectedProduct;
  bool isLoading = true;
  bool isSaving = false;
  final storage = const FlutterSecureStorage();
  File? pictureFile;

  ProductService() {
    loadProducts();
  }

  Future<List<Product>> loadProducts() async {
    isLoading = true;
    notifyListeners();

    final url = Uri.https(_urlBase, 'products.json',{
      'auth' : await storage.read(key: 'idToken') ?? ''
    });
    final response = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(response.body);
    productsMap.forEach((key, value) {
      final tempProduct = Product.fromMap(value);
      tempProduct.id = key;
      products.add(tempProduct);
    });
    isLoading = false;
    notifyListeners();
    return products.isEmpty ? [] : products;
  }

  Future saveOrCreateProduct(Product product) async {
    isSaving = true;
    notifyListeners();

    if (product.id == null) {
      createProduct(product);
    } else {
      await updateProduct(product);
    }

    isSaving = false;
    notifyListeners();
  }

  Future<String> updateProduct(Product product) async {
    final url = Uri.https(_urlBase, 'products/${product.id}.json',{
      'auth' : await storage.read(key: 'idToken') ?? ''
    });
    final response = await http.put(url, body: product.toJson());
    final index = products.indexWhere((element) => element.id == product.id);
    products[index] = product;

    return product.id!;
  }

  Future<String> createProduct(Product product) async {
    final url = Uri.https(_urlBase, 'products.json',{
      'auth' : await storage.read(key: 'idToken') ?? ''
    });
    final response = await http.post(url, body: product.toJson());
    final decodedData = json.decode(response.body);

    product.id = decodedData['name'];
    products.add(product);
    return product.id!;
  }

  void updateSelectedProductImage(String path) {
    selectedProduct.picture = path;
    pictureFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (pictureFile == null) return null;

    isSaving = true;
    notifyListeners();
    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dk35kkter/image/upload?upload_preset=ml_default');

    final imageUploadRequest = http.MultipartRequest('POST', url);
    final file = await http.MultipartFile.fromPath('file', pictureFile!.path);

    imageUploadRequest.files.add(file);
    final streamResponse = await imageUploadRequest.send();
    final response = await http.Response.fromStream(streamResponse);

    if (response.statusCode != 200 && response.statusCode != 201) return null;

    final decodeData = json.decode(response.body);

    return decodeData['secure_url'];
  }
}
