import 'package:flutter/material.dart';
import 'package:khet_buddy/profile/presentation/create_profile.dart';
import '../constants/colors.dart';
import '../dashboard/presentation/dashboard_page.dart';
import '../fertilizer/presentation/fertilizer_page.dart';
import '../irrigation/presentation/irrigation_page.dart';

class HomePage extends StatefulWidget {
  final int initialIndex;

  const HomePage({super.key, this.initialIndex = 0});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late int _selectedIndex;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _pages = [
    const DashboardPage(),
    const IrrigationPage(),
    const FertilizerPage(),
    const CreateProfile(),
  ];

  final List<NavItemData> _navItems = [
    NavItemData(icon: Icons.home, label: 'Dashboard'),
    NavItemData(icon: Icons.water_drop_outlined, label: 'Irrigation'),
    NavItemData(icon: Icons.compost, label: 'Fertilizer'),
    NavItemData(icon: Icons.person, label: 'Profile'),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) {
          return FadeTransition(opacity: animation, child: child);
        },
        child: _pages[_selectedIndex],
      ),
      bottomNavigationBar: CustomNavBar(
        selectedIndex: _selectedIndex,
        navItems: _navItems,
        onTap: _onItemTapped,
      ),
    );
  }
}

class NavItemData {
  final IconData icon;
  final String label;

  NavItemData({required this.icon, required this.label});
}

class CustomNavBar extends StatelessWidget {
  final int selectedIndex;
  final List<NavItemData> navItems;
  final Function(int) onTap;

  const CustomNavBar({
    super.key,
    required this.selectedIndex,
    required this.navItems,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withValues(alpha: 0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4.0, vertical: 8.0),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final double itemWidth = constraints.maxWidth / navItems.length;

              return Stack(
                children: [
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: selectedIndex * itemWidth + 5,
                    top: 0,
                    bottom: 0,
                    child: Container(
                      width: itemWidth - 10,
                      decoration: BoxDecoration(
                        color: const Color(0xFFD3F1DF),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: List.generate(
                      navItems.length,
                          (index) => Expanded(
                        child: _buildNavItem(
                          navItems[index].icon,
                          navItems[index].label,
                          index,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, int index) {
    final bool isSelected = selectedIndex == index;

    return GestureDetector(
      onTap: () => onTap(index),
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        // ❗ Keep your original decoration logic
        decoration: isSelected
            ? BoxDecoration(
          color: Colors.transparent, // Background handled by slider
          borderRadius: BorderRadius.circular(14),
        )
            : null,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              duration: const Duration(milliseconds: 300),
              scale: isSelected ? 1.1 : 1.0,
              child: Icon(
                icon,
                color: AppColors.darkgreen,
                size: 28,
                fill: 1.0,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.darkgreen,
                fontWeight: FontWeight.w600,
                height: 1.1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
