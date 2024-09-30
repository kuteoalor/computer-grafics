import 'package:cg_lab1/views/cmyk_view.dart';
import 'package:cg_lab1/views/cubit/color_cubit.dart';
import 'package:cg_lab1/views/cubit/color_state.dart';
import 'package:cg_lab1/views/hsv_view.dart';
import 'package:cg_lab1/views/rgb_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ColorCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const MyHomePage(title: 'LAB 1'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        //child: SizedBox(
        //width: 400,
        //child: BlocBuilder<ColorCubit, ColorState>(
        //builder: (context, state) {
        //return
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            BlocBuilder<ColorCubit, ColorState>(
              builder: (context, state) {
                return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: 300,
                        height: 300,
                        decoration: BoxDecoration(
                          color: Color.fromARGB(255, state.r, state.g, state.b),
                          border: Border.all(
                            color: Colors.black,
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      SizedBox(
                        width: 200,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text(
                                        'close',
                                        style: TextStyle(
                                          fontSize: 30,
                                        ),
                                      ),
                                    ),
                                  ],
                                  content: ColorPicker(
                                    pickerColor: Color.fromARGB(
                                        255, state.r, state.g, state.b),
                                    onColorChanged: (color) {
                                      BlocProvider.of<ColorCubit>(context)
                                          .colorChanged(color);
                                    },
                                  ),
                                );
                              },
                            );
                          },
                          child: const Text('Pick color'),
                        ),
                      ),
                    ]);
              },
            ),
            const SizedBox(
              height: 40,
            ),
            const IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RGBView(),
                  VerticalDivider(
                    color: Colors.black,
                  ),
                  HSVView(),
                  VerticalDivider(
                    color: Colors.black,
                  ),
                  CMYKView(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ignore: constant_identifier_names
enum ColorSchemeType { RGB, CMYK, HSV }

extension ColorSchemeExt on ColorSchemeType {
  String get name {
    switch (this) {
      case ColorSchemeType.RGB:
        return 'RGB';
      case ColorSchemeType.CMYK:
        return 'CMYK';
      case ColorSchemeType.HSV:
        return 'HSV';
    }
  }
}
