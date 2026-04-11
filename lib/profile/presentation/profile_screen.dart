import 'dart:io';
import 'package:flutter/material.dart';
import 'package:khet_buddy/profile/controller/farmer_profile_controller.dart';
import '../../app_routes.dart';
import '../../constants/colors.dart';
import 'package:provider/provider.dart';
import '../../farm/controller/farm_controller.dart';
import 'package:image_picker/image_picker.dart';


class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? profilePhoto;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      Provider.of<FarmController>(context, listen: false).fetchFarms();
      Provider.of<FarmerProfileController>(context, listen: false).fetchFarmer();
    });
  }

  // 📸 Pick + Upload Image
  Future<void> _onPickPhoto() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      final file = File(picked.path);

      setState(() => profilePhoto = file);

      await Provider.of<FarmerProfileController>(context, listen: false)
          .updateProfileImage(file);
    }
  }

  // ✏️ Edit Profile
  void _showEditProfileSheet() {
    final farmerController =
    Provider.of<FarmerProfileController>(context, listen: false);
    final farmer = farmerController.farmer;

    final firstNameCtrl =
    TextEditingController(text: farmer?.firstName ?? '');
    final lastNameCtrl =
    TextEditingController(text: farmer?.lastName ?? '');
    final phoneCtrl =
    TextEditingController(text: farmer?.phoneNo ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Padding(
        padding:
        EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
        child: _EditProfileSheet(
          firstNameCtrl: firstNameCtrl,
          lastNameCtrl: lastNameCtrl,
          phoneCtrl: phoneCtrl,
          onSave: () async {
            await farmerController.updateProfile(
              firstName: firstNameCtrl.text.trim(),
              lastName: lastNameCtrl.text.trim(),
              phoneNo: phoneCtrl.text.trim(),
            );

            Navigator.pop(context);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final farmController = Provider.of<FarmController>(context);
    final farmerController = Provider.of<FarmerProfileController>(context);

    if (farmController.isLoading || farmerController.isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (farmController.farms.isEmpty) {
      return const Scaffold(
        body: Center(child: Text("No farms found")),
      );
    }

    final farm = farmController.farms.first;
    final farmer = farmerController.farmer;

    final fullName =
        '${farmer?.firstName ?? ''} ${farmer?.lastName ?? ''}';
    final phone = farmer?.phoneNo ?? '';

    final cropType = farm.crop;
    final landArea = '${farm.totalLand} acres';
    final irrigation = farm.irrigationType;
    final soilPH = farm.phLevel;
    final location = '${farm.latitude}, ${farm.longitude}';
    final farmName = 'Farm #${farm.id}';

    return Scaffold(
      backgroundColor: const Color(0xFFF0F0F0),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _ProfileHeader(
              fullName: fullName,
              phone: phone,
              cropType: cropType,
              profilePhoto: profilePhoto,
              profileImageUrl: farmer?.profileImage,
              onPickPhoto: _onPickPhoto,
              landArea: farm.totalLand.toString(),
              soilPH: soilPH.toStringAsFixed(1),
              irrigation: irrigation,
              farmCount: farmController.farms.length.toString(),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _FarmDetailsCard(
                farmName: farmName,
                cropType: cropType,
                landArea: landArea,
                irrigation: irrigation,
                soilPH: soilPH.toStringAsFixed(1),
                location: location,
                onEditProfile: _showEditProfileSheet,
              ),
            ),
            const SizedBox(height: 14),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: const _AddNewFarmButton(),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ================= HEADER =================
class _ProfileHeader extends StatelessWidget {
  final String fullName;
  final String phone;
  final String cropType;
  final File? profilePhoto;
  final String? profileImageUrl;
  final VoidCallback onPickPhoto;
  final String landArea;
  final String soilPH;
  final String irrigation;
  final String farmCount;

  const _ProfileHeader({
    required this.fullName,
    required this.phone,
    required this.cropType,
    required this.profilePhoto,
    required this.profileImageUrl,
    required this.onPickPhoto,
    required this.landArea,
    required this.soilPH,
    required this.irrigation,
    required this.farmCount,
  });

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Container(
          color: AppColors.darkgreen,
          padding: EdgeInsets.fromLTRB(20, topPadding + 12, 20, 60),
          child: Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 78,
                    height: 78,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: profilePhoto != null
                          ? Image.file(profilePhoto!, fit: BoxFit.cover)
                          : profileImageUrl != null &&
                          profileImageUrl!.isNotEmpty
                          ? Image.network(profileImageUrl!,
                          fit: BoxFit.cover)
                          : const Icon(Icons.person, size: 40),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: onPickPhoto,
                      child: const CircleAvatar(
                        radius: 12,
                        child: Icon(Icons.edit, size: 12),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(fullName,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold)),
                  Text(phone,
                      style: const TextStyle(color: Colors.white70)),
                  const SizedBox(height: 8),
                  Text(cropType,
                      style: const TextStyle(color: Colors.white)),
                ],
              ),
            ],
          ),
        ),

        Positioned(
          bottom: -38,
          left: 16,
          right: 16,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A5C35),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                _StatItem(value: landArea, label: 'acres'),
                _VDivider(),
                _StatItem(value: soilPH, label: 'Soil pH'),
                _VDivider(),
                _StatItem(value: irrigation, label: 'Irrigation'),
                _VDivider(),
                _StatItem(value: farmCount, label: 'Farm(s)'),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

// ================= REMAINING UI SAME =================

class _StatItem extends StatelessWidget {
  final String value;
  final String label;
  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.55),
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container(
    width: 1,
    height: 32,
    color: Colors.white.withOpacity(0.2),
  );
}

// ─── Farm Details Card ───────────────────────────────────────────────────────────
class _FarmDetailsCard extends StatelessWidget {
  final String farmName;
  final String cropType;
  final String landArea;
  final String irrigation;
  final String soilPH;
  final String location;
  final VoidCallback onEditProfile;

  const _FarmDetailsCard({
    required this.farmName,
    required this.cropType,
    required this.landArea,
    required this.irrigation,
    required this.soilPH,
    required this.location,
    required this.onEditProfile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Left green accent bar — as seen in screenshot
              Container(
                width: 5,
                color: AppColors.darkgreen,
              ),

              // Main content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title row
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 18, 16, 14),
                      child: Row(
                        children: [
                          // ⓘ icon in light green rounded square
                          Container(
                            width: 34,
                            height: 34,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5EE),
                              borderRadius: BorderRadius.circular(9),
                            ),
                            child: const Icon(
                              Icons.info_outline_rounded,
                              size: 19,
                              color: AppColors.darkgreen,
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Text(
                            'Farm Details',
                            style: TextStyle(
                              fontSize: 15.5,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF1C1C1E),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Divider(
                        height: 1,
                        thickness: 1,
                        color: Color(0xFFF0F0F0)),

                    _DetailRow(label: 'Farm Name', value: farmName),
                    _DetailRow(label: 'Crop Type', value: cropType),
                    _DetailRow(label: 'Land Area', value: landArea),
                    _DetailRow(label: 'Irrigation', value: irrigation),
                    _DetailRow(label: 'Soil pH', value: soilPH),
                    _DetailRow(
                        label: 'Location', value: location, isLast: true),

                    // Edit Profile button
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
                      child: SizedBox(
                        width: double.infinity,
                        height: 52,
                        child: ElevatedButton.icon(
                          onPressed: onEditProfile,
                          icon: const Icon(Icons.edit_outlined, size: 17),
                          label: const Text(
                            'Edit Profile',
                            style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.1,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.darkgreen,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isLast;

  const _DetailRow(
      {required this.label, required this.value, this.isLast = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Color(0xFFAAAAAA),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Color(0xFF1C1C1E),
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          const Divider(
              height: 1,
              thickness: 1,
              indent: 16,
              endIndent: 16,
              color: Color(0xFFF0F0F0)),
      ],
    );
  }
}

// ─── Add New Farm — true dashed border ──────────────────────────────────────────
class _AddNewFarmButton extends StatelessWidget {
  const _AddNewFarmButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushReplacementNamed(
            context, AppRoutes.selectFram);
      },
      child: CustomPaint(
        painter: _DashedRectPainter(
            color: AppColors.darkgreen, radius: 12, dashW: 7, gapW: 5),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 18),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.add_circle_outline_rounded,
                  color: AppColors.darkgreen, size: 20),
              SizedBox(width: 8),
              Text(
                'Switch Farms',
                style: TextStyle(
                  color: AppColors.darkgreen,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.5,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashW;
  final double gapW;

  const _DashedRectPainter(
      {required this.color,
        required this.radius,
        required this.dashW,
        required this.gapW});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.6
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..addRRect(RRect.fromRectAndRadius(
          Rect.fromLTWH(0, 0, size.width, size.height),
          Radius.circular(radius)));

    for (final m in path.computeMetrics()) {
      double d = 0;
      while (d < m.length) {
        canvas.drawPath(m.extractPath(d, d + dashW), paint);
        d += dashW + gapW;
      }
    }
  }

  @override
  bool shouldRepaint(_DashedRectPainter old) => false;
}

// ─── Edit Profile Bottom Sheet ───────────────────────────────────────────────────
class _EditProfileSheet extends StatelessWidget {
  final TextEditingController firstNameCtrl;
  final TextEditingController lastNameCtrl;
  final TextEditingController phoneCtrl;
  final VoidCallback onSave;

  const _EditProfileSheet({
    required this.firstNameCtrl,
    required this.lastNameCtrl,
    required this.phoneCtrl,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                  color: const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(2)),
            ),
          ),
          const SizedBox(height: 22),
          const Text(
            'Edit Profile',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1E)),
          ),
          const SizedBox(height: 4),
          const Text(
            'Update your personal information.',
            style:
            TextStyle(fontSize: 13, color: Color(0xFFAAAAAA)),
          ),
          const SizedBox(height: 24),
          _SheetField(
              label: 'First Name',
              controller: firstNameCtrl,
              hint: 'Enter first name',
              icon: Icons.person_outline_rounded),
          const SizedBox(height: 14),
          _SheetField(
              label: 'Last Name',
              controller: lastNameCtrl,
              hint: 'Enter last name',
              icon: Icons.badge_outlined),
          const SizedBox(height: 14),
          _SheetField(
              label: 'Phone Number',
              controller: phoneCtrl,
              hint: '+91 XXXXX XXXXX',
              icon: Icons.phone_outlined,
              keyboardType: TextInputType.phone),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: onSave,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkgreen,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                elevation: 0,
              ),
              child: const Text('Save Changes',
                  style: TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 44,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(
                      color: Color(0xFFAAAAAA),
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ),
          ),
        ],
      ),
    );
  }
}

class _SheetField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final TextInputType keyboardType;

  const _SheetField({
    required this.label,
    required this.controller,
    required this.hint,
    required this.icon,
    this.keyboardType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3C2F3D))),
        const SizedBox(height: 7),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          style:
          const TextStyle(fontSize: 14, color: Color(0xFF1C1C1E)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                color: Color(0xFFBDBDBD), fontSize: 13.5),
            prefixIcon:
            Icon(icon, color: AppColors.darkgreen, size: 19),
            filled: true,
            fillColor: const Color(0xFFF7F9F7),
            contentPadding: const EdgeInsets.symmetric(
                horizontal: 14, vertical: 14),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFFE8E8E8))),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide:
                const BorderSide(color: Color(0xFFE8E8E8))),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: const BorderSide(
                    color: AppColors.darkgreen, width: 1.5)),
          ),
        ),
      ],
    );
  }
}