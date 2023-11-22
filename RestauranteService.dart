import 'package:cloud_firestore/cloud_firestore.dart';

var baseRemota = FirebaseFirestore.instance;

class RestauranteDB {
  static Future agregarRestaurante(String empleado, String puesto, double salario, bool seguro) async {
    await baseRemota.collection("restaurante").add({
      'empleado': empleado,
      'puesto': puesto,
      'salario': salario,
      'seguro': seguro,
    });
  }

  static Future<List<Map<String, dynamic>>> obtenerRestaurantes() async {
    List<Map<String, dynamic>> temp = [];
    var query = await baseRemota.collection("restaurante").get();

    query.docs.forEach((element) {
      Map<String, dynamic> dato = element.data();
      dato.addAll({
        'id': element.id,
      });
      temp.add(dato);
    });

    return temp;
  }

  static Future eliminarRestaurante(String id) async {
    return await baseRemota.collection("restaurante").doc(id).delete();
  }

  static Future actualizarRestaurante(String id, String empleado, String puesto, double salario, bool seguro) async {
    return await baseRemota.collection("restaurante").doc(id).update({
      'empleado': empleado,
      'puesto': puesto,
      'salario': salario,
      'seguro': seguro,
    });
  }
}
