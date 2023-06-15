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

  late double dolar;
  late double euro;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("\$ Conversor\$"),
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
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Reais",
                              labelStyle: TextStyle(
                                color: Colors.amber,
                              ),
                              border: OutlineInputBorder(),
                              prefixText: "R\$"),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Dolares",
                              labelStyle: TextStyle(
                                color: Colors.amber,
                              ),
                              border: OutlineInputBorder(),
                              prefixText: "US\$"),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),
                        Divider(),
                        TextField(
                          decoration: InputDecoration(
                              labelText: "Euros",
                              labelStyle: TextStyle(
                                color: Colors.amber,
                              ),
                              border: OutlineInputBorder(),
                              prefixText: "€\$"),
                          style: TextStyle(color: Colors.amber, fontSize: 25),
                        ),
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
