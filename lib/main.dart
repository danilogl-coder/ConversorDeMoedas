import 'package:flutter/material.dart';
import 'package:http/http.dart'
    as http; //Estou importando a biblioteca HTTP e renomeando para http.
import 'dart:async'; //Essa biblioteca permite usar os metodos async e future
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?key=6e46c5bd";

void main() async {
  runApp(
    MaterialApp(
      title: "ConversorDeMoedas",
      theme: ThemeData(hintColor: Colors.amber, primaryColor: Colors.white),
      home: Home(),
    ),
  );
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  Future<Map> getData() async {
    http.Response response = await http.get(Uri.parse(request));
    return json.decode(response.body);
  }

  final realController = TextEditingController();
  final dolarController = TextEditingController();
  final euroController = TextEditingController();

  late double real;
  late double dolar;
  late double euro;

  void _clearAll()
  {
    realController.text = '';
    dolarController.text = '';
    euroController.text = '';
  }

  void _realChanges(String text) 
  {
    if(text.isEmpty)
    {
      _clearAll();
      return;
    }
    double real = double.parse(text ?? '');
    dolarController.text = (real / dolar).toStringAsFixed(2);
    euroController.text = (real / euro).toStringAsFixed(2);
  }

  void _dolarChanges(String text) 
  {
     if(text.isEmpty)
    {
      _clearAll();
      return;
    }
    double dolar = double.parse(text ?? '');
    realController.text = (dolar * this.dolar).toStringAsFixed(2);
    euroController.text = (dolar * this.dolar / euro).toStringAsFixed(2);
  }

  void _euroChanges(String text) 
  {
     if(text.isEmpty)
    {
      _clearAll();
      return;
    }
    double euro = double.parse(text ?? '');
    realController.text = (euro * this.euro).toStringAsFixed(2);
    dolarController.text = (euro * this.euro / dolar).toStringAsFixed(2);
  }
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("\$ Conversor \$"),
        backgroundColor: Colors.amber,
        centerTitle: true,
      ),
      body: FutureBuilder<Map>(
          future: getData(),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(
                  child: Text(
                    "Carregando dados",
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 25,
                    ),
                    textAlign: TextAlign.center,
                  ),
                );

              default:
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      "Erro ao retornar dados :(",
                      style: TextStyle(
                        color: Colors.amber,
                        fontSize: 25,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                } else {
                  dolar = snapshot.data!["results"]["currencies"]["USD"]["buy"];
                  euro = snapshot.data!["results"]["currencies"]["EUR"]["buy"];
                  return SingleChildScrollView(
                    padding: EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Icon(Icons.monetization_on,
                            size: 150, color: Colors.amber),
                        buildTextField(
                            "Reais", "R\$", realController, _realChanges),
                        Divider(),
                        buildTextField(
                            "Dolares", "US\$", dolarController, _dolarChanges),
                        Divider(),
                        buildTextField(
                            "Euros", "€", euroController, _euroChanges),
                      ],
                    ),
                  );
                }
            }

            return Center();
          }),
    );
  }
}

Widget buildTextField(
    String label, String prefix, TextEditingController c, Function(String value) f) {
  return TextField(
    controller: c,
    decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: Colors.amber,
        ),
        border: OutlineInputBorder(),
        prefixText: prefix),
    style: TextStyle(color: Colors.amber, fontSize: 25),
    onChanged: f,
    keyboardType: TextInputType.numberWithOptions(decimal:true),
  );
}
