import 'package:flutter/material.dart';
import 'RestauranteService.dart';

class AppU3T2 extends StatefulWidget {
  @override
  _AppU3T2State createState() => _AppU3T2State();
}

class _AppU3T2State extends State<AppU3T2> {
  final RestauranteDB _restauranteService = RestauranteDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('COLECCION RESTAURANTE'),
        centerTitle: true,
      ),
      body: FutureBuilder(
        future: RestauranteDB.obtenerRestaurantes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          } else {
            List<Map<String, dynamic>> restaurantes = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: restaurantes.length,
              itemBuilder: (context, index) {
                final restaurante = restaurantes[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(restaurante['empleado'] ?? 'Empleado no disponible'),
                    subtitle: Text(
                      'Puesto: ${restaurante['puesto'] ?? 'No especificado'}, Salario: ${restaurante['salario'] != null ? restaurante['salario'].toString() : 'No especificado'}, Seguro activo: ${restaurante['seguro'] != null ? restaurante['seguro'].toString() : 'No especificado'}',
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            _mostrarDialogoActualizar(restaurante);
                          },
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            _mostrarDialogoBorrar(restaurante);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _mostrarDialogoAgregar();
        },
        tooltip: 'Agregar restaurante',
        child: Icon(Icons.add),
      ),
    );
  }

  _mostrarDialogoAgregar() {
    TextEditingController empleadoController = TextEditingController();
    TextEditingController puestoController = TextEditingController();
    TextEditingController salarioController = TextEditingController();
    TextEditingController seguroController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Agregar Restaurante'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(empleadoController, 'Empleado'),
                _buildTextField(puestoController, 'Puesto'),
                _buildTextField(salarioController, 'Salario', TextInputType.number),
                _buildTextField(seguroController, 'Seguro activo'),
              ],
            ),
          ),
          actions: [
            _buildDialogButton('Cancelar', () {
              Navigator.of(context).pop();
            }),
            _buildDialogButton('Agregar', () async {
              try {
                await RestauranteDB.agregarRestaurante(
                  empleadoController.text,
                  puestoController.text,
                  double.parse(salarioController.text),
                  seguroController.text.toLowerCase() == 'si',
                );
                Navigator.of(context).pop();
                setState(() {});
              } catch (error) {
                print('Error al agregar: $error');
                // Puedes mostrar un mensaje de error al usuario si es necesario
              }
            }),
          ],
        );
      },
    );
  }

  _mostrarDialogoActualizar(Map<String, dynamic> restaurante) {
    TextEditingController empleadoController = TextEditingController(text: restaurante['empleado']);
    TextEditingController puestoController = TextEditingController(text: restaurante['puesto']);
    TextEditingController salarioController = TextEditingController(text: restaurante['salario']?.toString() ?? '');
    TextEditingController seguroController = TextEditingController(text: restaurante['seguro']?.toString() ?? '');

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Actualizar Restaurante'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                _buildTextField(empleadoController, 'Empleado'),
                _buildTextField(puestoController, 'Puesto'),
                _buildTextField(salarioController, 'Salario', TextInputType.number),
                _buildTextField(seguroController, 'Seguro'),
              ],
            ),
          ),
          actions: [
            _buildDialogButton('Cancelar', () {
              Navigator.of(context).pop();
            }),
            _buildDialogButton('Actualizar', () async {
              try {
                await RestauranteDB.actualizarRestaurante(
                  restaurante['id'],
                  empleadoController.text,
                  puestoController.text,
                  double.tryParse(salarioController.text) ?? 0.0,
                  seguroController.text.toLowerCase() == 'si',
                );
                Navigator.of(context).pop();
                setState(() {});
              } catch (error) {
                print('Error al actualizar: $error');
                // Puedes mostrar un mensaje de error al usuario si es necesario
              }
            }),
          ],
        );
      },
    );
  }

  _mostrarDialogoBorrar(Map<String, dynamic> restaurante) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Eliminar Restaurante?'),
          content: Text('¿Estás seguro de que quieres eliminar este restaurante?'),
          actions: [
            _buildDialogButton('Cancelar', () {
              Navigator.of(context).pop();
            }),
            _buildDialogButton('Eliminar', () async {
              try {
                String idRestaurante = restaurante['id']; // Obtén el ID del documento
                if (idRestaurante != null && idRestaurante.isNotEmpty) {
                  await RestauranteDB.eliminarRestaurante(idRestaurante);
                  Navigator.of(context).pop();
                  setState(() {});
                } else {
                  print('Error: ID de restaurante nulo o vacío');
                }
              } catch (error) {
                print('Error al eliminar: $error');
                // Puedes mostrar un mensaje de error al usuario si es necesario
              }
            }),
          ],
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, [TextInputType inputType = TextInputType.text]) {
    return TextField(
      controller: controller,
      keyboardType: inputType,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  Widget _buildDialogButton(String text, VoidCallback onPressed) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
