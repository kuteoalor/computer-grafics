import 'package:cg_lab1/views/cubit/color_cubit.dart';
import 'package:cg_lab1/views/cubit/color_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CMYKView extends StatefulWidget {
  const CMYKView({super.key});

  @override
  State<CMYKView> createState() => _CMYKViewState();
}

class _CMYKViewState extends State<CMYKView> {
  // int c = 0;
  // int m = 0;
  // int y = 0;
  // int k = 0;
  final cController = TextEditingController(text: '0');
  final mController = TextEditingController(text: '0');
  final yController = TextEditingController(text: '0');
  final kController = TextEditingController(text: '0');

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorCubit, ColorState>(
      builder: (context, state) {
        cController.text = state.c.toString();
        kController.text = state.k.toString();
        mController.text = state.m.toString();
        yController.text = state.y.toString();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('CMYK'),
            Row(
              children: [
                const Text('C: '),
                SizedBox(
                  width: 40,
                  child: TextFormField(
                      controller: cController,
                      onFieldSubmitted: (value) {
                        try {
                          int val = int.parse(value);
                          if (val > 100 || val < 0)
                            throw const FormatException();
                          BlocProvider.of<ColorCubit>(context)
                              .cmykChanged(val, state.m, state.y, state.k);
                        } catch (e) {
                          cController.text = state.r.toString();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Invalid value!'),
                            ),
                          );
                        }
                      }),
                ),
                Slider(
                    value: state.c.toDouble(),
                    max: 100,
                    onChanged: (value) {
                      cController.text = value.toInt().toString();
                      BlocProvider.of<ColorCubit>(context).cmykChanged(
                        value.toInt(),
                        state.m,
                        state.y,
                        state.k,
                      );
                    }),
              ],
            ),
            Row(children: [
              const Text('M: '),
              SizedBox(
                width: 40,
                child: TextFormField(
                    controller: mController,
                    onFieldSubmitted: (value) {
                      try {
                        int val = int.parse(value);
                        if (val > 100 || val < 0) throw const FormatException();
                        BlocProvider.of<ColorCubit>(context)
                            .cmykChanged(state.c, val, state.y, state.k);
                      } catch (e) {
                        mController.text = state.r.toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid value!'),
                          ),
                        );
                      }
                    }),
              ),
              Slider(
                  value: state.m.toDouble(),
                  max: 100,
                  onChanged: (value) {
                    setState(() {
                      mController.text = value.toInt().toString();
                      BlocProvider.of<ColorCubit>(context).cmykChanged(
                        state.c,
                        value.toInt(),
                        state.y,
                        state.k,
                      );
                    });
                  }),
            ]),
            Row(children: [
              const Text('Y: '),
              SizedBox(
                width: 40,
                child: TextFormField(
                    controller: yController,
                    onFieldSubmitted: (value) {
                      try {
                        int val = int.parse(value);
                        if (val > 100 || val < 0) throw const FormatException();
                        BlocProvider.of<ColorCubit>(context)
                            .cmykChanged(state.c, state.m, val, state.k);
                      } catch (e) {
                        yController.text = state.r.toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid value!'),
                          ),
                        );
                      }
                    }),
              ),
              Slider(
                  value: state.y.toDouble(),
                  max: 100,
                  onChanged: (value) {
                    yController.text = value.toInt().toString();
                    BlocProvider.of<ColorCubit>(context).cmykChanged(
                      state.c,
                      state.m,
                      value.toInt(),
                      state.k,
                    );
                  }),
            ]),
            Row(children: [
              const Text('K: '),
              SizedBox(
                width: 40,
                child: TextFormField(
                    controller: kController,
                    onFieldSubmitted: (value) {
                      try {
                        int val = int.parse(value);
                        if (val > 100 || val < 0) throw const FormatException();
                        BlocProvider.of<ColorCubit>(context)
                            .cmykChanged(state.c, state.m, state.y, val);
                      } catch (e) {
                        kController.text = state.r.toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid value!'),
                          ),
                        );
                      }
                    }),
              ),
              Slider(
                  value: state.k.toDouble(),
                  max: 100,
                  onChanged: (value) {
                    kController.text = value.toInt().toString();
                    BlocProvider.of<ColorCubit>(context)
                        .cmykChanged(state.c, state.m, state.y, value.toInt());
                  }),
            ]),
          ],
        );
      },
    );
  }
}
