import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';

/// My Area View (MyAreaView)
/// Redesigned visual neighborhood hub per Prompt 08 rules and Dark Mode audit:
/// Top Ward/Geohash/MP/Officer info, visual Development Score progress ring,
/// icon-based Infrastructure Health cards, Current/Upcoming Projects, and interactive contacts.
/// 100% high-contrast white, gold, and electric blue typography for strict Dark Mode readability.
class MyAreaView extends StatelessWidget {
  const MyAreaView({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Top Section: Ward name, geohash, MP name, Officer name
          Container(
            padding: const EdgeInsets.all(JanSetuTheme.space16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [JanSetuColors.slateNavy, Color(0xFF1E293B)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(JanSetuTheme.radiusLarge),
              border: Border.all(color: JanSetuColors.electricBlue.withValues(alpha: 0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: JanSetuColors.electricBlue.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.location_on_rounded, color: JanSetuColors.electricBlue, size: 24),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Adajan Ward 14, Surat West',
                            style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Geohash: te7uu1q • Surat Municipal Corporation',
                            style: TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(color: JanSetuColors.darkBorder, height: 24),
                Row(
                  children: [
                    Expanded(
                      child: _buildHeaderLeader('MP Jurisdiction', 'Hon. C.R. Patil', Icons.how_to_vote_rounded),
                    ),
                    Container(width: 1, height: 36, color: JanSetuColors.darkBorder),
                    Expanded(
                      child: _buildHeaderLeader('Ward Officer', 'Shri R.K. Joshi', Icons.engineering_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: JanSetuTheme.space24),

          // Development Score Visual Progress Ring
          const Text('Ward Development Score (AI Score: 84.2/100)', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: JanSetuTheme.space12),
          JanSetuCard(
            backgroundColor: JanSetuColors.darkSurface,
            border: BorderSide(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.3)),
            child: Row(
              children: [
                SizedBox(
                  width: 80,
                  height: 80,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircularProgressIndicator(
                        value: 0.842,
                        strokeWidth: 8,
                        backgroundColor: Colors.white12,
                        valueColor: const AlwaysStoppedAnimation<Color>(JanSetuColors.emeraldGreen),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('84.2', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
                          Text('/100', style: TextStyle(fontSize: 10, color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tier 1 Digital Twin Status', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: JanSetuColors.emeraldGreen)),
                      SizedBox(height: 4),
                      Text(
                        'Your ward ranks #1 in Surat with +3.4% quarterly infrastructure growth across water, drainage, and road networks.',
                        style: TextStyle(fontSize: 12, color: Colors.white70, height: 1.3),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: JanSetuTheme.space24),

          // Infrastructure Health (Visual Cards & Icons, No Tables)
          const Text('Infrastructure Health Matrix', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: JanSetuTheme.space12),
          LayoutBuilder(
            builder: (context, constraints) {
              final cards = [
                _buildHealthCard('Schools', '18 Active', '100% Health', Icons.school_rounded, JanSetuColors.emeraldGreen),
                _buildHealthCard('Hospitals', '6 24x7 Centers', 'SLA Verified', Icons.local_hospital_rounded, JanSetuColors.emeraldGreen),
                _buildHealthCard('Road Network', '92% Paved', 'Tranche 2 Work', Icons.edit_road_rounded, JanSetuColors.electricBlue),
                _buildHealthCard('Smart Water', '98.2% Grid', 'Optimal Pressure', Icons.water_drop_rounded, JanSetuColors.electricBlue),
                _buildHealthCard('Internet Grid', '100% Optical Fiber', 'Gigabit Ready', Icons.wifi_rounded, JanSetuColors.emeraldGreen),
                _buildHealthCard('Storm Drainage', '88% Resilient', 'Upgrade Active', Icons.thunderstorm_rounded, JanSetuColors.saffronGold),
              ];
              if (constraints.maxWidth > 500) {
                return Column(
                  children: [
                    Row(children: [Expanded(child: cards[0]), const SizedBox(width: 12), Expanded(child: cards[1])]),
                    const SizedBox(height: 12),
                    Row(children: [Expanded(child: cards[2]), const SizedBox(width: 12), Expanded(child: cards[3])]),
                    const SizedBox(height: 12),
                    Row(children: [Expanded(child: cards[4]), const SizedBox(width: 12), Expanded(child: cards[5])]),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: cards.map((c) => Padding(padding: const EdgeInsets.only(bottom: 12), child: c)).toList(),
              );
            },
          ),

          const SizedBox(height: JanSetuTheme.space24),

          // Current & Upcoming Projects Cards
          const Text('Ward Projects Overview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: JanSetuTheme.space12),
          JanSetuCard(
            backgroundColor: JanSetuColors.darkSurface,
            border: BorderSide(color: JanSetuColors.electricBlue.withValues(alpha: 0.4)),
            child: const Row(
              children: [
                Icon(Icons.engineering_rounded, color: JanSetuColors.electricBlue, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🚧 Current Active Construction', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: JanSetuColors.electricBlue)),
                      SizedBox(height: 2),
                      Text('4-Lane Elevated Flyover Mobilization • ₹12.50 Cr Sanctioned Outlay (40% Complete)', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          JanSetuCard(
            backgroundColor: JanSetuColors.darkSurface,
            border: BorderSide(color: JanSetuColors.emeraldGreen.withValues(alpha: 0.4)),
            child: const Row(
              children: [
                Icon(Icons.eco_rounded, color: JanSetuColors.emeraldGreen, size: 28),
                SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('🌱 Planned Upcoming Development', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: JanSetuColors.emeraldGreen)),
                      SizedBox(height: 2),
                      Text('Adajan Riverfront Solar Promenade FY 2026-27 • ₹5.00 Cr Proposed Outlay', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: JanSetuTheme.space24),

          // Interactive Contacts & Emergency Numbers
          const Text('Local Leadership & Emergency Contacts', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
          const SizedBox(height: JanSetuTheme.space12),
          Row(
            children: [
              Expanded(
                child: _buildContactCard(
                  context,
                  'Contact MP Office',
                  'Hon. C.R. Patil',
                  Icons.how_to_vote_rounded,
                  JanSetuColors.electricBlue,
                  'Message MP Secretariat',
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildContactCard(
                  context,
                  'Contact Ward Officer',
                  'Shri R.K. Joshi',
                  Icons.engineering_rounded,
                  JanSetuColors.emeraldGreen,
                  'Message Executive Eng.',
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          JanSetuCard(
            backgroundColor: JanSetuColors.darkSurface,
            border: BorderSide(color: JanSetuColors.crimsonAlert.withValues(alpha: 0.4)),
            child: Column(
              children: [
                const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.emergency_rounded, color: JanSetuColors.crimsonAlert, size: 18),
                    SizedBox(width: 6),
                    Text('Emergency Civic Hotlines', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: JanSetuColors.crimsonAlert)),
                  ],
                ),
                const Divider(color: JanSetuColors.darkBorder, height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHotline(context, 'Disaster', '1077', Icons.warning_rounded),
                    Container(width: 1, height: 36, color: JanSetuColors.darkBorder),
                    _buildHotline(context, 'Water Grid', '1800-233', Icons.support_agent_rounded),
                    Container(width: 1, height: 36, color: JanSetuColors.darkBorder),
                    _buildHotline(context, 'Police', '100', Icons.local_police_rounded),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderLeader(String label, String name, IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          Icon(icon, color: JanSetuColors.saffronGold, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: const TextStyle(color: JanSetuColors.darkTextSecondary, fontSize: 10)),
                Text(name, style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHealthCard(String title, String val, String status, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(color: color.withValues(alpha: 0.1), blurRadius: 6, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.white), overflow: TextOverflow.ellipsis),
                Text(val, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color), overflow: TextOverflow.ellipsis),
                Text(status, style: const TextStyle(fontSize: 10, color: Colors.white70), overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context, String title, String name, IconData icon, Color color, String action) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Opening secure messaging channel with $name...'), duration: const Duration(seconds: 2)),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: JanSetuColors.darkSurface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(backgroundColor: color, radius: 14, child: Icon(icon, color: Colors.white, size: 14)),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(title, style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color), overflow: TextOverflow.ellipsis),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white), overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('$action ➔', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
          ],
        ),
      ),
    );
  }

  Widget _buildHotline(BuildContext context, String title, String num, IconData icon) {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Dialing emergency hotline $num ($title)...'), duration: const Duration(seconds: 2)),
        );
      },
      child: Column(
        children: [
          Icon(icon, color: JanSetuColors.crimsonAlert, size: 20),
          const SizedBox(height: 4),
          Text(num, style: const TextStyle(color: JanSetuColors.crimsonAlert, fontSize: 13, fontWeight: FontWeight.bold)),
          Text(title, style: const TextStyle(color: Colors.white70, fontSize: 10)),
        ],
      ),
    );
  }
}
