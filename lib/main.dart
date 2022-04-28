import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of the application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'STI Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.grey, fontFamily: 'Montserrat'),
      home: const MyHomePage(
        title: "STI Calculator",
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String equation = "0";
  String result = "0";
  String ansResult = "";
  String expression = "";
  Color white = Colors.white;
  Color grey = Color.fromARGB(255, 221, 218, 218);

  //Button Controller function - Conditional behaviour based on button pressed
  void buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == "C") {
        equation = "0";
        result = "0";
      } else if (buttonText == "←") {
        equation = equation.substring(0, equation.length - 1);
      } else if (buttonText == "x") {
        equation = equation + "x";
        if (equation == "") {
          equation = "0";
        }
      } else if (buttonText == "ANS") {
        if (ansResult != "") {
          if (equation == "0") {
            equation = ansResult;
          } else {
            equation = equation + ansResult;
          }
        }
      } else if (buttonText == "=") {
        expression = equation;
        expression = expression.replaceAll('x', '*');
        expression = expression.replaceAll('÷', '/');

        try {
          Parser p = Parser();
          Expression exp = p.parse(expression);

          ContextModel cm = ContextModel();
          result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          ansResult = result;
        } catch (e) {
          result = "MATH error";
        }
      } else {
        if (equation == "0") {
          equation = buttonText;
        } else {
          equation = equation + buttonText;
        }
      }
    });
  }

  //Creates a single keyboard button based on given attributes
  Widget buildButton(
      String buttonText, double buttonHeight, Color buttonColor) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.1 * buttonHeight,
      color: buttonColor,
      child: TextButton(
        style: TextButton.styleFrom(
          padding: EdgeInsets.all(20.0),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(0.0),
              side: BorderSide(
                color: Color.fromARGB(255, 197, 189, 189),
                width: 1,
                style: BorderStyle.solid,
              )),
        ),
        onPressed: () => buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.normal,
              color: Colors.black),
        ),
      ),
    );
  }

  //App structural widget - structures and gathers all the elements of the app
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          //Equation container
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 20, 10),
            child: Text(
              equation,
              style: TextStyle(fontSize: 27),
            ),
          ),

          //Result container
          Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.fromLTRB(10, 30, 20, 10),
            child: Text(
              result,
              style: TextStyle(fontSize: 34),
            ),
          ),
          Expanded(child: Container()),

          //Keyboard container
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Table(
                children: [
                  TableRow(children: [
                    buildButton("C", 1, grey),
                    buildButton("←", 1, grey),
                    buildButton("%", 1, grey),
                    buildButton("÷", 1, grey),
                  ]),
                  TableRow(children: [
                    buildButton("7", 1, white),
                    buildButton("8", 1, white),
                    buildButton("9", 1, white),
                    buildButton("x", 1, grey),
                  ]),
                  TableRow(children: [
                    buildButton("4", 1, white),
                    buildButton("5", 1, white),
                    buildButton("6", 1, white),
                    buildButton("-", 1, grey),
                  ]),
                  TableRow(children: [
                    buildButton("1", 1, white),
                    buildButton("2", 1, white),
                    buildButton("3", 1, white),
                    buildButton("+", 1, grey),
                  ]),
                  TableRow(children: [
                    buildButton("0", 1, white),
                    buildButton(".", 1, white),
                    buildButton("ANS", 1, white),
                    buildButton("=", 1, grey),
                  ])
                ],
              ),
            ),
          ]),
        ],
      ),
    );
  }
}
