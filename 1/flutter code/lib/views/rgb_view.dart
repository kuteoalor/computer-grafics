import 'package:cg_lab1/views/cubit/color_cubit.dart';
import 'package:cg_lab1/views/cubit/color_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RGBView extends StatefulWidget {
  const RGBView({super.key});

  @override
  State<RGBView> createState() => _RGBViewState();
}

class _RGBViewState extends State<RGBView> {
  final rController = TextEditingController(text: '0');
  final gController = TextEditingController(text: '0');
  final bController = TextEditingController(text: '0');
  //int r = 0;
  //int g = 0;
  //int b = 0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorCubit, ColorState>(
      builder: (context, state) {
        rController.text = state.r.toString();
        bController.text = state.b.toString();
        gController.text = state.g.toString();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('RGB'),
            Row(
              children: [
                const Text('R: '),
                SizedBox(
                  width: 40,
                  child: TextFormField(
                    controller: rController,
                    onFieldSubmitted: (value) {
                      try {
                        int val = int.parse(value);
                        if (val > 255 || val < 0) throw const FormatException();
                        BlocProvider.of<ColorCubit>(context).rChanged(val);
                      } catch (e) {
                        rController.text = state.r.toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid value!'),
                          ),
                        );
                      }
                    },
                  ),
                ),
                Slider(
                  value: state.r.toDouble(),
                  max: 255,
                  onChanged: (value) {
                    rController.text = value.toInt().toString();
                    BlocProvider.of<ColorCubit>(context)
                        .rChanged(value.toInt());
                  },
                ),
              ],
            ),
            Row(children: [
              const Text('G: '),
              SizedBox(
                width: 40,
                child: TextFormField(
                  controller: gController,
                  onFieldSubmitted: (value) {
                    try {
                      int val = int.parse(value);
                      if (val > 255 || val < 0) throw const FormatException();
                      BlocProvider.of<ColorCubit>(context).gChanged(val);
                    } catch (e) {
                      gController.text = state.g.toString();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid value!'),
                        ),
                      );
                    }
                  },
                ),
              ),
              Slider(
                  value: state.g.toDouble(),
                  max: 255,
                  onChanged: (value) {
                    gController.text = value.toInt().toString();
                    setState(() {
                      BlocProvider.of<ColorCubit>(context)
                          .gChanged(value.toInt());
                    });
                  }),
            ]),
            Row(children: [
              const Text('B: '),
              SizedBox(
                width: 40,
                child: TextFormField(
                  controller: bController,
                  onFieldSubmitted: (value) {
                    try {
                      int val = int.parse(value);
                      if (val > 255 || val < 0) throw const FormatException();
                      BlocProvider.of<ColorCubit>(context).bChanged(val);
                    } catch (e) {
                      bController.text = state.b.toString();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Invalid value!'),
                        ),
                      );
                    }
                  },
                ),
              ),
              Slider(
                  value: state.b.toDouble(),
                  max: 255,
                  onChanged: (value) {
                    bController.text = value.toInt().toString();
                    setState(() {
                      BlocProvider.of<ColorCubit>(context)
                          .bChanged(value.toInt());
                    });
                  }),
            ]),
          ],
        );
      },
    );
  }
}
