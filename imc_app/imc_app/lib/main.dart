import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
    runApp(MaterialApp(
        home: Home(),
        debugShowCheckedModeBanner: false,
    ));
}

class Home extends StatefulWidget {

    @override
    _HomeState createState() => _HomeState();

}

class _HomeState extends State<Home> {

    String _infoText = "Informe seus dados";
    TextEditingController weightEditController = TextEditingController();
    TextEditingController heightEditController = TextEditingController();

    GlobalKey<FormState> _formKey = GlobalKey<FormState>();

    void _resetFields() {
        this.weightEditController.text = "";
        this.heightEditController.text = "";
        setState(() {
            this._infoText = "Informe seus dados";
            _formKey = GlobalKey<FormState>();
        });
    }

    void _calculate() {
        setState(() {
            double weight = double.parse(this.weightEditController.text);
            double height = double.parse(this.heightEditController.text) / 100;
            double imc = weight / (height * height);
            if (imc < 18.6) {
                this._infoText = "Abaixo do peso ${imc.toStringAsPrecision(4)}";
            } else if(imc >= 18.6 && imc < 24.9) {
                this._infoText = "Peso Ideal ${imc.toStringAsPrecision(4)}";
            } else if(imc >= 24.9 && imc < 29.9) {
                this._infoText = "Levemente Acima Do peso ${imc.toStringAsPrecision(4)}";
            } else if(imc >= 29.9 && imc < 34.9) {
                this._infoText = "Obesidade Grau I ${imc.toStringAsPrecision(4)}";
            } else if(imc >= 34.9 && imc < 39.9) {
                this._infoText = "Obesidade Grau II ${imc.toStringAsPrecision(4)}";
            } else if(imc > 40.0) {
                this._infoText = "Obesidade Grau III ${imc.toStringAsPrecision(4)}";
            }
        });
    }

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text("Calculadora de IMC"),
                centerTitle: true,
                backgroundColor: Colors.green,
                actions: <Widget>[
                    IconButton(
                        icon: Icon(Icons.refresh),
                        onPressed: _resetFields,
                    )
                ],
            ),
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(10.0, 0, 10.0, 0),
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                            Icon(Icons.person_outline, size: 120.0, color: Colors.green,),
                            TextFormField(
                                // ignore: missing_return
                                validator: (value) {
                                    if (value.isEmpty) {
                                        return "Insira seu Peso";
                                    }
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                        labelText: "Peso (kg)",
                                        labelStyle: TextStyle(color: Colors.green)
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.green, fontSize: 20.0),
                                controller: weightEditController,
                            ),
                            TextFormField(
                                // ignore: missing_return
                                validator: (value) {
                                    if (value.isEmpty) {
                                        return "Insira sua Altura";
                                    }
                                },
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                        labelText: "Altura (cm)",
                                        labelStyle: TextStyle(color: Colors.green)
                                ),
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.green, fontSize: 20.0),
                                controller: heightEditController,
                            ),
                            Padding(
                                padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
                                child: Container(
                                    height: 50.0,
                                    child: RaisedButton(
                                        onPressed: () {
                                            if (this._formKey.currentState.validate()) {
                                                this._calculate();
                                            }
                                        },
                                        child: Text("Calcular",
                                            style: TextStyle(color: Colors.white, fontSize: 25.0),),
                                        color: Colors.green,
                                    ),
                                ),
                            ),
                            Text("$_infoText",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.green, fontSize: 25.0),)
                        ],
                    ),
                )
            )
        );
    }

}
