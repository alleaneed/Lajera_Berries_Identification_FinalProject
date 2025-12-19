import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/detection_result.dart';

class FirebaseService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  static Future<bool> testConnection() async {
    try {
      await _firestore.collection('test').limit(1).get();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<void> logDetection(DetectionResult result) async {
    try {
      print('Attempting to log detection to Firebase...');
      print('Berry type: ${result.berryType}');
      print('Confidence: ${result.confidence}');
      print('Timestamp: ${result.timestamp}');
      
      final docRef = await _firestore.collection('detections').add({
        'berryType': result.berryType,
        'confidence': result.confidence,
        'confidencePercentage': result.confidencePercentage,
        'timestamp': Timestamp.fromDate(result.timestamp),
        'predictedIndex': result.predictedIndex,
        'allProbabilities': result.allProbabilities,
      });
      
      print('Detection logged successfully with document ID: ${docRef.id}');
    } catch (e) {
      print('Failed to log detection to Firebase: $e');
      print('Stack trace: ${StackTrace.current}');
      throw Exception('Failed to log detection: $e');
    }
  }

  static Stream<QuerySnapshot> getDetectionHistory(String filter) {
    Query query = _firestore
        .collection('detections')
        .orderBy('timestamp', descending: true);

    switch (filter) {
      case 'Today':
        final today = DateTime.now();
        final startOfDay = DateTime(today.year, today.month, today.day);
        query = query.where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(startOfDay));
        break;
      case 'This Week':
        final now = DateTime.now();
        final weekAgo = now.subtract(const Duration(days: 7));
        query = query.where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(weekAgo));
        break;
      case 'This Month':
        final now = DateTime.now();
        final monthAgo = DateTime(now.year, now.month - 1, now.day);
        query = query.where('timestamp', isGreaterThanOrEqualTo: Timestamp.fromDate(monthAgo));
        break;
      case 'All':
      default:
        break;
    }

    return query.snapshots();
  }

  static Future<void> deleteDetection(String docId) async {
    try {
      await _firestore.collection('detections').doc(docId).delete();
    } catch (e) {
      throw Exception('Failed to delete detection: $e');
    }
  }

  static Future<Map<String, dynamic>> getAnalytics() async {
    try {
      final snapshot = await _firestore.collection('detections').get();
      final detections = snapshot.docs;

      final berryCounts = <String, int>{};
      final confidenceScores = <double>[];
      final dailyCounts = <String, int>{};

      for (final doc in detections) {
        final data = doc.data();
        final berryType = data['berryType'] as String;
        final confidence = data['confidence'] as double;
        final timestamp = (data['timestamp'] as Timestamp).toDate();

        berryCounts[berryType] = (berryCounts[berryType] ?? 0) + 1;
        confidenceScores.add(confidence);

        final dayKey = '${timestamp.year}-${timestamp.month.toString().padLeft(2, '0')}-${timestamp.day.toString().padLeft(2, '0')}';
        dailyCounts[dayKey] = (dailyCounts[dayKey] ?? 0) + 1;
      }

      return {
        'totalDetections': detections.length,
        'berryCounts': berryCounts,
        'averageConfidence': confidenceScores.isEmpty 
            ? 0.0 
            : confidenceScores.reduce((a, b) => a + b) / confidenceScores.length,
        'dailyCounts': dailyCounts,
      };
    } catch (e) {
      throw Exception('Failed to get analytics: $e');
    }
  }
}
