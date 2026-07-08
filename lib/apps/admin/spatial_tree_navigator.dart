import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';

/// 11-Tier Spatial Hierarchy Tree Navigator (SpatialTreeNavigator)
/// Renders Gujarat's complete 11-tier governance hierarchy from State down to IoT Sensor Nodes.
/// Enables hierarchical filtering for PFMS escrow audits and officer inspection queues.
class SpatialTreeNavigator extends StatelessWidget {
  final int selectedTierIndex;
  final Function(int tierIndex, Map<String, dynamic> tierData) onTierSelected;

  const SpatialTreeNavigator({
    super.key,
    required this.selectedTierIndex,
    required this.onTierSelected,
  });

  static final List<Map<String, dynamic>> hierarchyTiers = [
    {'tier': 1, 'id': 'STA-GUJ-0001', 'name': 'State of Gujarat', 'budget': '₹3.32 Lakh Cr', 'type': 'STATE'},
    {'tier': 2, 'id': 'DIS-GUJ-SRT', 'name': 'Surat District', 'budget': '₹45,000 Cr', 'type': 'DISTRICT'},
    {'tier': 3, 'id': 'PC-GUJ-SRT-0001', 'name': 'Surat PC', 'budget': '₹18,500 Cr', 'type': 'PARLIAMENT'},
    {'tier': 4, 'id': 'AC-GUJ-SRT-0160', 'name': 'Surat West AC', 'budget': '₹12,000 Cr', 'type': 'ASSEMBLY'},
    {'tier': 5, 'id': 'MUN-GUJ-SRT-SMC', 'name': 'Surat SMC', 'budget': '₹8,400 Cr', 'type': 'MUNICIPAL'},
    {'tier': 6, 'id': 'ZON-GUJ-SRT-SW', 'name': 'South West Zone', 'budget': '₹1,200 Cr', 'type': 'ZONE'},
    {'tier': 7, 'id': 'WRD-GUJ-SRT-0014', 'name': 'Adajan Ward 14', 'budget': '₹150 Cr', 'type': 'WARD'},
    {'tier': 8, 'id': 'SEC-ADAJAN-GAURAV', 'name': 'Gaurav Path Sector', 'budget': '₹45 Cr', 'type': 'SECTOR'},
    {'tier': 9, 'id': 'GRD-ADAJAN-ST04', 'name': 'Street Grid 04', 'budget': '₹12 Cr', 'type': 'STREET_GRID'},
    {'tier': 10, 'id': 'AST-ROADS-FLY01', 'name': 'Flyover Asset Grid', 'budget': '₹8 Cr', 'type': 'ASSET_GRID'},
    {'tier': 11, 'id': 'IOT-SENS-FLV-992', 'name': 'IoT Sensor Node 992', 'budget': 'Live Telemetry', 'type': 'IOT_NODE'},
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 260,
      color: const Color(0xFF090E17),
      padding: const EdgeInsets.all(JanSetuTheme.space16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('11-TIER SPATIAL HIERARCHY', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          const Text('Click boundary to filter PFMS Ledger', style: TextStyle(color: JanSetuColors.saffronGold, fontSize: 10)),
          const SizedBox(height: JanSetuTheme.space12),
          Expanded(
            child: ListView.builder(
              itemCount: hierarchyTiers.length,
              itemBuilder: (context, index) {
                final tierData = hierarchyTiers[index];
                final isSelected = selectedTierIndex == index;
                final tierNum = tierData['tier'] as int;
                final indent = (tierNum - 1) * 8.0;

                return InkWell(
                  onTap: () => onTierSelected(index, tierData),
                  borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 4),
                    padding: EdgeInsets.only(left: 6 + indent, right: 8, top: 8, bottom: 8),
                    decoration: BoxDecoration(
                      color: isSelected ? JanSetuColors.saffronGold.withAlpha(51) : Colors.transparent,
                      borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
                      border: Border.all(
                        color: isSelected ? JanSetuColors.saffronGold : Colors.transparent,
                        width: isSelected ? 1.5 : 0,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          _getTierIcon(tierData['type']),
                          size: 14,
                          color: isSelected ? JanSetuColors.saffronGold : Colors.grey,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${tierData['id']}',
                                style: TextStyle(color: isSelected ? JanSetuColors.saffronGold : Colors.grey[400], fontSize: 10, fontWeight: FontWeight.bold),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(
                                tierData['name'],
                                style: TextStyle(color: isSelected ? Colors.white : Colors.grey[300], fontSize: 12, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.arrow_forward_ios_rounded, color: JanSetuColors.saffronGold, size: 12),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(color: JanSetuColors.darkBorder),
          const SizedBox(height: 8),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withAlpha(38), borderRadius: BorderRadius.circular(4)),
                child: const Icon(Icons.lock_clock_rounded, color: JanSetuColors.emeraldGreen, size: 16),
              ),
              const SizedBox(width: 8),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('PFMS Smart Escrow', style: TextStyle(color: JanSetuColors.emeraldGreen, fontWeight: FontWeight.bold, fontSize: 12)),
                    Text('3-Stage Tranche Lock Active', style: TextStyle(color: Colors.grey, fontSize: 10), overflow: TextOverflow.ellipsis),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  IconData _getTierIcon(String type) {
    switch (type) {
      case 'STATE':
        return Icons.account_balance_rounded;
      case 'DISTRICT':
      case 'PARLIAMENT':
      case 'ASSEMBLY':
        return Icons.map_rounded;
      case 'MUNICIPAL':
      case 'ZONE':
        return Icons.location_city_rounded;
      case 'WARD':
      case 'SECTOR':
        return Icons.where_to_vote_rounded;
      case 'STREET_GRID':
      case 'ASSET_GRID':
        return Icons.add_road_rounded;
      case 'IOT_NODE':
      default:
        return Icons.sensors_rounded;
    }
  }
}
