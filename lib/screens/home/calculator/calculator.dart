import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';

class Calculator extends StatefulWidget {
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {

  String equation="0";
  String result="0";
  String expression="";
  double equationFontSize = 38;
  double resultFontSize=48;

  buttonPressed(String buttonText){
      setState(() {
        if(buttonText == "C"){
            equation="0";
            result="0";
            equationFontSize=38;
            resultFontSize=48;
        }
        else if(buttonText == "⌫"){
          equationFontSize=48;
          resultFontSize=38;
          equation = equation.substring(0,equation.length-1);
          if(equation==""){
            equation="0";
          }
        }
        else if(buttonText == "="){
          equationFontSize=38;
          resultFontSize=48;
          expression = equation;
          expression = expression.replaceAll("×", "*");
          expression = expression.replaceAll("÷", "/");

          try{
            Parser p = Parser();
            Expression exp = p.parse(expression);

            ContextModel cm = ContextModel();
            result = '${exp.evaluate(EvaluationType.REAL, cm)}';
          }
          catch(e){
            result="Error";
          }
        }
        else{
          equationFontSize=38;
          resultFontSize=48;
          if(equation=="0"){
            equation = buttonText;
          }
          else{
            equation = equation+buttonText;
          }

        }

      }
      );
  }

  Widget buildButton(String buttonText,double buttonHeight,Color buttonColor){
    return Container(
      height:MediaQuery.of(context).size.height*0.1*buttonHeight,
      color: buttonColor,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.teal,
          fixedSize: Size.fromWidth(100),
          padding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0.0),
            side: BorderSide(
                color: Colors.white,
                width: 1,
                style: BorderStyle.solid
            ),
          ),
        ),
        onPressed: ()=>buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.normal,
              color: Colors.white
          ),
        ),
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
          children: [
            SingleChildScrollView(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(10,20,10,0),
                child: Text(equation,style: TextStyle(fontSize: equationFontSize,color: Colors.white)),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                alignment: Alignment.centerRight,
                padding: EdgeInsets.fromLTRB(10,20,10,0),
                child: Text(result,style: TextStyle(fontSize: resultFontSize,color: Colors.white)),
              ),
            ),
            Expanded(
              child: Divider(),
            ),
            SingleChildScrollView(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width*0.75,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            buildButton("C", 1, Colors.redAccent),
                            buildButton("⌫", 1, Colors.redAccent),
                            buildButton("÷", 1, Colors.redAccent),
                          ]
                        ),
                        TableRow(
                            children: [
                              buildButton("7", 1, Colors.grey),
                              buildButton("8", 1, Colors.grey),
                              buildButton("9", 1, Colors.grey),
                            ]
                        ),
                        TableRow(
                            children: [
                              buildButton("4", 1, Colors.grey),
                              buildButton("5", 1, Colors.grey),
                              buildButton("6", 1, Colors.grey),
                            ]
                        ),
                        TableRow(
                            children: [
                              buildButton("1", 1, Colors.grey),
                              buildButton("2", 1, Colors.grey),
                              buildButton("3", 1, Colors.grey),
                            ]
                        ),
                        TableRow(
                            children: [
                              buildButton(".", 1, Colors.grey),
                              buildButton("0", 1, Colors.grey),
                              buildButton("00", 1, Colors.grey),
                            ]
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width*0.25,
                    child: Table(
                      children: [
                        TableRow(
                          children: [
                            buildButton("×", 1, Colors.blue),
                          ]
                        ),
                        TableRow(
                            children: [
                              buildButton("-", 1, Colors.blue),
                            ]
                        ),
                        TableRow(
                            children: [
                              buildButton("+", 1, Colors.blue),
                            ]
                        ),
                        TableRow(
                            children: [
                              buildButton("=", 2, Colors.redAccent),
                            ]
                        )
                      ],
                    ),
                  )
                ],
              ),
            )

          ],
        )
    );
  }
}
