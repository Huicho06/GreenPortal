import 'package:flutter/material.dart';

class CartPage extends StatelessWidget {
  final List<Map<String, dynamic>> cartItems = [
    {'image': 'assets/images/product1.jpg', 'description': 'portalapices', 'price': 10, 'quantity': 4},
    {'image': 'assets/images/product2.jpg', 'description': 'portalapices', 'price': 200, 'quantity': 1},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tu Carrito'),
      ),
      body: Center(
        child: Container(
          margin: EdgeInsets.all(16.0), // Agrega un margen exterior al contenedor
          padding: EdgeInsets.all(16.0), // Agrega un margen interior al contenedor
          decoration: BoxDecoration(
            color: Colors.lightGreen[100], // Color de fondo verde claro
            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados para el contenedor
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: Image.asset(cartItems[index]['image']),
                      title: Text(cartItems[index]['description']),
                      subtitle: Text('Precio por unidad: ${cartItems[index]['price']}bs\nCantidad: ${cartItems[index]['quantity']}'),
                      isThreeLine: true,
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          // Implementa la eliminación del elemento del carrito
                        },
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Total: ${calculateTotalPrice()} bs', // Mostrar el precio total
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Implementa la lógica de la compra
                },
                child: Text('Realizar compra'), // Agrega un botón para realizar la compra
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Método para calcular el precio total de todos los productos en el carrito
 int calculateTotalPrice() {
  int total = 0;
  for (var item in cartItems) {
    total += (item['price'] as int) * (item['quantity'] as int);
  }
  return total;
}

}
