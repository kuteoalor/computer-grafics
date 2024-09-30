import 'package:cg_lab1/views/cubit/color_cubit.dart';
import 'package:cg_lab1/views/cubit/color_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HSVView extends StatefulWidget {
  const HSVView({super.key});

  @override
  State<HSVView> createState() => _HSVViewState();
}

class _HSVViewState extends State<HSVView> {
  final hController = TextEditingController(text: '0');
  final sController = TextEditingController(text: '0');
  final vController = TextEditingController(text: '0');
  //int h = 0;
  //int s = 0;
  //int v = 0;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ColorCubit, ColorState>(
      builder: (context, state) {
        hController.text = state.h.toString();
        sController.text = state.s.toString();
        vController.text = state.v.toString();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('HSV'),
            Row(
              children: [
                const Text('H: '),
                SizedBox(
                  width: 40,
                  child: TextFormField(
                    controller: hController,
                    onFieldSubmitted: (value) {
                      try {
                        int val = int.parse(value);
                        if (val > 360 || val < 0) throw const FormatException();
                        BlocProvider.of<ColorCubit>(context)
                            .hsvChanged(val, state.s, state.v);
                        //hController.text = value;
                      } catch (e) {
                        hController.text = state.h.toString();
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
                    value: state.h.toDouble(),
                    max: 360,
                    onChanged: (value) {
                      hController.text = value.toInt().toString();
                      BlocProvider.of<ColorCubit>(context).hsvChanged(
                        value.toInt(),
                        state.s,
                        state.v,
                      );
                    }),
              ],
            ),
            Row(children: [
              const Text('S: '),
              SizedBox(
                width: 40,
                child: TextFormField(
                  controller: sController,
                  onFieldSubmitted: (value) {
                    try {
                      int val = int.parse(value);
                      if (val > 100 || val < 0) throw const FormatException();
                      BlocProvider.of<ColorCubit>(context)
                          .hsvChanged(state.h, val, state.v);
                    } catch (e) {
                      sController.text = state.r.toString();
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
                  value: state.s.toDouble(),
                  max: 100,
                  onChanged: (value) {
                    sController.text = value.toInt().toString();
                    BlocProvider.of<ColorCubit>(context).hsvChanged(
                      state.h,
                      value.toInt(),
                      state.v,
                    );
                  }),
            ]),
            Row(children: [
              const Text('V: '),
              SizedBox(
                width: 40,
                child: TextFormField(
                    controller: vController,
                    onFieldSubmitted: (value) {
                      try {
                        int val = int.parse(value);
                        if (val > 100 || val < 0) throw const FormatException();
                        BlocProvider.of<ColorCubit>(context)
                            .hsvChanged(state.h, state.s, val);
                      } catch (e) {
                        vController.text = state.r.toString();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Invalid value!'),
                          ),
                        );
                      }
                    }),
              ),
              Slider(
                  value: state.v.toDouble(),
                  max: 100,
                  onChanged: (value) {
                    vController.text = value.toInt().toString();
                    BlocProvider.of<ColorCubit>(context).hsvChanged(
                      state.h,
                      state.s,
                      value.toInt(),
                    );
                  }),
            ]),
          ],
        );
      },
    );
  }
}
