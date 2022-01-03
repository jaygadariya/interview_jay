import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Rx<TextEditingController> _textEditingController =
      TextEditingController().obs;

  Rx<int> totalCount = 0.obs;

  @override
  void initState() {
    super.initState();
    _textEditingController.value.addListener(() {
      if (_textEditingController.value.text.trim().isNotEmpty) {
        if (!(int.parse(_textEditingController.value.text) % 2 == 0)) {
          _textEditingController.value.clear();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo App"),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Obx(() => Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _textEditingController.value,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ],
                        onChanged: (value) {},
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        totalCount.value =
                            int.parse(_textEditingController.value.text);
                      },
                      child: const Text("Submit"),
                    )
                  ],
                ),
                totalCount.value == 0
                    ? Container()
                    : Expanded(
                        child: GridView.count(
                          crossAxisCount: totalCount ~/ 2,
                          children: List.generate(
                            totalCount.value,
                            (index) => Container(
                              margin: const EdgeInsets.all(8.0),
                              height: 70,
                              width: 70,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      )
              ],
            )),
      ),
    );
  }
}
