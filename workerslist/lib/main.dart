import 'package:flutter/material.dart';
import 'package:workerslist/Worker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(title: 'Workers List Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  List<Worker> workers = [
    Worker(id: 1, nombre: "Juan", apellidos: "Perez", edad: 30),
    Worker(id: 2, nombre: "Maria", apellidos: "Gomez", edad: 25),
    Worker(id: 3, nombre: "Luis", apellidos: "Lopez", edad: 40)
  ];

  TextEditingController nombreController = TextEditingController();
  TextEditingController apellidosController = TextEditingController();
  TextEditingController edadController = TextEditingController(); 

  void _showAlert(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  void _addWorker() {
    if (nombreController.text.trim().isEmpty) {
      _showAlert("Error", "El nombre no puede estar vacío");
      return;
    }

    if (apellidosController.text.trim().isEmpty) {
      _showAlert("Error", "Los apellidos no pueden estar vacíos");
      return;
    }

    if (edadController.text.trim().isEmpty) {
      _showAlert("Error", "La edad no puede estar vacía");
      return;
    }

    int? edad = int.tryParse(edadController.text.trim());
    
    if (edad == null) {
      _showAlert("Error", "La edad debe ser un número válido");
      return;
    }

    if (edad < 18) {
      _showAlert("Error", "Solo se admiten mayores de edad (18+ años)");
      return;
    }

    if (edad < 0) {
      _showAlert("Error", "La edad no puede ser un número negativo");
      return;
    }

    int newId = workers.isNotEmpty ? workers.last.id + 1 : 1;
    
    while (workers.any((worker) => worker.id == newId)) {
      newId++;
      _showAlert("Advertencia", "ID duplicado detectado, se asignó nuevo ID: $newId");
    }

    setState(() {
      workers.add(Worker(
          id: newId,
          nombre: nombreController.text.trim(),
          apellidos: apellidosController.text.trim(),
          edad: edad));
      nombreController.clear();
      apellidosController.clear();
      edadController.clear();
    });

    _showAlert("Éxito", "Trabajador agregado correctamente");
  }

  void _deleteLastWorker() {
    setState(() {
      if (workers.isNotEmpty) {
        workers.removeLast();
        _showAlert("Éxito", "Último trabajador eliminado");
      } else {
        _showAlert("Error", "No hay trabajadores para eliminar");
      }
    });
  }

  Widget getWorkerList() {
    return Expanded(
      child: ListView.builder(
        itemCount: workers.length,
        itemBuilder: (context, index) {
          final worker = workers[index];
          return ListTile(
            title: Text('${worker.nombre} ${worker.apellidos}'),
            subtitle: Text('ID: ${worker.id} - Edad: ${worker.edad} años')
          );
        },
      ),
    );
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            const Text(
              'Lista de Trabajadores:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            getWorkerList(),
            
            const SizedBox(height: 16),
            
            TextField(
              controller: nombreController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Nombre *",
                hintText: "Ingrese el nombre",
              ),
            ),
            const SizedBox(height: 8),
            
            TextField(
              controller: apellidosController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Apellidos *",
                hintText: "Ingrese los apellidos",
              ),
            ),
            const SizedBox(height: 8),
            
            TextField(
              controller: edadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Edad * (18+ años)",
                hintText: "Ingrese la edad",
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _addWorker,
                  child: const Text("Agregar Trabajador"),
                ),
                ElevatedButton(
                  onPressed: _deleteLastWorker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text("Eliminar Último"),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            
            Text(
              'Total trabajadores: ${workers.length}',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  @override
  void dispose() {
    nombreController.dispose();
    apellidosController.dispose();
    edadController.dispose();
    super.dispose();
  }
}