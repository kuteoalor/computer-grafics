// ignore_for_file: avoid_print

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:opencv_dart/opencv_dart.dart' as cv;
import 'package:image_picker/image_picker.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final labels = [
    'Default',
    'RGB equalization',
    'HSV equalization',
    'Segmentation',
    'Linear contrast',
  ];
  var images = <Uint8List>[];
  var mats = <cv.Mat>[];

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<cv.Mat> getRGBHist(cv.Mat img) async {
    final split = cv.split(img);
    final mask = cv.Mat.ones(img.rows, img.cols, 0 as cv.MatType);
    var bhist = await cv.calcHistAsync(
      cv.VecMat.fromList([split[0]]),
      cv.VecI32.fromList([0]),
      mask,
      cv.VecI32.fromList([256]),
      cv.VecF32.fromList([0, 256]),
    );
    var ghist = await cv.calcHistAsync(
      cv.VecMat.fromList([split[1]]),
      cv.VecI32.fromList([0]),
      mask,
      cv.VecI32.fromList([256]),
      cv.VecF32.fromList([0, 256]),
    );
    var rhist = await cv.calcHistAsync(
      cv.VecMat.fromList([split[2]]),
      cv.VecI32.fromList([0]),
      mask,
      cv.VecI32.fromList([256]),
      cv.VecF32.fromList([0, 256]),
    );
    int hist_w = 512, hist_h = 400;
    int bin_w = hist_w ~/ 256;
    var histImage = cv.Mat.create(
        rows: hist_h, cols: hist_w, r: 0, g: 0, b: 0, type: cv.MatType.CV_8UC3);
    //final mask1 = cv.Mat.ones(rhist.rows, rhist.cols, 0 as cv.MatType);
    cv.normalize(rhist, rhist,
        normType: cv.NORM_MINMAX, alpha: 0, beta: histImage.rows.toDouble());
    cv.normalize(ghist, ghist,
        normType: cv.NORM_MINMAX, alpha: 0, beta: histImage.rows.toDouble());
    cv.normalize(bhist, bhist,
        normType: cv.NORM_MINMAX, alpha: 0, beta: histImage.rows.toDouble());
    var rlisttemp = rhist.toList();
    final rlist = rlisttemp.map((el) => el[0].toInt()).toList();
    var glisttemp = ghist.toList();
    final glist = glisttemp.map((el) => el[0].toInt()).toList();
    var blisttemp = bhist.toList();
    final blist = blisttemp.map((el) => el[0].toInt()).toList();
    for (int i = 1; i < 256; i++) {
      // print('\n');
      // print('${bin_w * (i - 1)}, ${hist_h - blist[i - 1]}');
      // print(blist[i - 1]);
      cv.line(histImage, cv.Point(bin_w * (i - 1), hist_h - blist[i - 1]),
          cv.Point(bin_w * i, hist_h - blist[i]), cv.Scalar.blue);

      cv.line(histImage, cv.Point(bin_w * (i - 1), hist_h - glist[i - 1]),
          cv.Point(bin_w * i, hist_h - glist[i]), cv.Scalar.green);

      cv.line(histImage, cv.Point(bin_w * (i - 1), hist_h - rlist[i - 1]),
          cv.Point(bin_w * i, hist_h - rlist[i]), cv.Scalar.red);
    }
    return (histImage);
  }

  Future<cv.Mat> linearContrasting(cv.Mat image) async {
    var grayImg = await cv.cvtColorAsync(image, cv.COLOR_BGR2GRAY);
    grayImg = cv.equalizeHist(grayImg);
    return await cv.cvtColorAsync(grayImg, cv.COLOR_GRAY2BGR);
  }

  Future<(cv.Mat, cv.Mat)> normalizeRGBandHist(cv.Mat image) async {
    final split = cv.split(image);
    final b = cv.equalizeHist(split[0]);
    final g = cv.equalizeHist(split[1]);
    final r = cv.equalizeHist(split[2]);

    final normImage = cv.merge(cv.VecMat.fromList([b, g, r]));
    final hist = await getRGBHist(normImage);
    return (normImage, hist);
  }

  Future<(cv.Mat, cv.Mat)> normalizeHSVandHist(cv.Mat image) async {
    final hsvImg = await cv.cvtColorAsync(image, cv.COLOR_BGR2HSV);
    final split = cv.split(hsvImg);
    final v = cv.equalizeHist(split[2]);

    var normImage = cv.merge(cv.VecMat.fromList([split[0], split[1], v]));
    normImage = await cv.cvtColorAsync(normImage, cv.COLOR_HSV2BGR);
    final hist = await getRGBHist(normImage);
    return (normImage, hist);
  }

  Future<
      (
        cv.Mat,
        cv.Mat,
        cv.Mat,
        cv.Mat,
        cv.Mat,
        cv.Mat,
        cv.Mat,
        cv.Mat,
        cv.Mat,
        cv.Mat,
      )> heavyTaskAsync(cv.Mat im, {int count = 1000}) async {
    late cv.Mat gray,
        segmented,
        regHist,
        rgbNormIm,
        rgbNormHist,
        hsvNormIm,
        hsvNormHist,
        grayNorm,
        grayNormHist;
    for (var i = 0; i < count; i++) {
      gray = await cv.cvtColorAsync(im, cv.COLOR_BGR2GRAY); // grayscale

      regHist = await getRGBHist(im); // rgb диаграма исходного изображения

      (rgbNormIm, rgbNormHist) = await normalizeRGBandHist(
          im); // rgb-нормализованное изображение и гистогр

      (hsvNormIm, hsvNormHist) =
          await normalizeHSVandHist(im); // hsv-норм изобр и гистогр
      final tmep = await gray.meanAsync();
      print(tmep.val);
      (_, segmented) = await cv.thresholdAsync(gray, tmep.val1, 255,
          cv.THRESH_BINARY_INV); // сегментированое grayscale

      grayNorm = await linearContrasting(im);
      grayNormHist = await getRGBHist(grayNorm);

      if (i != count - 1) {
        gray.dispose(); // manually dispose
        segmented.dispose(); // manually dispose
      }
    }
    return (
      im,
      regHist,
      rgbNormIm,
      rgbNormHist,
      hsvNormIm,
      hsvNormHist,
      gray,
      segmented,
      grayNorm,
      grayNormHist,
    );
    //return (im, gray, segmented, regHist, eqImHist, eqHist);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.grey,
        appBar: AppBar(
          title: const Text('Image processing with OpenCV'),
        ),
        body: Container(
          alignment: Alignment.center,
          child: Column(
            children: [
              ElevatedButton(
                onPressed: () async {
                  final picker = ImagePicker();
                  final img =
                      await picker.pickImage(source: ImageSource.gallery);
                  if (img != null) {
                    final path = img.path;
                    final mat = cv.imread(path);

                    print(
                        "cv.imread: width: ${mat.cols}, height: ${mat.rows}, path: $path");
                    debugPrint("mat.data.length: ${mat.data.length}");
                    // heavy computation
                    // final (im, gray, segmented, hist, eqImHist, eqHist) =
                    //     await heavyTaskAsync(mat, count: 1);
                    final (
                      im,
                      regHist,
                      rgbNormIm,
                      rgbNormHist,
                      hsvNormIm,
                      hsvNormHist,
                      gray,
                      segmented,
                      grayNorm,
                      grayNormHist,
                    ) = await heavyTaskAsync(mat, count: 1);
                    setState(() {
                      mats = [
                        im,
                        regHist,
                        rgbNormIm,
                        rgbNormHist,
                        hsvNormIm,
                        hsvNormHist,
                        gray,
                        segmented,
                        grayNorm,
                        grayNormHist,
                      ];
                      images = [
                        //cv.imencode(".png", mat).$2,
                        cv.imencode(".png", im).$2,
                        cv.imencode(".png", regHist).$2,
                        cv.imencode(".png", rgbNormIm).$2,
                        cv.imencode(".png", rgbNormHist).$2,
                        cv.imencode(".png", hsvNormIm).$2,
                        cv.imencode(".png", hsvNormHist).$2,
                        cv.imencode(".png", gray).$2,
                        cv.imencode(".png", segmented).$2,
                        cv.imencode(".png", grayNorm).$2,
                        cv.imencode(".png", grayNormHist).$2,
                      ];
                    });
                  }
                },
                child: const Text("Pick Image"),
              ),
              Expanded(
                  child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemBuilder: (_, i) {
                  return Column(
                    children: [
                      Text(
                        labels[i],
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.3,
                        height: 290,
                        child: Image.memory(
                          images[2 * i],
                          fit: BoxFit.contain,
                        ),
                      ),
                      //const SizedBox(height: 4,),
                      ElevatedButton(
                        onPressed: () async {
                          var outputFile = await FilePickerWindows().saveFile(
                            dialogTitle: 'Select an output file',
                            fileName: 'image.png',
                          );
                          print(outputFile);
                          if (outputFile != null) {
                            if (!outputFile.endsWith('.png') ||
                                outputFile.endsWith('.jpg') ||
                                outputFile.endsWith('.jpeg')) {
                              outputFile += '.png';
                            }
                            // final mat = mats[2 * i];
                            // cv.imwrite(outputFile, mat);
                            File(outputFile).writeAsBytes(images[2 * i]);
                          }
                        },
                        child: Text('Save'),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      if (i < 4)
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          height: 290,
                          child: Image.memory(
                            images[2 * i + 1],
                            fit: BoxFit.contain,
                          ),
                        ),
                      if (i < 4)
                        ElevatedButton(
                          onPressed: () async {
                            var outputFile = await FilePickerWindows().saveFile(
                              dialogTitle: 'Select an output file',
                              fileName: 'image.png',
                            );
                            print(outputFile);
                            if (outputFile != null) {
                              if (!outputFile.endsWith('.png') ||
                                  outputFile.endsWith('.jpg') ||
                                  outputFile.endsWith('.jpeg')) {
                                outputFile += '.png';
                              }
                              // final mat = mats[2 * i];
                              // cv.imwrite(outputFile, mat);
                              File(outputFile).writeAsBytes(images[2 * i + 1]);
                            }
                          },
                          child: Text('Save'),
                        ),
                    ],
                  );
                },
                itemCount: 5,
              )
                  // child: GridView.count(

                  //   crossAxisCount: 2,
                  //   mainAxisSpacing: 20,
                  //   crossAxisSpacing: 20,
                  //   scrollDirection: Axis.horizontal,
                  //   children: images.map((image) {
                  //     return SizedBox(
                  //       width: MediaQuery.of(context).size.width * 0.3,
                  //       height: 300,
                  //       child: Image.memory(
                  //         image,
                  //         fit: BoxFit.contain,
                  //       ),
                  //     );
                  //   }).toList(),
                  // ),
                  ),
            ],
          ),
        ),
      ),
    );
  }
}
