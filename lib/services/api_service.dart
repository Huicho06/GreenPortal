import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String _baseUrl = 'http://localhost:8000/greenportalCRUD/greenportalCRUD';

  static Future<Map<String, dynamic>> _post(String path, Map<String, String> body) async {
    final url = Uri.parse('$_baseUrl/$path');
    try {
      var response = await http.post(url, body: body);

      if (response.statusCode == 200) {
        var decodedResponse = json.decode(response.body);
        if (decodedResponse is Map<String, dynamic>) {
          return decodedResponse;
        } else {
          throw Exception('Respuesta JSON inválida: ${response.body}');
        }
      } else {
        throw Exception('Solicitud fallida: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error durante la solicitud HTTP: $e');
    }
  }

  static Future<Map<String, dynamic>> loginUser(String email, String password) async {
    return await _post('login.php', {'email': email, 'password': password});
  }

  static Future<void> registerUser(String nombre, String email, String password) async {
    final response = await _post('register.php', {'nombre': nombre, 'email': email, 'password': password});
    if (!response['success']) {
      throw Exception(response['message']);
    }
  }

  static Future<void> addProduct(String nombre, String descripcion, double precio, int stock, String base64Image, String imageName) async {
    final response = await _post('add_product.php', {
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio.toString(),
      'stock': stock.toString(),
      'image': base64Image,
    });

    if (!response['success']) {
      throw Exception(response['message'] ?? 'Fallo al agregar el producto');
    }
  }

  static Future<void> updateProduct(int id, String nombre, String descripcion, double precio, int stock, String? base64Image, String? imageName) async {
    final response = await _post('update_product.php', {
      'id': id.toString(),
      'nombre': nombre,
      'descripcion': descripcion,
      'precio': precio.toString(),
      'stock': stock.toString(),
      'image': base64Image ?? '',
    });

    if (!response['success']) {
      throw Exception(response['message'] ?? 'Fallo al actualizar el producto');
    }
  }

  static Future<void> deleteProduct(int id) async {
    final response = await _post('delete_product.php', {'id': id.toString()});
    if (!response['success']) {
      throw Exception('Fallo al eliminar el producto');
    }
  }

  static Future<List<Map<String, dynamic>>> getProducts() async {
    final url = Uri.parse('$_baseUrl/get_products.php');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        List<dynamic> products = json.decode(response.body);
        return products.map((product) => product as Map<String, dynamic>).toList();
      } else {
        throw Exception('Solicitud fallida: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error durante la solicitud HTTP: $e');
    }
  }
}
