import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';

class AddSessionPage extends ConsumerStatefulWidget {
  const AddSessionPage({super.key});

  @override
  ConsumerState<AddSessionPage> createState() => _AddSessionPageState();
}

class _AddSessionPageState extends ConsumerState<AddSessionPage> {
  final _formKey = GlobalKey<FormState>();
  final _durationController = TextEditingController();
  final _complaintController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedSport = 'Badminton';
  String _selectedIntensity = 'Sedang';

  @override
  void dispose() {
    _durationController.dispose();
    _complaintController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    
    // Nanti akan dihubungkan ke Provider
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Latihan berhasil dicatat!'), backgroundColor: AppColors.success),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      appBar: AppBar(
        title: const Text('Catat Latihan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Jenis Olahraga'),
              const SizedBox(height: 12),
              Row(
                children: [
                  _sportSelector('Badminton', Icons.sports_tennis_rounded),
                  const SizedBox(width: 12),
                  _sportSelector('Lari', Icons.directions_run_rounded),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Durasi (Menit)'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _durationController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.timer_outlined),
                  hintText: 'Misal: 60',
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Durasi wajib diisi';
                  if (int.tryParse(v) == null) return 'Harus berupa angka';
                  return null;
                },
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Intensitas Latihan'),
              const SizedBox(height: 12),
              Row(
                children: [
                  _intensitySelector('Rendah', AppColors.neonGreen),
                  const SizedBox(width: 8),
                  _intensitySelector('Sedang', AppColors.warning),
                  const SizedBox(width: 8),
                  _intensitySelector('Tinggi', AppColors.error),
                ],
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Keluhan Fisik (Opsional)'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _complaintController,
                decoration: const InputDecoration(
                  hintText: 'Misal: Nyeri lutut kanan',
                  prefixIcon: Icon(Icons.medical_services_outlined),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Info ini akan dianalisis oleh AI Coach untuk memberi saran pencegahan cedera.',
                style: TextStyle(color: AppColors.textTertiary, fontSize: 12, fontStyle: FontStyle.italic),
              ),
              const SizedBox(height: 24),

              _buildSectionTitle('Catatan Latihan'),
              const SizedBox(height: 12),
              TextFormField(
                controller: _notesController,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Bagaimana perasaanmu setelah latihan ini?',
                ),
              ),
              const SizedBox(height: 40),

              Container(
                width: double.infinity,
                height: 56,
                decoration: BoxDecoration(
                  gradient: AppColors.aiGradient,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(color: AppColors.neonPurple.withValues(alpha: 0.3), blurRadius: 12, offset: const Offset(0, 4)),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: const Text('SIMPAN LATIHAN', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.textPrimary));
  }

  Widget _sportSelector(String type, IconData icon) {
    final isSelected = _selectedSport == type;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSport = type),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.neonPurple.withValues(alpha: 0.15) : AppColors.bgTertiary,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: isSelected ? AppColors.neonPurple : Colors.white.withValues(alpha: 0.1), width: isSelected ? 2 : 1),
          ),
          child: Column(
            children: [
              Icon(icon, color: isSelected ? AppColors.neonPurple : AppColors.textTertiary, size: 32),
              const SizedBox(height: 8),
              Text(type, style: TextStyle(color: isSelected ? AppColors.neonPurple : AppColors.textSecondary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _intensitySelector(String level, Color activeColor) {
    final isSelected = _selectedIntensity == level;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedIntensity = level),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? activeColor.withValues(alpha: 0.2) : AppColors.bgTertiary,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: isSelected ? activeColor : Colors.white.withValues(alpha: 0.1)),
          ),
          child: Center(
            child: Text(
              level,
              style: TextStyle(
                color: isSelected ? activeColor : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
