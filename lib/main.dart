
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; //Estou importando a biblioteca HTTP e renomeando para http.
import 'dart:async'; //Essa biblioteca permite usar os metodos async e future
import 'dart:convert';
const request = "https://api.hgbrasil.com/finance?key=6e46c5bd";


void main() async
{
 

  
 

  runApp(MaterialApp(
    title: "ConversorDeMoedas",
    theme: ThemeData.dark(),
    home: Home(),
  ),);
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  Future<Map> getData() async 
  {
  http.Response response = await http.get(Uri.parse(request));
  return json.decode(response.body);
  }
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
        builder: (context,snapshot) {
          
          switch(snapshot.connectionState)
          {
            case ConnectionState.none:
            case ConnectionState.waiting:
            return Center(child: Text("Carregando dados", style: TextStyle(color: Colors.amber, fontSize: 25,), textAlign: TextAlign.center,),);

              default:
              if(snapshot.hasError)
              {
              return Center(child: Text("Erro ao retornar dados :(", style: TextStyle(color: Colors.amber, fontSize: 25,), textAlign: TextAlign.center,),);
            
              }
              else 
              {
                return Container(color: Colors.green,);
              }
          }
          
          return Center();
        }
        
      ),
    );
  }
}