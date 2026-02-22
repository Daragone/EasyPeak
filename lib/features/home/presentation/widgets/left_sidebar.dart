import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';

class LeftSidebar extends ConsumerWidget {
  final bool isCollapsed;
  const LeftSidebar({super.key, this.isCollapsed = false});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: isCollapsed ? CrossAxisAlignment.center : CrossAxisAlignment.start,
        children: [
          // Logo
          Padding(
            padding: EdgeInsets.symmetric(horizontal: isCollapsed ? 0 : 16.0, vertical: 8.0),
            child: Text(
              isCollapsed ? 'EP' : 'EasyPeak',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: isCollapsed ? 28 : 32,
                fontWeight: FontWeight.w900,
                letterSpacing: -1,
              ),
            ),
          ),
          const SizedBox(height: 32),

          // Items
          _SidebarItem(icon: Icons.home_rounded, label: 'APRENDER', isSelected: true, isCollapsed: isCollapsed),
          _SidebarItem(icon: Icons.sort_by_alpha_rounded, label: 'LETRAS', isCollapsed: isCollapsed),
          _SidebarItem(icon: Icons.fitness_center_rounded, label: 'PRATICAR', isCollapsed: isCollapsed),
          _SidebarItem(icon: Icons.shield_rounded, label: 'LIGAS', isCollapsed: isCollapsed),
          _SidebarItem(icon: Icons.library_add_check_rounded, label: 'MISSÕES', isCollapsed: isCollapsed),
          _SidebarItem(icon: Icons.storefront_rounded, label: 'LOJA', isCollapsed: isCollapsed),
          _SidebarItem(icon: Icons.person_rounded, label: 'PERFIL', isCollapsed: isCollapsed),
          _SidebarItem(icon: Icons.more_horiz_rounded, label: 'MAIS', isCollapsed: isCollapsed),

        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isCollapsed;
  final bool isSelected;

  const _SidebarItem({
    required this.icon,
    required this.label,
    required this.isCollapsed,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isSelected ? AppColors.primary : Colors.grey.shade600;
    final bgColor = isSelected ? AppColors.primary.withOpacity(0.1) : Colors.transparent;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: isSelected ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1.5) : Border.all(color: Colors.transparent, width: 1.5),
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {},
          hoverColor: Colors.grey.shade100,
          child: Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12, 
              horizontal: isCollapsed ? 12 : 16
            ),
            child: Row(
              mainAxisAlignment: isCollapsed ? MainAxisAlignment.center : MainAxisAlignment.start,
              children: [
                Icon(icon, color: color, size: 28),
                if (!isCollapsed) ...[
                  const SizedBox(width: 16),
                  Text(
                    label,
                    style: TextStyle(
                      color: color,
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ]
              ],
            ),
          ),
        ),
      ),
    );
  }
}
