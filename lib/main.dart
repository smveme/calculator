import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const Calculatrice());
}

class Calculatrice extends StatelessWidget {
  const Calculatrice({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Calculatrice",
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SimpleCalculatrice(),
    );
  }
}

class SimpleCalculatrice extends StatefulWidget {
  const SimpleCalculatrice({super.key});

  @override
  State<SimpleCalculatrice> createState() => _SimpleCalculatriceState();
}

class _SimpleCalculatriceState extends State<SimpleCalculatrice> {
  String equation = "0";
  String resultat = "0";
  String expression = "0";

  buttonPressed(String textBouton) {
    setState(() {
      if (textBouton == "C") {
        equation = "0";
        resultat = "0";
      } else if (textBouton == "⌫") {
        equation = equation.substring(0, equation.length - 1);
        if (equation.isEmpty) {
          equation = "0";
        }
      } else if (textBouton == "=") {
        expression = equation;
        
        expression = expression.replaceAll("÷", "/");
        expression = expression.replaceAll("×", "*");

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);
          ContextModel cm = ContextModel();
          resultat = "${exp.evaluate(EvaluationType.REAL, cm)}";
        } catch (e) {
          resultat = "erreur de syntaxe";
          if (kDebugMode) {
            print("$e $expression");
          }
        }
      } else {
        if (equation == "0") {
          equation = textBouton;
        } else {
          equation = equation + textBouton;
        }
      }
    });
  }

  Widget calculatriceButton(
      String textBouton, Color couleurText, Color couleurBouton) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1,
      color: couleurBouton,
      child: MaterialButton(
        onPressed: () => buttonPressed(textBouton),
        padding: const EdgeInsets.all(16),
        child: Text(
          textBouton,
          style: TextStyle(
              color: couleurText, fontSize: 30, fontWeight: FontWeight.normal),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Calculatrice"),
        centerTitle: true,
      ),
      body: Column(children: [
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(20, 10, 10, 0),
          child: Text(
            equation,
            style: const TextStyle(fontSize: 35),
          ),
        ),
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.fromLTRB(20, 30, 10, 0),
          child: Text(
            resultat,
            style: const TextStyle(fontSize: 35),
          ),
        ),
        const Expanded(child: Divider()),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Table(
                children: [
                  TableRow(children: [
                    calculatriceButton("C", Colors.redAccent, Colors.white),
                    calculatriceButton("⌫", Colors.blue, Colors.white),
                    calculatriceButton("%", Colors.blue, Colors.white),
                    calculatriceButton("÷", Colors.blue, Colors.white),
                  ]),
                  TableRow(children: [
                    calculatriceButton("7", Colors.blue, Colors.white),
                    calculatriceButton("8", Colors.blue, Colors.white),
                    calculatriceButton("9", Colors.blue, Colors.white),
                    calculatriceButton("×", Colors.blue, Colors.white),
                  ]),
                  TableRow(children: [
                    calculatriceButton("4", Colors.blue, Colors.white),
                    calculatriceButton("5", Colors.blue, Colors.white),
                    calculatriceButton("6", Colors.blue, Colors.white),
                    calculatriceButton("-", Colors.blue, Colors.white),
                  ]),
                  TableRow(children: [
                    calculatriceButton("1", Colors.blue, Colors.white),
                    calculatriceButton("2", Colors.blue, Colors.white),
                    calculatriceButton("3", Colors.blue, Colors.white),
                    calculatriceButton("+", Colors.blue, Colors.white),
                  ]),
                  TableRow(children: [
                    calculatriceButton(".", Colors.black, Colors.white),
                    calculatriceButton("0", Colors.blue, Colors.white),
                    calculatriceButton("00", Colors.blue, Colors.white),
                    calculatriceButton("=", Colors.white, Colors.blue),
                  ]),
                ],
              ),
            ),
          ],
        )
      ]),
    );
  }
}
