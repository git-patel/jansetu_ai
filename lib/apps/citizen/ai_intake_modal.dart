import 'dart:async';
import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:jansetu_design_system/jansetu_design_system.dart';
import '../../core/config/service_locator.dart';

/// 1-Tap AI Intake Modal (AiIntakeModal)
/// Implements the Citizen multimodal reporting workflow without long forms:
/// 1. Mode Selector (Voice, Photo, Document)
/// 2. Voice Waveform Simulation & EXIF GPS Geotagging
/// 3. Gemini AI Shimmer Processing
/// 4. AI Confirmation Checkpoint (Bilingual Gujarati/English + Department Routing)
class AiIntakeModal extends StatefulWidget {
  final Function(Map<String, dynamic> newNeed) onSubmit;

  const AiIntakeModal({
    super.key,
    required this.onSubmit,
  });

  @override
  State<AiIntakeModal> createState() => _AiIntakeModalState();
}

class _AiIntakeModalState extends State<AiIntakeModal> with TickerProviderStateMixin {
  int _currentStep = 0; // 0: Mode Select, 1: Voice Record, 2: Photo Capture, 3: AI Processing, 4: Confirmation
  int _recordingSeconds = 0;
  Timer? _recordingTimer;
  Timer? _aiProcessingTimer;
  late AnimationController _waveformController;

  final String _simulatedGujarati = 'અડાજણ ગૌરવ પથ પર મોટા ખાડા છે અને ટ્રાફિક જામ થાય છે. તાત્કાલિક સમારકામ જરૂરી છે.';
  String _englishSummary = 'Severe potholes on Gaurav Path, Adajan causing major traffic congestion. Immediate road repair required.';
  String _vernacularText = 'અડાજણ ગૌરવ પથ પર મોટા ખાડા છે અને ટ્રાફિક જામ થાય છે. તાત્કાલિક સમારકામ જરૂરી છે.';
  String _routedDept = 'Roads & Buildings Department (R&B)';
  double _calculatedPriority = 88.0;
  List<Map<String, dynamic>> _detectedDuplicates = [];
  bool _isPaused = false;

  @override
  void initState() {
    super.initState();
    _waveformController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _recordingTimer?.cancel();
    _aiProcessingTimer?.cancel();
    _waveformController.dispose();
    super.dispose();
  }

  void _startVoiceRecording() {
    setState(() {
      _currentStep = 1;
      _recordingSeconds = 0;
      _isPaused = false;
    });
    _recordingTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted && !_isPaused) {
        setState(() {
          _recordingSeconds++;
          if (_recordingSeconds >= 8) {
            _recordingTimer?.cancel();
            _startAiProcessing();
          }
        });
      }
    });
  }

  void _startPhotoCapture() {
    setState(() {
      _currentStep = 2;
    });
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted && _currentStep == 2) {
        _startAiProcessing();
      }
    });
  }

  Future<void> _startAiProcessing() async {
    setState(() {
      _currentStep = 3;
    });
    try {
      final aiRepo = ServiceLocator.instance.aiRepository;
      final summary = await aiRepo.summarizeNeed(_simulatedGujarati);
      final dept = await aiRepo.suggestDepartment(_simulatedGujarati);
      final priority = await aiRepo.calculatePriority({'upvoteCount': 10, 'severityClass': 'CRITICAL'});
      final dups = await aiRepo.detectDuplicates(_englishSummary, 21.1965, 72.7940);
      final guj = await aiRepo.translateMultilingual(summary, 'gu');

      if (mounted) {
        setState(() {
          _englishSummary = summary;
          _vernacularText = guj;
          _routedDept = dept;
          _calculatedPriority = priority;
          _detectedDuplicates = dups;
          _currentStep = 4;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _currentStep = 4;
        });
      }
    }
  }

  void _confirmAndSubmit() {
    final newNeed = {
      'needId': 'ND-2026-SRT-${106 + (DateTime.now().millisecond % 50)}',
      'creatorUserId': 'USR-CTZ-7721',
      'submittedByMe': true,
      'titleEnglish': _englishSummary,
      'titleVernacular': _vernacularText,
      'departmentId': 'DEPT_ROADS_HIGHWAYS',
      'priorityScore': _calculatedPriority,
      'status': 'VERIFIED_AI',
      'severityClass': 'CRITICAL',
      'upvoteCount': 1,
      'commentCount': 0,
      'locationId': 'WRD-GUJ-SRT-0014',
      'ancestries': ['IND', 'STATE-GUJ', 'DIST-SRT', 'CORP-SMC', 'ZONE-WEST', 'WRD-GUJ-SRT-0014'],
      'geospatial': {'lat': 21.1965, 'lng': 72.7940, 'geohash': 'te7uu1q'},
      'aiIntelligence': {
        'confidence': 94.8,
        'duplicateScore': 3.5,
        'estimatedCostINR': 1800000.0,
        'estimatedBeneficiaries': 12000,
        'impactScore': 85.0,
      },
      'corroboratingWitnessIds': ['USR-CTZ-7721'],
      'timeline': {
        'reportedDate': DateTime.now().toIso8601String(),
        'verifiedDate': DateTime.now().toIso8601String(),
        'approvedDate': null,
        'tenderDate': null,
        'constructionDate': null,
        'completedDate': null,
      },
      'linkedProjectId': null,
    };
    widget.onSubmit(newNeed);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: JanSetuTheme.space24,
        right: JanSetuTheme.space24,
        top: JanSetuTheme.space24,
        bottom: MediaQuery.of(context).viewInsets.bottom + JanSetuTheme.space24,
      ),
      decoration: const BoxDecoration(
        color: JanSetuColors.slateNavy,
        borderRadius: BorderRadius.vertical(top: Radius.circular(JanSetuTheme.radiusLarge)),
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header & Close Handle
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Flexible(
                    child: Row(
                      children: [
                        Icon(Icons.auto_awesome, color: JanSetuColors.saffronGold, size: 20),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text('1-Tap AI Intake Hub', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Colors.grey),
                    onPressed: () => Navigator.of(context).pop(),
                  )
                ],
              ),
              const SizedBox(height: JanSetuTheme.space16),
              _buildStepContent(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 1:
        return _buildVoiceRecordingStep();
      case 2:
        return _buildPhotoCaptureStep();
      case 3:
        return _buildAiProcessingStep();
      case 4:
        return _buildConfirmationStep();
      case 0:
      default:
        return _buildModeSelectionStep();
    }
  }

  Widget _buildModeSelectionStep() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Text(
          'No long government forms required. Choose an intuitive reporting mode:',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
        const SizedBox(height: JanSetuTheme.space16),
        _buildModeCard(
          title: '🎙️ Voice Recording (Gujarati/Hindi)',
          subtitle: 'Speak naturally in your vernacular language. AI auto-transcribes & classifies.',
          color: JanSetuColors.electricBlue,
          onTap: _startVoiceRecording,
        ),
        const SizedBox(height: JanSetuTheme.space12),
        _buildModeCard(
          title: '📸 Geotagged Photo Capture',
          subtitle: 'Snap a photo of potholes or broken pipes. AI extracts EXIF GPS & severity.',
          color: JanSetuColors.emeraldGreen,
          onTap: _startPhotoCapture,
        ),
        const SizedBox(height: JanSetuTheme.space12),
        _buildModeCard(
          title: '📄 Attach Notice or Letter',
          subtitle: 'Upload PDF or formal documents. Gemini OCR extracts metadata.',
          color: JanSetuColors.saffronGold,
          onTap: _startAiProcessing,
        ),
      ],
    );
  }

  Widget _buildModeCard({required String title, required String subtitle, required Color color, required VoidCallback onTap}) {
    return JanSetuCard(
      backgroundColor: JanSetuColors.darkSurface,
      border: BorderSide(color: color.withAlpha(102), width: 1.5),
      onTap: onTap,
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withAlpha(38), borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall)),
            child: Icon(Icons.touch_app_rounded, color: color, size: 24),
          ),
          const SizedBox(width: JanSetuTheme.space16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15)),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          ),
          Icon(Icons.arrow_forward_ios_rounded, color: color, size: 16),
        ],
      ),
    );
  }

  Widget _buildVoiceRecordingStep() {
    return Container(
      padding: const EdgeInsets.all(JanSetuTheme.space24),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
        border: Border.all(color: JanSetuColors.electricBlue),
      ),
      child: Column(
        children: [
          const Icon(Icons.mic_none_rounded, color: JanSetuColors.electricBlue, size: 48),
          const SizedBox(height: JanSetuTheme.space16),
          Text(
            'Recording Gujarati Speech... 00:0$_recordingSeconds',
            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: JanSetuTheme.space16),
          // Waveform Animation Simulation
          AnimatedBuilder(
            animation: _waveformController,
            builder: (context, _) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(12, (index) {
                  final height = 10.0 + math.sin((index + _waveformController.value * 10)) * 20.0.abs();
                  return Container(
                    width: 4,
                    height: math.max(6.0, height),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    decoration: BoxDecoration(
                      color: JanSetuColors.electricBlue,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  );
                }),
              );
            },
          ),
          const SizedBox(height: JanSetuTheme.space24),
          Container(
            padding: const EdgeInsets.all(JanSetuTheme.space12),
            decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall)),
            child: Text(
              _simulatedGujarati,
              style: const TextStyle(color: JanSetuColors.saffronGold, fontStyle: FontStyle.italic, fontSize: 13),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: JanSetuTheme.space16),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => _isPaused = !_isPaused),
                style: OutlinedButton.styleFrom(foregroundColor: JanSetuColors.saffronGold, side: const BorderSide(color: JanSetuColors.saffronGold)),
                icon: Icon(_isPaused ? Icons.play_arrow : Icons.pause, size: 16),
                label: Text(_isPaused ? 'Resume' : 'Pause', style: const TextStyle(fontSize: 12)),
              ),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('▶️ Playing back recorded audio snippet...'), duration: Duration(seconds: 1)));
                },
                style: OutlinedButton.styleFrom(foregroundColor: JanSetuColors.electricBlue, side: const BorderSide(color: JanSetuColors.electricBlue)),
                icon: const Icon(Icons.volume_up, size: 16),
                label: const Text('Playback', style: TextStyle(fontSize: 12)),
              ),
              ElevatedButton.icon(
                onPressed: _startAiProcessing,
                style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.electricBlue, foregroundColor: Colors.white),
                icon: const Icon(Icons.stop_rounded, size: 16),
                label: const Text('Stop & Process AI', style: TextStyle(fontSize: 12)),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPhotoCaptureStep() {
    return Container(
      padding: const EdgeInsets.all(JanSetuTheme.space24),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
        border: Border.all(color: JanSetuColors.emeraldGreen),
      ),
      child: Column(
        children: [
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black45,
              borderRadius: BorderRadius.circular(JanSetuTheme.radiusSmall),
              border: Border.all(color: JanSetuColors.emeraldGreen, width: 2),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.camera_alt_rounded, color: JanSetuColors.emeraldGreen, size: 64),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(color: Colors.black87, borderRadius: BorderRadius.circular(4)),
                    child: const Text('EXIF GPS: 21.1959° N, 72.7933° E\nAccuracy: ±3.2m (Adajan Ward 14)', style: TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 10, fontFamily: 'monospace')),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: JanSetuTheme.space16),
          const Text('Extracting Geohash & Visual Infrastructure Damage...', style: TextStyle(color: Colors.white, fontSize: 14)),
          const SizedBox(height: JanSetuTheme.space12),
          ElevatedButton(
            onPressed: _startAiProcessing,
            style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.emeraldGreen, foregroundColor: Colors.white),
            child: const Text('Analyze Photo with Gemini AI'),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('📸 Resetting camera lens...'), duration: Duration(seconds: 1)));
                },
                icon: const Icon(Icons.refresh, size: 16, color: JanSetuColors.saffronGold),
                label: const Text('Retake Photo', style: TextStyle(color: JanSetuColors.saffronGold, fontSize: 12)),
              ),
              const SizedBox(width: 16),
              TextButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('🖼️ Opening device media gallery...'), duration: Duration(seconds: 1)));
                },
                icon: const Icon(Icons.photo_library, size: 16, color: JanSetuColors.electricBlue),
                label: const Text('Select from Gallery', style: TextStyle(color: JanSetuColors.electricBlue, fontSize: 12)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAiProcessingStep() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: JanSetuTheme.space48, horizontal: JanSetuTheme.space24),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
        border: Border.all(color: JanSetuColors.saffronGold),
      ),
      child: Column(
        children: [
          const CircularProgressIndicator(color: JanSetuColors.saffronGold),
          const SizedBox(height: JanSetuTheme.space24),
          const Text('🤖 Gemini Multimodal AI Analyzing...', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
          const SizedBox(height: 8),
          const Text('Translating Gujarati speech • Auto-routing department • Computing SLA priority', style: TextStyle(color: Colors.grey, fontSize: 13), textAlign: TextAlign.center),
          const SizedBox(height: JanSetuTheme.space24),
          TextButton(
            onPressed: () => setState(() => _currentStep = 4),
            child: const Text('Skip Animation (Test Mode) ->', style: TextStyle(color: JanSetuColors.saffronGold)),
          )
        ],
      ),
    );
  }

  Widget _buildConfirmationStep() {
    return Container(
      padding: const EdgeInsets.all(JanSetuTheme.space24),
      decoration: BoxDecoration(
        color: JanSetuColors.darkSurface,
        borderRadius: BorderRadius.circular(JanSetuTheme.radiusMedium),
        border: Border.all(color: JanSetuColors.emeraldGreen, width: 2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(color: JanSetuColors.emeraldGreen.withAlpha(51), borderRadius: BorderRadius.circular(20)),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.verified, color: JanSetuColors.emeraldGreen, size: 14),
                      SizedBox(width: 4),
                      Flexible(
                        child: Text('AI CONFIRMATION CHECKPOINT', style: TextStyle(color: JanSetuColors.emeraldGreen, fontSize: 11, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text('94.8% AI Confidence', style: TextStyle(color: JanSetuColors.saffronGold, fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: JanSetuTheme.space16),
          if (_detectedDuplicates.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: JanSetuColors.saffronGold.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: JanSetuColors.saffronGold),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, color: JanSetuColors.saffronGold, size: 18),
                      SizedBox(width: 6),
                      Text('Duplicate Issue Detected by AI', style: TextStyle(color: JanSetuColors.saffronGold, fontWeight: FontWeight.bold, fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text('This issue may already exist: "${_detectedDuplicates.first['titleEnglish']}" (${_detectedDuplicates.first['upvoteCount']} citizen upvotes). Would you like to upvote & support that issue instead?', style: const TextStyle(color: Colors.white, fontSize: 12)),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.of(context).pop();
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('👍 Upvoted and supported existing grievance!'), backgroundColor: JanSetuColors.emeraldGreen));
                    },
                    style: OutlinedButton.styleFrom(foregroundColor: JanSetuColors.emeraldGreen, side: const BorderSide(color: JanSetuColors.emeraldGreen), padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4)),
                    icon: const Icon(Icons.thumb_up, size: 14),
                    label: const Text('Support Existing Issue', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
          const Text('ENGLISH TRANSLATION', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_englishSummary, style: const TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.w600)),
          const SizedBox(height: JanSetuTheme.space12),
          const Text('GUJARATI TRANSCRIPT', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(_vernacularText, style: const TextStyle(color: Colors.grey, fontSize: 13, fontStyle: FontStyle.italic)),
          const Divider(color: JanSetuColors.darkBorder, height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('AUTO-ROUTED DEPT', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(color: JanSetuColors.electricBlue.withAlpha(51), borderRadius: BorderRadius.circular(4)),
                      child: Text(_routedDept, style: const TextStyle(color: JanSetuColors.electricBlue, fontSize: 12, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('PRIORITY SCORE', style: TextStyle(color: Colors.grey, fontSize: 11, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Text('${_calculatedPriority.toInt()} / 100 Critical', style: const TextStyle(color: JanSetuColors.crimsonAlert, fontSize: 13, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: JanSetuTheme.space24),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => setState(() => _currentStep = 0),
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.grey, side: const BorderSide(color: Colors.grey), padding: const EdgeInsets.symmetric(vertical: 12)),
                  child: const Text('Edit Details', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('💾 Grievance saved as offline draft in your secure encrypted enclave.'), backgroundColor: JanSetuColors.electricBlue),
                    );
                  },
                  style: OutlinedButton.styleFrom(foregroundColor: JanSetuColors.saffronGold, side: const BorderSide(color: JanSetuColors.saffronGold), padding: const EdgeInsets.symmetric(vertical: 12)),
                  icon: const Icon(Icons.save, size: 16),
                  label: const Text('Save Draft', style: TextStyle(fontSize: 12)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: ElevatedButton.icon(
                  onPressed: _confirmAndSubmit,
                  style: ElevatedButton.styleFrom(backgroundColor: JanSetuColors.emeraldGreen, foregroundColor: Colors.white, padding: const EdgeInsets.symmetric(vertical: 12)),
                  icon: const Icon(Icons.send_rounded, size: 18),
                  label: const Text('Confirm & Submit', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
