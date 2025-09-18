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

  void _addWorker() {
    if (nombreController.text.isNotEmpty && 
        apellidosController.text.isNotEmpty && 
        edadController.text.isNotEmpty) {
      setState(() {
        int newId = workers.isNotEmpty ? workers.last.id + 1 : 1;
        workers.add(Worker(
            id: newId,
            nombre: nombreController.text,
            apellidos: apellidosController.text,
            edad: int.tryParse(edadController.text) ?? 0));
        nombreController.clear();
        apellidosController.clear();
        edadController.clear();
      });
    }
  }

  void _deleteLastWorker() {
    setState(() {
      if (workers.isNotEmpty) {
        workers.removeLast();
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
            subtitle: Text('Edad: ${worker.edad}'),
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
                labelText: "Nombre",
              ),
            ),
            const SizedBox(height: 8),
            
            TextField(
              controller: apellidosController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Apellidos",
              ),
            ),
            const SizedBox(height: 8),
            
            TextField(
              controller: edadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Edad (18+ años)",
                helperText: "Solo mayores de edad",
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
              'Contador: $_counter',
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