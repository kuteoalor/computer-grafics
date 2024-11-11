import 'package:cglab3/field_cubit.dart';
import 'package:cglab3/field_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:two_dimensional_scrollables/two_dimensional_scrollables.dart';

class PixelGrid extends StatefulWidget {
  const PixelGrid({super.key});

  @override
  State<PixelGrid> createState() => _PixelGridState();
}

class _PixelGridState extends State<PixelGrid> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: InteractiveViewer(
        minScale: 0.8,
        maxScale: 2,
        //alignment: Alignment.center,
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
    if (vicinity.column == vicinity.row && vicinity.row == 0) {
      return const TableViewCell(
          child: Padding(
        padding: EdgeInsets.all(0.5),
        child: ColoredBox(
            color: Colors.white,
            child: Text(
              '-',
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
            (vicinity.row - 1).toString(),
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
              (vicinity.column - 1).toString(),
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
  int intensity = 0;

  final controller = OverlayPortalController();

  @override
  void initState() {
    var (isSelected1, intensity1) =
        BlocProvider.of<GridCubit>(context).checkIfSelected(widget.x, widget.y);
    isSelected = isSelected1;
    intensity = intensity1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GridCubit, GridState>(
      builder: (context, state) {
        return MouseRegion(
          onEnter: (event) {
            controller.toggle();
          },
          onExit: (event) {
            controller.toggle();
          },
          child: Padding(
            padding: const EdgeInsets.all(0.5),
            child: ColoredBox(
              color: isSelected
                  ? Color.fromARGB(intensity, 255, 255, 255)
                  : Colors.white,
              child: OverlayPortal(
                controller: controller,
                overlayChildBuilder: (_) {
                  return Positioned(
                    top: 15,
                    left: 15,
                    child: ColoredBox(
                      color: Colors.grey,
                      child: Text(
                        'x: ${widget.x - 1} y: ${widget.y - 1}',
                        style: TextStyle(
                          fontSize: 42,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        );
      },
      listener: (BuildContext context, GridState state) {
        var (isSelected1, intensity1) = BlocProvider.of<GridCubit>(context)
            .checkIfSelected(widget.x, widget.y);
        isSelected = isSelected1;
        intensity = intensity1;
      },
    );
  }
}
