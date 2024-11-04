// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:cglab3/field_cubit.dart';
import 'package:cglab3/field_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

/// The class demonstrating an infinite number of rows and columns in
/// TableView.
class InfiniteTableExample extends StatefulWidget {
  /// Creates a screen that demonstrates an infinite TableView widget.
  const InfiniteTableExample({super.key});

  @override
  State<InfiniteTableExample> createState() => _InfiniteExampleState();
}

class _InfiniteExampleState extends State<InfiniteTableExample> {
  int? _rowCount;
  int? _columnCount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: InteractiveViewer(
        minScale: 0.8,
        maxScale: 1.5,
        //panEnabled: false,
        //trackpadScrollCausesScale: true,
        //constrained: false,
        child: TableView.builder(
          pinnedColumnCount: 1,
          pinnedRowCount: 1,
          cellBuilder: _buildCell,
          columnCount: 72,
          columnBuilder: _buildSpan,
          rowCount: 54,
          rowBuilder: _buildSpan,
          diagonalDragBehavior: DiagonalDragBehavior.free,
        ),
      ),
      persistentFooterAlignment: AlignmentDirectional.center,
    );
  }

  TableViewCell _buildCell(BuildContext context, TableVicinity vicinity) {
    // final Color boxColor =
    //     switch ((vicinity.row.isEven, vicinity.column.isEven)) {
    //   (true, false) || (false, true) => Colors.white,
    //   (false, false) => Colors.indigo[100]!,
    //   (true, true) => Colors.indigo[200]!
    // };
    if (vicinity.column == vicinity.row && vicinity.row == 0) {
      return const TableViewCell(
          child: Padding(
        padding: EdgeInsets.all(0.5),
        child: ColoredBox(
            color: Colors.white,
            child: Text(
              '0',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
              ),
            )),
      ));
    } else if (vicinity.column == 0) {
      return TableViewCell(
          child: Padding(
        padding: const EdgeInsets.all(0.5),
        child: ColoredBox(
          color: Colors.white,
          child: Text(
            vicinity.row.toString(),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 11,
            ),
          ),
        ),
      ));
    } else if (vicinity.row == 0) {
      return TableViewCell(
          child: Padding(
        padding: const EdgeInsets.all(0.5),
        child: ColoredBox(
            color: Colors.white,
            child: Text(
              vicinity.column.toString(),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 11,
              ),
            )),
      ));
    } else {
      return TableViewCell(
        child: ClickablePixel(
          x: vicinity.column,
          y: vicinity.row,
        ),
      );
    }
  }

  TableSpan _buildSpan(int index) {
    return const TableSpan(extent: FixedTableSpanExtent(15));
  }
}

class ClickablePixel extends StatefulWidget {
  final int x;
  final int y;
  const ClickablePixel({
    super.key,
    required this.x,
    required this.y,
  });

  @override
  State<ClickablePixel> createState() => _ClickablePixelState();
}

class _ClickablePixelState extends State<ClickablePixel> {
  bool isSelected = false;

  @override
  void initState() {
    isSelected = BlocProvider.of<FieldCubit>(context)
        .checkIfSelected(widget.x, widget.y);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FieldCubit, FieldState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.all(0.5),
          child: ColoredBox(
            color: isSelected ? Colors.black : Colors.white,
          ),
        );
      },
      listener: (BuildContext context, FieldState state) {
        isSelected = BlocProvider.of<FieldCubit>(context)
            .checkIfSelected(widget.x, widget.y);
      },
    );
  }
}
