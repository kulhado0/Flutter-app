import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  static const String _title = 'How much I pay?';

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      home: Scaffold(
        appBar: AppBar(title: const Text(_title)),
        body: const Center(
          child: MyStatefulWidget(),
        ),
      ),
    );
  }
}

class MyStatefulWidget extends StatefulWidget {
  const MyStatefulWidget({Key? key}) : super(key: key);

  @override
  State<MyStatefulWidget> createState() => _MyStatefulWidgetState();
}

class _MyStatefulWidgetState extends State<MyStatefulWidget> {
  int _index = 0;
  double _currentSliderValue = 1;
  late TextEditingController _controller;
  late TextEditingController _controller1;

  double percentage = 0;
  double total_price = 0;
  int people = 0;

  double individual_price_result = 0;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller1 = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller1.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Stepper(
      currentStep: _index,
      onStepCancel: () {
        if (_index > 0) {
          setState(() {
            _index -= 1;
          });
        }
      },
      onStepContinue: () {
        if (_index < 2) {
          setState(() {
            _index += 1;
          });
        }else{
          setState(() {
            _index = 0;
          });
        }
      },
      onStepTapped: (int index) {
        setState(() {
          _index = index;
        });
      },

      steps: <Step>[
        Step(
          title: const Text('How many people'),
          content: Container(
          alignment: Alignment.centerLeft,
          child: Slider(
                value: _currentSliderValue,
                min: 1,
                max: 16,
                divisions: 15,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                setState(() {
                  _currentSliderValue = value;
                  people = value.toInt();
                  individual_price_result = (total_price+((percentage*total_price)/100))/people;
                });
            },),
          ),
          isActive: _index >= 0,
          state: _index >= 0 ?
          StepState.complete : StepState.disabled,
        ),
        // Step(
        //   title: const Text('Total price'),
        //   content: Container(
        //     alignment: Alignment.centerLeft,
        //     child: TextField(
        //       controller: _controller,
        //       onSubmitted: (String value) async {
        //       await showDialog<void>(
        //         context: context,
        //         builder: (BuildContext context) {
        //         return AlertDialog(
        //           title: const Text('Thanks!'),
        //           content: Text(
        //               'You typed "$value", which has length ${value.characters.length}.'),
        //               actions: <Widget>[
        //           TextButton(
        //                 onPressed: () {
        //                   Navigator.pop(context);
        //                 },
        //                 child: const Text('OK'),
        //               ),
        //             ],
        //           );
        //         },
        //      );
        //    },
        //   )
        // ),
        // ),
        Step(
          title: const Text('Payment'),
          content: Column(
            children:<Widget>[
              TextFormField(
                controller: _controller,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(labelText: 'Total price'),
                keyboardType: TextInputType.number,
                onChanged: (String price ) {
                  total_price = double.parse(price);
                  individual_price_result = (total_price+((percentage*total_price)/100))/people;
                },
              ),
              TextFormField(
                controller: _controller1,
                textInputAction: TextInputAction.done,
                decoration: InputDecoration(labelText: 'Service charge percentage'),
                keyboardType: TextInputType.number,
                onChanged: (String percentageValue ) {
                  percentage = double.parse(percentageValue);
                  individual_price_result = (total_price+((percentage*total_price)/100))/people;

                  print("People: $people");
                  print("Total Price: $total_price");
                  print("Final: $individual_price_result");
                },
              )
            ]
          ),
          isActive: _index >= 1,
          state: _index >= 1 ?
          StepState.complete : StepState.disabled,
        ),
        Step(
          title: const Text("Finished!"),
          content: Column(
            children: <Widget>[
              Text('You have to pay', style: TextStyle(fontSize: 30)),
              Text('$individual_price_result',style: TextStyle(fontSize: 24))
            ],
          ),

          isActive: _index >= 2,
          state: _index >= 1 ?
          StepState.complete : StepState.disabled,
        )
      ],
    );
  }
}