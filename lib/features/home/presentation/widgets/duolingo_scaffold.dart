import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import 'left_sidebar.dart';
import 'right_sidebar.dart';

class DuolingoScaffold extends StatelessWidget {
  final Widget child;
  
  const DuolingoScaffold({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isDesktop = constraints.maxWidth >= 1024;
          final isTablet = constraints.maxWidth >= 768 && constraints.maxWidth < 1024;

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. LEFT SIDEBAR (Navigation)
              if (isDesktop || isTablet)
                SizedBox(
                  width: isDesktop ? 256 : 80,
                  child: LeftSidebar(isCollapsed: !isDesktop),
                ),
              if (isDesktop || isTablet) 
                const VerticalDivider(width: 1, color: Color(0xFFE5E5E5)),

              // 2. MAIN CONTENT (Path)
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 600),
                    child: child,
                  ),
                ),
              ),

              // 3. RIGHT SIDEBAR (Gamification)
              if (isDesktop) ...[
                const VerticalDivider(width: 1, color: Color(0xFFE5E5E5)),
                SizedBox(
                  width: 330,
                  child: RightSidebar(),
                ),
              ]
            ],
          );
        },
      ),
      bottomNavigationBar: MediaQuery.of(context).size.width < 768 
          ? const BottomNavMobile() // For small screens
          : null,
    );
  }
}

class BottomNavMobile extends StatelessWidget {
  const BottomNavMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      showSelectedLabels: false,
      showUnselectedLabels: false,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_rounded), label: 'Aprender'),
        BottomNavigationBarItem(icon: Icon(Icons.sort_by_alpha_rounded), label: 'Letras'),
        BottomNavigationBarItem(icon: Icon(Icons.shield_rounded), label: 'Ligas'),
        BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Perfil'),
      ],
    );
  }
}
