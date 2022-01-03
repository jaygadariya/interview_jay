import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

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
  Rx<int> sqrt = 0.obs;
  Timer? t;

  Rx<int> generatedNumber = 0.obs;
  RxList clickedTile = [].obs;

  isPerfectSqrt(int num) {
    sqrt.value = math.sqrt(num).toInt();
    if ((sqrt.value * sqrt.value) == num) {
      return true;
    } else {
      return false;
    }
  }

  generateRandomNumber() {
    if (clickedTile.length == int.parse(_textEditingController.value.text)) {
      print("game over");
      t?.cancel();
    } else {
      nextNum();
      t = Timer.periodic(Duration(seconds: 10), (timer) {
        nextNum();
        print(generatedNumber.value);
      });
    }
  }

  nextNum() {
    int temp =
        math.Random().nextInt(int.parse(_textEditingController.value.text));
    if (clickedTile.contains(temp)) {
      nextNum();
    } else {
      generatedNumber.value = temp;
    }
  }

  @override
  void initState() {
    super.initState();
    _textEditingController.value.addListener(() {
      Future.delayed(Duration(seconds: 1), () {
        if (_textEditingController.value.text.trim().isNotEmpty) {
          if (!isPerfectSqrt(int.parse(_textEditingController.value.text))) {
            _textEditingController.value.clear();
          }
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(.8),
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
                      ),
                    ),
                    MaterialButton(
                      onPressed: () {
                        if (isPerfectSqrt(
                            int.parse(_textEditingController.value.text))) {
                          totalCount.value = sqrt.value;
                          generateRandomNumber();
                        }
                      },
                      child: const Text("Submit"),
                    )
                  ],
                ),
                totalCount.value == 0
                    ? Container()
                    : Expanded(
                        child: GridView.count(
                          crossAxisCount: totalCount.value,
                          children: List.generate(
                            int.parse(_textEditingController.value.text),
                            (index) => GestureDetector(
                              onTap: () {
                                if (generatedNumber.value == index) {
                                  t?.cancel();
                                  generateRandomNumber();
                                  clickedTile.add(index);
                                }
                              },
                              child: Container(
                                margin: const EdgeInsets.all(8.0),
                                height: 70,
                                width: 70,
                                decoration: BoxDecoration(
                                  color: clickedTile.contains(index)
                                      ? Colors.blueGrey
                                      : generatedNumber.value == index
                                          ? Colors.red
                                          : Colors.white,
                                  border: Border.all(
                                    color: Colors.blueGrey,
                                    width: 1,
                                  ),
                                ),
                                child: Text("$index"),
                              ),
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
