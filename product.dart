import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'services/api_service.dart';

class ProductPage extends StatefulWidget {
  @override
  _ProductPageState createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _codigoController = TextEditingController();
  final TextEditingController _precioController = TextEditingController();
  XFile? _selectedImage;
  List<Map<String, dynamic>> _products = [];
  int? _selectedProductId;
  String? _selectedImagePath;
  String? _base64Image;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final bytes = await pickedFile.readAsBytes();
      setState(() {
        _selectedImage = pickedFile;
        _selectedImagePath = _selectedImage?.path;
        _base64Image = base64Encode(bytes);
        print('Ruta de la imagen seleccionada: ${_selectedImage?.path}');
        print('Base64 Image: $_base64Image');
      });
    }
  }

  void _loadProducts() async {
    try {
      List<Map<String, dynamic>> products = await ApiService.getProducts();
      setState(() {
        _products = products.map((product) {
          return {
            'id': int.tryParse(product['id'].toString()) ?? 0,
            'nombre': product['nombre'] ?? '',
            'descripcion': product['descripcion'] ?? '',
            'precio': double.tryParse(product['precio'].toString()) ?? 0.0,
            'image': product['image'] ?? '',
          };
        }).toList();
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al cargar productos: $e')));
    }
  }

  void _insertProduct() async {
    String nombre = _nombreController.text;
    String descripcion = _codigoController.text;
    double precio = double.parse(_precioController.text);
    int stock = 1;

    if (_base64Image == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selecciona una imagen primero')));
      return;
    }

    try {
      await ApiService.addProduct(
        nombre, 
        descripcion, 
        precio, 
        stock, 
        _base64Image!,
        _selectedImage!.name
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto insertado con éxito')));
      _loadProducts();
      _clearTextFields();
      setState(() {
        _selectedImage = null;
        _selectedImagePath = null;
        _base64Image = null;
      });
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al insertar producto: $e')));
    }
  }

  void _updateProduct() async {
    if (_selectedProductId == null) return;

    String nombre = _nombreController.text;
    String descripcion = _codigoController.text;
    double precio = double.parse(_precioController.text);
    int stock = 1;

    try {
      await ApiService.updateProduct(
        _selectedProductId!,
        nombre,
        descripcion,
        precio,
        stock,
        _base64Image,
        _selectedImage?.name
      );

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto actualizado con éxito')));
      _loadProducts();
      _clearTextFields();
      setState(() {
        _selectedProductId = null;
        _selectedImage = null;
        _selectedImagePath = null;
        _base64Image = null;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al actualizar producto: $e')));
    }
  }

  void _deleteProduct(int id) async {
    try {
      await ApiService.deleteProduct(id);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Producto eliminado con éxito')));
      _loadProducts();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error al eliminar producto: $e')));
    }
  }

  void _clearTextFields() {
    _nombreController.clear();
    _codigoController.clear();
    _precioController.clear();
    setState(() {
      _selectedImage = null;
      _selectedImagePath = null;
      _base64Image = null;
    });
  }

  Widget _buildImage() {
    if (_selectedImage == null) {
      return Container();
    }

    return kIsWeb
        ? Image.network(
            _selectedImage!.path,
            height: 150,
          )
        : Image.file(
            File(_selectedImage!.path),
            height: 150,
          );
  }

  Widget _buildProductImage(String imageBase64) {
    if (imageBase64.isEmpty) {
      return Container();
    }

    try {
      Uint8List decodedBytes = base64Decode(imageBase64);
      return Image.memory(
        decodedBytes,
        height: 50,
        width: 50,
        fit: BoxFit.cover,
      );
    } catch (e) {
      print('Error decoding image: $e');
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestión de Productos'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Cerrar Sesión') {
                _showLogoutDialog(context);
              } else if ( value == 'Home') {
                Navigator.pushNamed(context, '/Inicio');
              }
            },
            itemBuilder: (BuildContext context) {
              return {'Home', 'Cerrar Sesión'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bosque2.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Container(
                    color: Colors.white70,
                    padding: EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          controller: _nombreController,
                          decoration: InputDecoration(
                            labelText: 'Nombre del Producto',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _codigoController,
                          decoration: InputDecoration(
                            labelText: 'Descripción',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextField(
                          controller: _precioController,
                          decoration: InputDecoration(
                            labelText: 'Precio',
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildImage(),
                        if (_selectedImagePath != null)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Ruta de la imagen: $_selectedImagePath',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Seleccionar Imagen'),
                        ),
                        SizedBox(height: 20),
                        Row(
                          children: [
                            ElevatedButton(
                              onPressed: _insertProduct,
                              child: Text('Insertar'),
                            ),
                            SizedBox(width: 10),
                            if (_selectedProductId != null)
                              ElevatedButton(
                                onPressed: _updateProduct,
                                child: Text('Actualizar'),
                              ),
                            SizedBox(width: 10),
                            if (_selectedProductId != null)
                              ElevatedButton(
                                onPressed: () {
                                  _clearTextFields();
                                  setState(() {
                                    _selectedProductId = null;
                                  });
                                },
                                child: Text('Cancelar'),
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
              Expanded(
                child: Container(
                  color: Colors.white,
                  width: double.infinity,
                  child: SingleChildScrollView(
                    child: DataTable(
                      columns: [
                        DataColumn(label: Text('Nombre')),
                        DataColumn(label: Text('Descripcion')),
                        DataColumn(label: Text('Precio')),
                        DataColumn(label: Text('Imagen')),
                        DataColumn(label: Text('Acciones')),
                      ],
                      rows: _products.map((product) {
                        return DataRow(cells: [
                          DataCell(Text(product['nombre'] ?? '')),
                          DataCell(Text(product['descripcion'] ?? '')),
                          DataCell(Text('\$${product['precio'] ?? 0.0}')),
                          DataCell(_buildProductImage(product['image'] ?? '')),
                          DataCell(Row(
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  setState(() {
                                    _selectedProductId = product['id'] is int ? product['id'] : int.tryParse(product['id'].toString());
                                    _nombreController.text = product['nombre'] ?? '';
                                    _codigoController.text = product['descripcion'] ?? '';
                                    _precioController.text = (product['precio'] ?? 0.0).toString();
                                  });
                                },
                              ),
                              IconButton(
                                icon: Icon(Icons.delete),
                                onPressed: () {
                                  _deleteProduct(product['id'] is int ? product['id'] : int.tryParse(product['id'].toString())!);
                                },
                              ),
                            ],
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación de Cierre de Sesión'),
          content: Text('¿Estás seguro de que deseas cerrar sesión?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cerrar Sesión'),
              onPressed: () {
                  Navigator.of(context).pushReplacementNamed('/');
              },
            ),
          ],
        );
      },
    );
  }
}
