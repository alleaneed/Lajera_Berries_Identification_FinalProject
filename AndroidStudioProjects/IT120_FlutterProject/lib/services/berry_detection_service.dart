import 'dart:io';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:image/image.dart' as img;
import 'package:flutter/services.dart';
import '../models/detection_result.dart';

class BerryDetectionService {
  static Interpreter? _interpreter;
  static List<String>? _labels;
  static bool _isInitialized = false;

  static Future<void> initialize() async {
    if (_isInitialized) return;

    try {
      // Load TFLite model
      _interpreter = await Interpreter.fromAsset('assets/models/model_unquant.tflite');
      
      // Load labels
      final labelsData = await rootBundle.loadString('assets/models/labels.txt');
      _labels = labelsData
          .split('\n')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      _isInitialized = true;
      print('BerryDetectionService initialized successfully');
      print('Labels loaded: ${_labels?.length}');
    } catch (e) {
      print('Failed to initialize detection service: $e');
      throw Exception('Failed to initialize detection service: $e');
    }
  }

  static Future<DetectionResult> detectBerry(File imageFile) async {
    if (!_isInitialized) {
      await initialize();
    }

    try {
      print('Starting berry detection for: ${imageFile.path}');
      print('File exists: ${imageFile.existsSync()}');
      print('File size: ${imageFile.lengthSync()} bytes');
      
      // Preprocess image
      final inputImage = _preprocessImage(imageFile);
      print('Image preprocessed successfully');
      print('Input shape: ${inputImage.length}x${inputImage[0].length}x${inputImage[0][0].length}');
      
      // Prepare output buffer
      final output = List.filled(1, List<double>.filled(_labels!.length, 0.0));
      print('Output buffer prepared with shape: ${output.length}x${output[0].length}');
      
      // Run inference
      _interpreter!.run(inputImage, output);
      print('Inference completed');
      
      // Process results
      final result = _processResults(output);
      print('Detection result: ${result.berryType} with ${result.confidence} confidence');
      
      return result;
    } catch (e, stackTrace) {
      print('Detection failed: $e');
      print('Stack trace: $stackTrace');
      throw Exception('Detection failed: $e');
    }
  }

  static List<List<List<List<double>>>> _preprocessImage(File imageFile) {
    try {
      print('Reading image file: ${imageFile.path}');
      final imageBytes = File(imageFile.path).readAsBytesSync();
      print('Image bytes read: ${imageBytes.length} bytes');
      
      final image = img.decodeImage(imageBytes);
      if (image == null) {
        throw Exception('Failed to decode image');
      }
      print('Image decoded: ${image.width}x${image.height}');
      
      // Resize to model input size (assuming 224x224)
      final resized = img.copyResize(image, width: 224, height: 224);
      print('Image resized to 224x224');
      
      // Normalize and convert to list
      final input = List.generate(1, (i) => List.generate(224, (y) {
        return List.generate(224, (x) {
          final pixel = resized.getPixel(x, y);
          // Normalize to [0, 1] and convert to float
          return [
            pixel.r / 255.0,
            pixel.g / 255.0,
            pixel.b / 255.0,
          ];
        });
      }));
      
      print('Input tensor created successfully');
      return input;
    } catch (e) {
      print('Image preprocessing failed: $e');
      rethrow;
    }
  }

  static DetectionResult _processResults(List<List<double>> output) {
    // Extract the first batch from output (since it's [1, 10])
    final predictions = output[0];
    
    // Find the prediction with highest confidence
    double maxConfidence = 0.0;
    int predictedIndex = 0;
    
    for (int i = 0; i < predictions.length; i++) {
      if (predictions[i] > maxConfidence) {
        maxConfidence = predictions[i];
        predictedIndex = i;
      }
    }
    
    final predictedLabel = _labels![predictedIndex];
    final confidencePercentage = (maxConfidence * 100).toStringAsFixed(2);
    
    return DetectionResult(
      berryType: predictedLabel,
      confidence: maxConfidence,
      confidencePercentage: confidencePercentage,
      allProbabilities: predictions,
      predictedIndex: predictedIndex,
      timestamp: DateTime.now(),
    );
  }

  static List<String> get supportedBerries => _labels ?? [];

  static bool get isInitialized => _isInitialized;

  static void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
    _isInitialized = false;
  }
}
