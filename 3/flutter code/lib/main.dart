import 'package:cglab3/field_cubit.dart';
import 'package:cglab3/inf_table.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';
import 'package:group_button/group_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => GridCubit(),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

//const palette = PixelPalette(colors: [Colors.black, Colors.white]);

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // final controller = PixelImageController(
  //     palette: const PixelPalette.rPlace(), width: 64, height: 64);
  // late int heght;
  // late int width;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black,
      body: Row(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.3,
            child: ControlPanel(),
          ),
          Expanded(child: const PixelGrid()),
        ],
      ),
    );
  }
}

class ControlPanel extends StatefulWidget {
  ControlPanel({
    super.key,
  });

  @override
  State<ControlPanel> createState() => _ControlPanelState();
}

class _ControlPanelState extends State<ControlPanel> {
  final controller = GroupButtonController(selectedIndex: 0);

  final x1Controller = TextEditingController(text: '0');

  final y1Controller = TextEditingController(text: '0');

  final x2Controller = TextEditingController(text: '0');

  final y2Controller = TextEditingController(text: '0');

  int time = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GroupButton(
          onSelected: (value, index, isSelected) =>
              BlocProvider.of<GridCubit>(context).typeChanged(index),
          isRadio: true,
          controller: controller,
          buttons: const [
            'Stepwise',
            'DDA',
            'Brezenham',
            'Circle Brezenham',
          ],
        ),
        const SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              children: [
                Row(
                  children: [
                    const Text('x1:'),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                      width: 40,
                      child: TextFormField(
                        controller: x1Controller,
                        onFieldSubmitted: (value) {
                          try {
                            int val = int.parse(value);
                            if (val > 72 || val < 0) {
                              throw const FormatException();
                            }
                          } catch (e) {
                            x1Controller.text = '0';
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Invalid value!'),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    const Text('y1:'),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                        width: 40,
                        child: TextFormField(
                            controller: y1Controller,
                            onFieldSubmitted: (value) {
                              try {
                                int val = int.parse(value);
                                if (val > 52 || val < 0) {
                                  throw const FormatException();
                                }
                              } catch (e) {
                                y1Controller.text = '0';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid value!'),
                                  ),
                                );
                              }
                            })),
                  ],
                )
              ],
            ),
            const SizedBox(
              width: 60,
            ),
            Column(
              children: [
                Row(
                  children: [
                    const Text('x2:'),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                        width: 40,
                        child: TextFormField(
                            controller: x2Controller,
                            onFieldSubmitted: (value) {
                              try {
                                int val = int.parse(value);
                                if (val > 72 || val < 0) {
                                  throw const FormatException();
                                }
                              } catch (e) {
                                x2Controller.text = '0';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid value!'),
                                  ),
                                );
                              }
                            })),
                  ],
                ),
                Row(
                  children: [
                    const Text('y2:'),
                    const SizedBox(
                      width: 5,
                    ),
                    SizedBox(
                        width: 40,
                        child: TextFormField(
                            controller: y2Controller,
                            onFieldSubmitted: (value) {
                              try {
                                int val = int.parse(value);
                                if (val > 52 || val < 0) {
                                  throw const FormatException();
                                }
                              } catch (e) {
                                y2Controller.text = '0';
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Invalid value!'),
                                  ),
                                );
                              }
                            })),
                  ],
                )
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 30,
        ),
        ElevatedButton(
            onPressed: () {
              try {
                final x1 = int.parse(x1Controller.text);
                final x2 = int.parse(x2Controller.text);
                final y1 = int.parse(y1Controller.text);
                final y2 = int.parse(y2Controller.text);
                BlocProvider.of<GridCubit>(context).draw(x1, y1, x2, y2);
                setState(() {
                  time = BlocProvider.of<GridCubit>(context).getTime();
                });
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error...'),
                  ),
                );
              }
            },
            child: const Text('draw!')),
        const SizedBox(height: 40),
        Text('Time: $time microsec'),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () =>
              BlocProvider.of<GridCubit>(context).drawAntialiased(),
          child: const Text('make anti-aliased'),
        ),
        const SizedBox(height: 40),
        ElevatedButton(
          onPressed: () => BlocProvider.of<GridCubit>(context).clear(),
          child: const Text('clear'),
        ),
      ],
    );
  }
}
