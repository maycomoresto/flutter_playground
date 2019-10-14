import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

const request = "https://api.hgbrasil.com/finance?format=json-cors&key=4e74ac4c";

void main() {
    runApp(
        MaterialApp(
            debugShowCheckedModeBanner: false,
            home: Home(),
            theme: ThemeData(
                hintColor: Colors.amber,
                primaryColor: Colors.white
            ),
        )
    );
}

Future<Map> getData() async {
    http.Response response = await http.get(request);
    return json.decode(response.body);
}

class Home extends StatefulWidget {
    @override
    _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

    double dolar;
    double euro;

    final realController = TextEditingController();
    final dolarController = TextEditingController();
    final euroController = TextEditingController();

    void _realChanged(String text) {
        double real = double.parse(text);
        this.dolarController.text = (real / this.dolar).toStringAsFixed(2);
        this.euroController.text = (real / this.euro).toStringAsFixed(2);
    }

    void _dolarChanged(String text) {
        double dolar = double.parse(text);
        this.realController.text = (dolar * this.dolar).toStringAsFixed(2);
        this.euroController.text = (dolar * this.dolar / this.euro).toStringAsFixed(2);
    }

    void _euroChanged(String text) {
        double euro = double.parse(text);
        this.realController.text = (euro * this.euro).toStringAsFixed(2);
        this.dolarController.text = (euro * this.euro / this.dolar).toStringAsFixed(2);
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
                title: Text("Conversor de Moedas"),
                backgroundColor: Colors.amber,
                centerTitle: true,
            ),
            body: FutureBuilder<Map>(
                future: getData(),
                builder: (context, snapshot) {
                    switch(snapshot.connectionState) {
                        case ConnectionState.none:
                        case ConnectionState.waiting:
                            return Center(
                                child: Text("Carregando dados",
                                style: TextStyle(color: Colors.amber, fontSize: 25.0),
                                textAlign: TextAlign.center,),
                            );
                        default:
                            if (snapshot.hasError) {
                                return Center(
                                    child: Text("Erro ao obter dados",
                                        style: TextStyle(color: Colors.amber, fontSize: 25.0),
                                        textAlign: TextAlign.center,),
                                );
                            } else {
                                dolar = getValorMoeda('USD', snapshot);
                                euro = getValorMoeda('EUR', snapshot);

                                return SingleChildScrollView(
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.stretch,
                                        children: <Widget>[
                                            Icon(Icons.monetization_on, color: Colors.amber, size: 150.0),
                                            buildTextField("Reais", "R\$", realController, _realChanged),
                                            buildTextField("Dólares", "US\$", dolarController, _dolarChanged),
                                            buildTextField("Euros", "€", euroController, _euroChanged),
                                        ],
                                    ),
                                );
                            }
                    }
                },
            ),
        );
    }
}

double getValorMoeda(moeda, snapshot) {
    return snapshot.data['results']['currencies'][moeda]['buy'];
}

Widget buildTextField(String label, String prefixo, TextEditingController controler, Function funcao) {
    return TextField(
        controller: controler,
        decoration: InputDecoration(
                labelText: label,
                labelStyle: TextStyle(color: Colors.amber),
                prefixText: prefixo
        ),
        style: TextStyle(color: Colors.amber, fontSize: 25.0),
        onChanged: funcao,
        keyboardType: TextInputType.number,
    );
}