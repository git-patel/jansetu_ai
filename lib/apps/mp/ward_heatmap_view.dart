import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';

/// GIS Ward Deficit Heatmap View (WardHeatmapView)
/// Renders an interactive 2D spatial grid of municipal wards in Surat Constituency.
/// Color-codes wards by AI Deficit Score and enables 1-Tap MPLADS fund sanctions.
class WardHeatmapView extends StatefulWidget {
  final double remainingMpladsFundINR;
  final Function(Map<String, dynamic> newProject, double sanctionAmountINR) onSanction;
  final Widget? banner;
  final bool isEmbedded;

  const WardHeatmapView({
    super.key,
    required this.remainingMpladsFundINR,
    required this.onSanction,
    this.banner,
    this.isEmbedded = false,
  });

  @override
  State<WardHeatmapView> createState() => _WardHeatmapViewState();
}

class _WardHeatmapViewState extends State<WardHeatmapView> {
  int _selectedWardIndex = 0; // Default select Ward 8 Varachha (most critical)

  final List<Map<String, dynamic>> _wards = [
    {
      'id': 'WARD_08_VARACHHA',
      'name': 'Ward 8 Varachha',
      'aiScore': 52.4,
      'status': 'CRITICAL_DEFICIT',
      'population': '4.2 Lakhs',
      'topDeficit': 'Severe Drainage & Flood Risk',
      'waterSla': 64,
      'drainageHealth': 48,
      'activeGrievances': 142,
    },
    {
      'id': 'WARD_03_UDHNA',
      'name': 'Ward 3 Udhna',
      'aiScore': 58.1,
      'status': 'CRITICAL_DEFICIT',
      'population': '3.8 Lakhs',
      'topDeficit': 'Road Potholes & Congestion',
      'waterSla': 72,
      'drainageHealth': 61,
      'activeGrievances': 98,
    },
    {
      'id': 'WARD_21_RANDER',
      'name': 'Ward 21 Rander',
      'aiScore': 71.0,
      'status': 'MODERATE_NEEDS',
      'population': '2.9 Lakhs',
      'topDeficit': 'Water Pressure SLA Breach',
      'waterSla': 68,
      'drainageHealth': 74,
      'activeGrievances': 64,
    },
    {
      'id': 'WARD_19_KATARGAM',
      'name': 'Ward 19 Katargam',
      'aiScore': 76.5,
      'status': 'MODERATE_NEEDS',
      'population': '3.5 Lakhs',
      'topDeficit': 'Streetlight Grid Outage',
      'waterSla': 82,
      'drainageHealth': 79,
      'activeGrievances': 45,
    },
    {
      'id': 'WARD_14_ADAJAN',
      'name': 'Ward 14 Adajan',
      'aiScore': 84.2,
      'status': 'HEALTHY_TWIN',
      'population': '3.1 Lakhs',
      'topDeficit': 'Minor Park Maintenance',
      'waterSla': 94,
      'drainageHealth': 91,
      'activeGrievances': 18,
    },
    {
      'id': 'WARD_12_ATHWA',
      'name': 'Ward 12 Athwa',
      'aiScore': 88.9,
      'status': 'HEALTHY_TWIN',
      'population': '2.4 Lakhs',
      'topDeficit': 'Smart Kiosk Upgrades',
      'waterSla': 98,
      'drainageHealth': 95,
      'activeGrievances': 12,
    },
  ];

  Color _getScoreColor(double score) {
    if (score < 60) return JanSetuColors.crimsonAlert;
    if (score < 80) return JanSetuColors.saffronGold;
    return JanSetuColors.emeraldGreen;
  }

  void _executeSanction() {
    final selectedWard = _wards[_selectedWardIndex];
    final double sanctionAmount = 5000000.0; // ₹50 Lakhs

    if (widget.remainingMpladsFundINR < sanctionAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ Insufficient MPLADS Fund balance for this allocation.')),
      );
      return;
    }

    final newProject = {
      'projectName': 'MPLADS Emergency Works: ${selectedWard['topDeficit']} (${selectedWard['name']})',
      'departmentId': 'DEPT_URBAN_DEV',
      'financials': {
        'sanctionedBudgetINR': sanctionAmount,
        'disbursedAmountINR': 1000000.0, // Initial 20% release
      },
      'progressPercentage': 5,
      'currentStatus': 'SANCTIONED_MPLADS',
      'timestamp': DateTime.now().toIso8601String(),
    };

    widget.onSanction(newProject, sanctionAmount);
  }

  @override
  Widget build(BuildContext context) {
    final selectedWard = _wards[_selectedWardIndex];
    final scoreColor = _getScoreColor(selectedWard['aiScore']);

    final contentList = [
      if (widget.banner != null) ...[
        widget.banner!,
        const SizedBox(height: JanSetuTheme.space16),
      ],
      // Constituency Header & MPLADS Balance
      Container(
        padding: const EdgeInsets.all(JanSetuTheme.space16),
        decoration: BoxDecoration(
          color: JanSetuColors.darkSurface,
          borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
          border: Border.all(color: JanSetuColors.saffronGold.withAlpha(102)),
        ),
        child: Wrap(
          alignment: WrapAlignment.spaceBetween,
          crossAxisAlignment: WrapCrossAlignment.center,
          spacing: 16,
          runSpacing: 12,
          children: [
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('SURAT CONSTITUENCY (PC-GUJ-SRT-0001)', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                SizedBox(height: 4),
                Text('GIS Ward Deficit Heatmap', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
              ],
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: JanSetuColors.saffronGold.withAlpha(38),
                borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
                border: Border.all(color: JanSetuColors.saffronGold),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text('MPLADS Available Fund', style: TextStyle(color: JanSetuColors.saffronGold, fontSize: 10, fontWeight: FontWeight.bold)),
                  Text(
                    '₹${(widget.remainingMpladsFundINR / 10000000).toStringAsFixed(2)} Crore',
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      const SizedBox(height: JanSetuTheme.space16),
      const Text('SELECT WARD TILE TO INSPECT SLA DEFICITS', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
      const SizedBox(height: JanSetuTheme.space8),
      // 2D Spatial Ward Grid (Responsive max extent grid)
      GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 380,
          mainAxisExtent: 115,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
        ),
        itemCount: _wards.length,
            itemBuilder: (context, index) {
              final ward = _wards[index];
              final isSelected = index == _selectedWardIndex;
              final color = _getScoreColor(ward['aiScore']);

              return InkWell(
                onTap: () => setState(() => _selectedWardIndex = index),
                borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
                child: Container(
                  padding: const EdgeInsets.all(JanSetuTheme.space12),
                  decoration: BoxDecoration(
                    color: isSelected ? color.withAlpha(51) : JanSetuColors.darkSurface,
                    borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
                    border: Border.all(
                      color: isSelected ? color : color.withAlpha(102),
                      width: isSelected ? 2.5 : 1.0,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(ward['name'], style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(4)),
                            child: Text('${ward['aiScore']}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 11)),
                          ),
                        ],
                      ),
                      Text(ward['topDeficit'], style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w500), maxLines: 2, overflow: TextOverflow.ellipsis),
                      Text('Pop: ${ward['population']} • Grievances: ${ward['activeGrievances']}', style: const TextStyle(color: Colors.grey, fontSize: 10)),
                    ],
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: JanSetuTheme.space24),
          // Department-wise Issue Distribution Chart
          Container(
            padding: const EdgeInsets.all(JanSetuTheme.space16),
            decoration: BoxDecoration(
              color: JanSetuColors.darkSurface,
              borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
              border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.bar_chart_rounded, color: JanSetuColors.electricBlue, size: 20),
                    SizedBox(width: 8),
                    Text('📊 Constituency Deficit Analytics by Department', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14)),
                  ],
                ),
                const SizedBox(height: 16),
                _buildDeptChartBar('Roads & Bridges (Potholes, Resurfacing)', 0.45, '45% (142 Issues)', JanSetuColors.saffronGold),
                const SizedBox(height: 10),
                _buildDeptChartBar('Water & Drainage (Pipeline, Flooding)', 0.30, '30% (98 Issues)', JanSetuColors.electricBlue),
                const SizedBox(height: 10),
                _buildDeptChartBar('Power & Streetlights (Solar Grid Outage)', 0.15, '15% (45 Issues)', JanSetuColors.emeraldGreen),
                const SizedBox(height: 10),
                _buildDeptChartBar('Urban Development & Sanitation', 0.10, '10% (30 Issues)', JanSetuColors.crimsonAlert),
              ],
            ),
          ),
          const SizedBox(height: JanSetuTheme.space24),
          // Selected Ward SLA Inspection & Sanction Action Panel
          Container(
            padding: const EdgeInsets.all(JanSetuTheme.space24),
            decoration: BoxDecoration(
              color: JanSetuColors.darkSurface,
              borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
              border: Border.all(color: scoreColor, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          Icon(Icons.analytics_outlined, color: scoreColor, size: 20),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text('DIGITAL TWIN INSPECTION: ${selectedWard['name'].toUpperCase()}', style: TextStyle(color: scoreColor, fontWeight: FontWeight.bold, fontSize: 13), overflow: TextOverflow.ellipsis),
                          ),
                        ],
                      ),
                    ),
                    Text('${selectedWard['status']}', style: TextStyle(color: scoreColor, fontSize: 11, fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: JanSetuTheme.space16),
                _buildSlaBar('Water Pressure SLA Health', selectedWard['waterSla'], JanSetuColors.electricBlue),
                const SizedBox(height: JanSetuTheme.space12),
                _buildSlaBar('Drainage & Flood Resilience', selectedWard['drainageHealth'], JanSetuColors.emeraldGreen),
                const SizedBox(height: JanSetuTheme.space16),
                Container(
                  padding: const EdgeInsets.all(JanSetuTheme.space12),
                  decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall)),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: JanSetuColors.saffronGold, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'AI Recommendation: Immediate capital allocation required for "${selectedWard['topDeficit']}". Will boost Ward AI score by +15.0%.',
                          style: const TextStyle(color: Colors.white70, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: JanSetuTheme.space24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _executeSanction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: JanSetuColors.saffronGold,
                  foregroundColor: JanSetuColors.slateNavy,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                icon: const Icon(Icons.flash_on_rounded, size: 20),
                label: Text(
                  'Sanction ₹50 Lakhs for ${selectedWard['name']} Emergency Works',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      ),
    ];

    if (widget.isEmbedded) {
      return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: contentList);
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(JanSetuTheme.space16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: contentList),
    );
  }

  Widget _buildSlaBar(String label, int percentage, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 12), overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text('$percentage%', style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: percentage / 100.0,
            backgroundColor: Colors.grey[800],
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 6,
          ),
        ),
      ],
    );
  }

  Widget _buildDeptChartBar(String label, double ratio, String valText, Color color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 12), overflow: TextOverflow.ellipsis)),
            const SizedBox(width: 8),
            Text(valText, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: Colors.white10,
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 10,
          ),
        ),
      ],
    );
  }
}
