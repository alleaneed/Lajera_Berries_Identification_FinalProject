import 'package:cloud_firestore/cloud_firestore.dart';

class DetectionResult {
  final String berryType;
  final double confidence;
  final String confidencePercentage;
  final List<double> allProbabilities;
  final int predictedIndex;
  final DateTime timestamp;

  DetectionResult({
    required this.berryType,
    required this.confidence,
    required this.confidencePercentage,
    required this.allProbabilities,
    required this.predictedIndex,
    required this.timestamp,
  });

  Map<String, dynamic> toMap() {
    return {
      'berryType': berryType,
      'confidence': confidence,
      'confidencePercentage': confidencePercentage,
      'allProbabilities': allProbabilities,
      'predictedIndex': predictedIndex,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory DetectionResult.fromMap(Map<String, dynamic> map) {
    return DetectionResult(
      berryType: map['berryType'] ?? '',
      confidence: map['confidence']?.toDouble() ?? 0.0,
      confidencePercentage: map['confidencePercentage'] ?? '',
      allProbabilities: List<double>.from(map['allProbabilities'] ?? []),
      predictedIndex: map['predictedIndex']?.toInt() ?? 0,
      timestamp: map['timestamp'] is Timestamp 
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.parse(map['timestamp'] ?? DateTime.now().toIso8601String()),
    );
  }
}
