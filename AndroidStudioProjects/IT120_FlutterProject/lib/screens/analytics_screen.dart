import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../services/firebase_service.dart';
import '../widgets/analytics_card.dart';
import '../widgets/empty_state_widget.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  Map<String, dynamic>? _analyticsData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAnalytics();
  }

  Future<void> _loadAnalytics() async {
    try {
      final data = await FirebaseService.getAnalytics();
      setState(() {
        _analyticsData = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load analytics: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Analytics',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF87CEEB),
        foregroundColor: Colors.white,
        elevation: 4,
        centerTitle: true,
        shadowColor: Colors.black26,
        actions: [
          IconButton(
            onPressed: _loadAnalytics,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _analyticsData == null || _analyticsData!['totalDetections'] == 0
              ? const EmptyStateWidget(
                  icon: Icons.analytics,
                  title: 'No Analytics Data',
                  subtitle: 'Start identifying berries to see your analytics here',
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOverviewCards(),
                      const SizedBox(height: 24),
                      _buildBerryDistributionChart(),
                      const SizedBox(height: 24),
                      _buildConfidenceAnalytics(),
                    ],
                  ),
                ),
    );
  }

  Widget _buildOverviewCards() {
    final totalDetections = _analyticsData!['totalDetections'] as int;
    final avgConfidence = (_analyticsData!['averageConfidence'] as double) * 100;
    final berryTypes = (_analyticsData!['berryCounts'] as Map<String, int>).length;

    return Row(
      children: [
        Expanded(
          child: AnalyticsCard(
            title: 'Total Detections',
            value: totalDetections.toString(),
            icon: Icons.search,
            color: const Color(0xFF1976D2),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AnalyticsCard(
            title: 'Avg Confidence',
            value: '${avgConfidence.toStringAsFixed(1)}%',
            icon: Icons.trending_up,
            color: const Color(0xFFFF9800),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: AnalyticsCard(
            title: 'Berry Types',
            value: berryTypes.toString(),
            icon: Icons.eco,
            color: const Color(0xFF42A5F5),
          ),
        ),
      ],
    );
  }

  Widget _buildBerryDistributionChart() {
    final berryCounts = _analyticsData!['berryCounts'] as Map<String, int>;
    final totalDetections = _analyticsData!['totalDetections'] as int;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Berry Distribution',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 200,
              child: PieChart(
                PieChartData(
                  sections: berryCounts.entries.map((entry) {
                    final percentage = (entry.value / totalDetections) * 100;
                    return PieChartSectionData(
                      value: entry.value.toDouble(),
                      title: '${percentage.toStringAsFixed(1)}%',
                      titleStyle: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      color: _getBerryColor(entry.key),
                      radius: 50,
                    );
                  }).toList(),
                  sectionsSpace: 2,
                  centerSpaceRadius: 40,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: berryCounts.keys.map((berry) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getBerryColor(berry),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      berry,
                      style: const TextStyle(fontSize: 12),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfidenceAnalytics() {
    final avgConfidence = (_analyticsData!['averageConfidence'] as double) * 100;

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Confidence Analytics',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1976D2),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Average Confidence'),
                      Text(
                        '${avgConfidence.toStringAsFixed(1)}%',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1976D2),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  LinearProgressIndicator(
                    value: avgConfidence / 100,
                    backgroundColor: Colors.grey[200],
                    valueColor: AlwaysStoppedAnimation<Color>(
                      avgConfidence >= 80
                          ? const Color(0xFF388E3C)
                          : avgConfidence >= 60
                              ? const Color(0xFFFF9800)
                              : const Color(0xFFD32F2F),
                    ),
                    minHeight: 8,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getBerryColor(String berry) {
    final colors = [
      const Color(0xFF1976D2),
      const Color(0xFF42A5F5),
      const Color(0xFFFF9800),
      const Color(0xFFE53935),
      const Color(0xFF1976D2),
      const Color(0xFF9C27B0),
      const Color(0xFF795548),
      const Color(0xFF607D8B),
      const Color(0xFF009688),
      const Color(0xFFCDDC39),
    ];
    
    final berryNames = [
      'Cranberry', 'Golden Berry', 'Raspberry', 'Blackberry', 'Blueberry',
      'Strawberry', 'Pineberry', 'Cloudberry', 'Huckleberry', 'Gooseberry'
    ];
    
    final index = berryNames.indexOf(berry);
    return index >= 0 ? colors[index % colors.length] : Colors.grey;
  }
}
