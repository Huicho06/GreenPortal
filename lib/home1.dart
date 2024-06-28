import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:image_picker/image_picker.dart';
class HomePage1 extends StatelessWidget {
  final List<String> imgList = [
    'assets/images/bosque.jpg',
    'assets/images/bosque2.jpg',
    'assets/images/bosque.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    final int userType = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(
        title: Text('Green Portal UWU'),
        actions: [
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'Cerrar Sesión') {
                _showLogoutDialog(context);
              } else if (value == 'Gestión de Productos') {
                Navigator.pushNamed(context, '/product');
              }
            },
            itemBuilder: (BuildContext context) {
              return {
                if (userType == 1) 'Gestión de Productos',
                'Cerrar Sesión'
              }.map((String choice) {
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/images/arce.jpg',
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),
                Positioned(
                  bottom: 10,
                  left: 10,
                  child: Text(
                    'Green Portal',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white70,
                    child: Text(
                      'Bienvenido a Green Portal',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.white70,
                    child: Text(
                      'Somos un equipo que trabaja a favor del medio ambiente. En este lugar, podrás informarte, dar tu opinión sobre distintos temas ambientales y ayudarnos a cumplir nuestra misión donando lo que salga de tu corazón.',
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    padding: EdgeInsets.all(16),
                    color: Colors.grey[200],
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nuestro Objetivo:',
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                        SizedBox(height: 10),
                        Text(
                          '• Darte a conocer lo último en cuanto al medio ambiente se refiere.\n'
                          '• Darte la opción de poder compartir tu punto de vista.\n'
                          '• Poder, junto a ti, mejorar el planeta en el que vivimos.\n'
                          'Junto a ti, lograremos todos nuestros objetivos.\n'
                          'Queremos que seas parte de esta misión y recuerde que la sabiduría digital se entrelaza con la naturaleza virtual, donde cada clic siembra conciencia y cosecha un futuro más verde.',
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 10),
            CarouselSlider(
              options: CarouselOptions(
                height: 200.0,
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 2.0,
                onPageChanged: (index, reason) {},
              ),
              items: imgList.map((item) => Container(
                child: Center(
                  child: Image.asset(item, fit: BoxFit.cover, width: 1000)
                ),
              )).toList(),
            ),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmación de cierre de sesión'),
          content: Text('¿Estás seguro de que quieres cerrar sesión?'),
          actions: [
            TextButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Cerrar sesión'),
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
