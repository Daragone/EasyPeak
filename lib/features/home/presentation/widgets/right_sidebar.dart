import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../profile/presentation/profile_providers.dart';

class RightSidebar extends ConsumerWidget {
  const RightSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(currentStudentProfileProvider);

    return Container(
      padding: const EdgeInsets.only(top: 24, left: 24, right: 24),
      color: AppColors.background,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TOPO: Moedas, Fogo, Perfil
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem(
                icon: Icons.whatshot_rounded, 
                color: AppColors.warning, 
                value: profileState.value?.streakDays.toString() ?? '0'
              ),
              _StatItem(
                icon: Icons.diamond_rounded, 
                color: AppColors.primary, 
                value: profileState.value?.xp.toString() ?? '0'
              ),
              const CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.surfaceLight,
                child: Icon(Icons.person, color: AppColors.textPrimary, size: 20),
              )
            ],
          ),
          
          const SizedBox(height: 32),
          
          // LIGAS CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('LIGAS', style: TextStyle(color: AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 13)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('Quem sabe da próxima vez!', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                          SizedBox(height: 8),
                          Text('Você terminou na posição 20 e caiu pra Divisão Esmeralda.', style: TextStyle(color: AppColors.textSecondary, fontSize: 13)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(Icons.shield_rounded, color: Colors.green.shade400, size: 48),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text('VER LIGAS', style: TextStyle(color: AppColors.accent, fontWeight: FontWeight.bold)),
                  ),
                )
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // MISSOES CARD
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.border, width: 2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Missões do dia', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 16)),
                    TextButton(
                      onPressed: () {},
                      child: const Text('VER TODAS', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                    )
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.bolt_rounded, color: AppColors.warning, size: 32),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ganhe 10 XP', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: 0.1,
                            backgroundColor: AppColors.border,
                            color: AppColors.warning,
                            minHeight: 12,
                            borderRadius: BorderRadius.circular(6),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.inventory_rounded, color: Colors.brown.shade300, size: 28),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String value;
  
  const _StatItem({required this.icon, required this.color, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(width: 6),
        Text(value, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 16)),
      ],
    );
  }
}
