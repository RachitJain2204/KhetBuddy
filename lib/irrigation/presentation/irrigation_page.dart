import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../services/api_service.dart';

// ─── Models ──────────────────────────────────────────────────────────────────

class IrrigationSummary {
  final int totalDays;
  final int totalIrrigationDays;
  final double totalHours;
  final String message;

  IrrigationSummary({
    required this.totalDays,
    required this.totalIrrigationDays,
    required this.totalHours,
    required this.message,
  });

  factory IrrigationSummary.fromJson(Map<String, dynamic> json) {
    return IrrigationSummary(
      totalDays: json['totalDays'] ?? 0,
      totalIrrigationDays: json['totalIrrigationDays'] ?? 0,
      totalHours: (json['totalHours'] ?? 0).toDouble(),
      message: json['message'] ?? '',
    );
  }
}

class DayPlan {
  final int day;
  final String date;
  final String action; // "irrigate" or "skip"
  final double hours;
  final int cycles;
  final String note;

  DayPlan({
    required this.day,
    required this.date,
    required this.action,
    required this.hours,
    required this.cycles,
    required this.note,
  });

  bool get shouldIrrigate => action.toLowerCase() == 'irrigate';

  factory DayPlan.fromJson(Map<String, dynamic> json) {
    return DayPlan(
      day: json['day'] ?? 0,
      date: json['date'] ?? '',
      action: json['action'] ?? 'skip',
      hours: (json['hours'] ?? 0).toDouble(),
      cycles: json['cycles'] ?? 0,
      note: json['note'] ?? '',
    );
  }
}

class IrrigationScheduleResponse {
  final IrrigationSummary summary;
  final List<DayPlan> plan;

  IrrigationScheduleResponse({required this.summary, required this.plan});

  factory IrrigationScheduleResponse.fromJson(Map<String, dynamic> json) {
    return IrrigationScheduleResponse(
      summary: IrrigationSummary.fromJson(json['summary']),
      plan: (json['plan'] as List)
          .map((e) => DayPlan.fromJson(e))
          .toList(),
    );
  }
}

class ImmediateIrrigationResponse {
  final bool irrigateToday;
  final double hoursRequired;
  final int cycles;
  final String message;

  ImmediateIrrigationResponse({
    required this.irrigateToday,
    required this.hoursRequired,
    required this.cycles,
    required this.message,
  });

  factory ImmediateIrrigationResponse.fromJson(Map<String, dynamic> json) {
    return ImmediateIrrigationResponse(
      irrigateToday: json['irrigateToday'] ?? false,
      hoursRequired: (json['hoursRequired'] ?? 0).toDouble(),
      cycles: json['cycles'] ?? 0,
      message: json['message'] ?? '',
    );
  }
}

// ─── Repository ──────────────────────────────────────────────────────────────

class IrrigationRepository {
  final ApiService _api = ApiService();

  Future<IrrigationScheduleResponse> getSchedule({
    required int farmId,
    required int lastIrrigationDay,
    required String sowingDate,
    required String fieldUnit,
    required String soilType,
    required double dailyAvg,
    required String pumpType,
  }) async {
    final response = await _api.post(
      'api/irrigation/schedule/$farmId',
      {
        'lastIrrigationDay': lastIrrigationDay,
        'sowing_date': sowingDate,
        'field_unit': fieldUnit,
        'soil_type': soilType,
        'daily_avg': dailyAvg,
        'pump_type': pumpType,
      },
    );
    return IrrigationScheduleResponse.fromJson(response.data);
  }

  Future<ImmediateIrrigationResponse> getImmediatePlan({
    required int farmId,
    required int lastIrrigationDay,
    required String sowingDate,
    required String fieldUnit,
    required String soilType,
    required double dailyAvg,
    required String pumpType,
  }) async {
    final response = await _api.post(
      'api/irrigation/immediate/$farmId',
      {
        'lastIrrigationDay': lastIrrigationDay,
        'sowing_date': sowingDate,
        'field_unit': fieldUnit,
        'soil_type': soilType,
        'daily_avg': dailyAvg,
        'pump_type': pumpType,
      },
    );
    return ImmediateIrrigationResponse.fromJson(response.data);
  }
}

// ─── Screen ───────────────────────────────────────────────────────────────────

class IrrigationPlannerScreen extends StatefulWidget {
  /// Pass real farm data from your farm/profile state
  final int farmId;
  final String cropName;
  final String fieldUnit;

  const IrrigationPlannerScreen({
    super.key,
    required this.farmId,
    required this.cropName,
    required this.fieldUnit,
  });

  @override
  State<IrrigationPlannerScreen> createState() =>
      _IrrigationPlannerScreenState();
}

class _IrrigationPlannerScreenState extends State<IrrigationPlannerScreen>
    with SingleTickerProviderStateMixin {
  final _repo = IrrigationRepository();

  // ── Form controllers
  final _lastIrrigationCtrl = TextEditingController(text: '2');
  final _dailyAvgCtrl = TextEditingController(text: '2');
  final _sowingDateCtrl =
  TextEditingController(text: DateTime.now().toIso8601String().split('T')[0]);

  String _soilType = 'loamy';
  String _pumpType = 'medium';

  final List<String> _soilTypes = ['loamy', 'sandy', 'clay', 'silty', 'peaty'];
  final List<String> _pumpTypes = ['small', 'medium', 'large'];

  // ── View state
  bool _showSchedule = false;
  bool _showToday = false;

  // ── API state
  bool _loadingSchedule = false;
  bool _loadingToday = false;
  String? _scheduleError;
  String? _todayError;

  IrrigationScheduleResponse? _scheduleData;
  ImmediateIrrigationResponse? _todayData;

  // ── Animation
  late AnimationController _fadeCtrl;
  late Animation<double> _fadeAnim;

  @override
  void initState() {
    super.initState();
    _fadeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 400));
    _fadeAnim = CurvedAnimation(parent: _fadeCtrl, curve: Curves.easeInOut);
  }

  @override
  void dispose() {
    _fadeCtrl.dispose();
    _lastIrrigationCtrl.dispose();
    _dailyAvgCtrl.dispose();
    _sowingDateCtrl.dispose();
    super.dispose();
  }

  // ── Helpers

  Map<String, dynamic> _buildPayload() => {
    'farmId': widget.farmId,
    'lastIrrigationDay': int.tryParse(_lastIrrigationCtrl.text) ?? 2,
    'sowingDate': _sowingDateCtrl.text,
    'fieldUnit': widget.fieldUnit,
    'soilType': _soilType,
    'dailyAvg': double.tryParse(_dailyAvgCtrl.text) ?? 2.0,
    'pumpType': _pumpType,
  };

  Future<void> _fetchSchedule() async {
    final p = _buildPayload();
    setState(() {
      _loadingSchedule = true;
      _scheduleError = null;
      _showSchedule = true;
      _showToday = false;
    });
    _fadeCtrl.reset();
    try {
      final data = await _repo.getSchedule(
        farmId: p['farmId'],
        lastIrrigationDay: p['lastIrrigationDay'],
        sowingDate: p['sowingDate'],
        fieldUnit: p['fieldUnit'],
        soilType: p['soilType'],
        dailyAvg: p['dailyAvg'],
        pumpType: p['pumpType'],
      );
      setState(() => _scheduleData = data);
      _fadeCtrl.forward();
    } catch (e) {
      setState(() => _scheduleError = e.toString());
    } finally {
      setState(() => _loadingSchedule = false);
    }
  }

  Future<void> _fetchToday() async {
    final p = _buildPayload();
    setState(() {
      _loadingToday = true;
      _todayError = null;
      _showToday = true;
      _showSchedule = false;
    });
    _fadeCtrl.reset();
    try {
      final data = await _repo.getImmediatePlan(
        farmId: p['farmId'],
        lastIrrigationDay: p['lastIrrigationDay'],
        sowingDate: p['sowingDate'],
        fieldUnit: p['fieldUnit'],
        soilType: p['soilType'],
        dailyAvg: p['dailyAvg'],
        pumpType: p['pumpType'],
      );
      setState(() => _todayData = data);
      _fadeCtrl.forward();
    } catch (e) {
      setState(() => _todayError = e.toString());
    } finally {
      setState(() => _loadingToday = false);
    }
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),
      builder: (ctx, child) => Theme(
        data: Theme.of(ctx).copyWith(
          colorScheme: const ColorScheme.light(
            primary: AppColors.irrigationPrimary,
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      _sowingDateCtrl.text = picked.toIso8601String().split('T')[0];
    }
  }

  // ── Build

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgcolor,
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildFormCard(),
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                  const SizedBox(height: 16),
                  if (_showToday) _buildTodaySection(),
                  if (_showSchedule) _buildScheduleSection(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return SliverAppBar(
      pinned: true,
      expandedHeight: 100,
      backgroundColor: AppColors.irrigationPrimary,
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
        title: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Irrigation Planner',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20),
            ),
            Text(
              'Personalized schedule for ${widget.cropName}',
              style: const TextStyle(color: Colors.white70, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFormCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: AppColors.irrigationPrimary, width: 4),
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.irrigateBadgeBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.water_drop_outlined,
                    color: AppColors.irrigationPrimary, size: 20),
              ),
              const SizedBox(width: 10),
              const Text('Your Farm Details',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.textBlack)),
            ],
          ),
          const SizedBox(height: 20),
          _formLabel('LAST IRRIGATION (DAYS AGO)'),
          _inputField(_lastIrrigationCtrl,
              keyboardType: TextInputType.number),
          const SizedBox(height: 14),
          _formLabel('SOWING DATE'),
          GestureDetector(
            onTap: _pickDate,
            child: AbsorbPointer(
              child: _inputField(_sowingDateCtrl,
                  suffixIcon: const Icon(Icons.calendar_today,
                      size: 18, color: AppColors.irrigationPrimary)),
            ),
          ),
          const SizedBox(height: 14),
          _formLabel('SOIL TYPE'),
          _dropdownField(
            value: _soilType,
            items: _soilTypes,
            onChanged: (v) => setState(() => _soilType = v!),
          ),
          const SizedBox(height: 14),
          _formLabel('AVG. DAILY IRRIGATION (HOURS)'),
          _inputField(_dailyAvgCtrl, keyboardType: TextInputType.number),
          const SizedBox(height: 14),
          _formLabel('PUMP TYPE'),
          _dropdownField(
            value: _pumpType,
            items: _pumpTypes,
            onChanged: (v) => setState(() => _pumpType = v!),
          ),
        ],
      ),
    );
  }

  Widget _formLabel(String text) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(text,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w600,
            color: AppColors.hintText,
            letterSpacing: 0.5)),
  );

  Widget _inputField(TextEditingController ctrl,
      {TextInputType? keyboardType, Widget? suffixIcon}) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      child: TextField(
        controller: ctrl,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
          suffixIcon: suffixIcon,
        ),
        style: const TextStyle(fontSize: 15, color: AppColors.textBlack),
      ),
    );
  }

  Widget _dropdownField({
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.inputBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.inputBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(Icons.keyboard_arrow_down,
              color: AppColors.hintText),
          items: items
              .map((e) => DropdownMenuItem(
              value: e,
              child: Text(e,
                  style: const TextStyle(
                      fontSize: 15, color: AppColors.textBlack))))
              .toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: _loadingSchedule ? null : _fetchSchedule,
            icon: _loadingSchedule
                ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: Colors.white))
                : const Icon(Icons.calendar_month, size: 18),
            label: const Text('14-Day Schedule'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.irrigationPrimary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: _loadingToday ? null : _fetchToday,
            icon: _loadingToday
                ? const SizedBox(
                width: 16,
                height: 16,
                child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.water_drop_outlined, size: 18),
            label: const Text('Today'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.irrigationPrimary,
              side: const BorderSide(color: AppColors.irrigationPrimary),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              textStyle: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ),
      ],
    );
  }

  // ── Today Section

  Widget _buildTodaySection() {
    if (_loadingToday) return _centeredLoader();
    if (_todayError != null) return _errorWidget(_todayError!);
    if (_todayData == null) return const SizedBox();

    final d = _todayData!;
    return FadeTransition(
      opacity: _fadeAnim,
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [AppColors.irrigationPrimary, AppColors.irrigationMid],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.water_drop, color: Colors.white, size: 22),
                const SizedBox(width: 8),
                const Text('Irrigate Today',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                    child: _statTile(
                        '${d.hoursRequired.toStringAsFixed(0)}h', 'Duration')),
                const SizedBox(width: 12),
                Expanded(
                    child: _statTile('${d.cycles}', 'Cycles')),
              ],
            ),
            if (d.message.isNotEmpty) ...[
              const SizedBox(height: 14),
              _noteBox(d.message, dark: true),
            ]
          ],
        ),
      ),
    );
  }

  Widget _statTile(String value, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 13)),
        ],
      ),
    );
  }

  // ── Schedule Section

  Widget _buildScheduleSection() {
    if (_loadingSchedule) return _centeredLoader();
    if (_scheduleError != null) return _errorWidget(_scheduleError!);
    if (_scheduleData == null) return const SizedBox();

    final s = _scheduleData!.summary;
    final plan = _scheduleData!.plan;

    return FadeTransition(
      opacity: _fadeAnim,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Summary banner
          Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.irrigationPrimary, AppColors.irrigationMid],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 8),
            child: Row(
              children: [
                _summaryItem('${s.totalDays}', 'Days'),
                _divider(),
                _summaryItem('${s.totalHours.toStringAsFixed(0)}h',
                    'Total Water'),
                _divider(),
                _summaryItem('${s.totalIrrigationDays}', 'Irrigations'),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Info note
          if (s.message.isNotEmpty)
            Container(
              decoration: BoxDecoration(
                color: AppColors.infoBannerBg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.irrigateBadgeBorder),
              ),
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.info_outline,
                      size: 16, color: AppColors.infoBannerText),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(s.message,
                        style: const TextStyle(
                            color: AppColors.infoBannerText, fontSize: 13)),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 12),

          // Daily plan card
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2))
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      const Icon(Icons.format_list_bulleted,
                          color: AppColors.irrigationPrimary, size: 20),
                      const SizedBox(width: 8),
                      const Text('Daily Plan',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: AppColors.textBlack)),
                    ],
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: plan.length,
                  separatorBuilder: (_, __) => const Divider(
                      height: 1, indent: 16, endIndent: 16),
                  itemBuilder: (_, i) => _dayPlanItem(plan[i]),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _summaryItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(value,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _divider() {
    return Container(
        width: 1, height: 36, color: Colors.white.withOpacity(0.3));
  }

  Widget _dayPlanItem(DayPlan d) {
    final irrigate = d.shouldIrrigate;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Row: number + date + badge
          Row(
            children: [
              // Day number circle
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: irrigate
                      ? AppColors.irrigationPrimary
                      : AppColors.skipBg,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text('${d.day}',
                    style: TextStyle(
                        color: irrigate ? Colors.white : AppColors.skipText,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ),
              const SizedBox(width: 12),

              // Date + subtitle
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(d.date,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                            color: AppColors.textBlack)),
                    if (irrigate && d.hours > 0)
                      Text('${d.hours.toStringAsFixed(0)}h  ${d.cycles} cycle(s)',
                          style: const TextStyle(
                              fontSize: 12, color: AppColors.hintText)),
                  ],
                ),
              ),

              // Action badge
              Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color:
                  irrigate ? AppColors.irrigateBadgeBg : AppColors.skipBg,
                  borderRadius: BorderRadius.circular(20),
                  border: irrigate
                      ? Border.all(color: AppColors.irrigateBadgeBorder)
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      irrigate
                          ? Icons.water_drop_outlined
                          : Icons.remove,
                      size: 14,
                      color: irrigate
                          ? AppColors.irrigateBadgeText
                          : AppColors.skipText,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      irrigate ? 'Irrigate' : 'Skip',
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: irrigate
                              ? AppColors.irrigateBadgeText
                              : AppColors.skipText),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ── Note box (always shown, from API)
          if (d.note.isNotEmpty) ...[
            const SizedBox(height: 10),
            _noteBox(d.note),
          ],
        ],
      ),
    );
  }

  /// Reusable note/info text box shown under each day card
  Widget _noteBox(String message, {bool dark = false}) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: dark
            ? Colors.white.withOpacity(0.15)
            : AppColors.infoBannerBg,
        borderRadius: BorderRadius.circular(10),
        border: dark
            ? Border.all(color: Colors.white.withOpacity(0.25))
            : Border.all(color: AppColors.irrigateBadgeBorder),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.info_outline,
            size: 15,
            color: dark ? Colors.white70 : AppColors.infoBannerText,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 13,
                height: 1.4,
                color: dark ? Colors.white : AppColors.infoBannerText,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Utility widgets

  Widget _centeredLoader() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 40),
    child: Center(
      child: CircularProgressIndicator(color: AppColors.irrigationPrimary),
    ),
  );

  Widget _errorWidget(String error) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.statusRed,
      borderRadius: BorderRadius.circular(12),
    ),
    child: Row(
      children: [
        const Icon(Icons.error_outline, color: Colors.red, size: 20),
        const SizedBox(width: 10),
        Expanded(
            child: Text(error,
                style: const TextStyle(color: Colors.red, fontSize: 13))),
      ],
    ),
  );
}