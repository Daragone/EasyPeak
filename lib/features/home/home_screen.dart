import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/presentation/auth_controller.dart';
import '../auth/domain/user_entity.dart';
import '../profile/presentation/profile_providers.dart';
import 'presentation/widgets/duolingo_scaffold.dart';
import '../../core/constants/app_colors.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authStateProvider);
    final profileState = ref.watch(currentStudentProfileProvider);

    return userState.when(
      data: (user) {
        if (user == null) {
          return const Scaffold(body: Center(child: Text('Redirecionando para login...')));
        }

        return DuolingoScaffold(
          child: Column(
            children: [
              // HEADER DA TRILHA (Section Header Premium-style)
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(top: 24, left: 16, right: 16),
                padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  image: DecorationImage(
                    image: const AssetImage('assets/images/mascot.png'),
                    fit: BoxFit.cover,
                    colorFilter: ColorFilter.mode(
                      AppColors.background.withOpacity(0.65), 
                      BlendMode.darken,
                    ),
                  ),
                  border: Border.all(color: AppColors.border, width: 2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('ACAMPAMENTO BASE 1', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 14, letterSpacing: 1.5)),
                        SizedBox(height: 8),
                        Text('Fundamentos e Foco Neural', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold, fontSize: 22)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(color: AppColors.surfaceLight, borderRadius: BorderRadius.circular(12)),
                      child: const Row(
                        children: [
                          Icon(Icons.auto_stories_rounded, color: AppColors.textPrimary),
                          SizedBox(width: 8),
                          Text('GUIA', style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              
              const SizedBox(height: 48),

              // THE PATH / TRILHA
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 64),
                  itemCount: 12,
                  itemBuilder: (context, index) {
                    final levelNumber = index + 1;
                    final currentDbLevel = profileState.value?.currentLevelId ?? 1;
                    
                    final isUnlocked = levelNumber <= currentDbLevel; 
                    final isCurrentLevel = levelNumber == currentDbLevel;

                    // Calculates a "zig-zag" offset based on index
                    final double offsetX = (index % 4 == 1 || index % 4 == 2) ? 40.0 : -40.0;
                    
                    return _PathNode(
                      levelNumber: levelNumber,
                      offsetX: (index % 2 == 1) ? offsetX : 0.0, // simplified zig zag
                      isUnlocked: isUnlocked,
                      isCurrentLevel: isCurrentLevel,
                      name: _getLevelName(levelNumber),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
      loading: () => const Scaffold(backgroundColor: AppColors.background, body: Center(child: CircularProgressIndicator(color: AppColors.primary))),
      error: (err, stack) => Scaffold(backgroundColor: AppColors.background, body: Center(child: Text('Erro: $err', style: const TextStyle(color: AppColors.textPrimary)))),
    );
  }

  String _getLevelName(int level) {
    const levels = [
      'Pré-A1 - Básico', 'A1.1 - Iniciante', 'A1.2 - Iniciante II',
      'A2.1 - Elementar', 'A2.2 - Elementar II', 'B1.1 - Intermediário',
      'B1.2 - Intermediário II', 'B2.1 - Intermediário Superior', 'B2.2 - Superior II',
      'C1.1 - Avançado', 'C1.2 - Avançado II', 'C2 - Proficiente'
    ];
    if (level < 1 || level > 12) return 'Desconhecido';
    return levels[level - 1];
  }
}

class _PathNode extends StatelessWidget {
  final int levelNumber;
  final double offsetX;
  final bool isUnlocked;
  final bool isCurrentLevel;
  final String name;

  const _PathNode({
    required this.levelNumber,
    required this.offsetX,
    required this.isUnlocked,
    required this.isCurrentLevel,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    final bgColor = isCurrentLevel 
        ? AppColors.primary // Cyan for current pulse
        : (isUnlocked ? AppColors.secondary : AppColors.surfaceLight); // Emerald for unlocked, Slate for locked
        
    final shadowColor = isCurrentLevel 
        ? AppColors.primary.withOpacity(0.5) 
        : (isUnlocked ? AppColors.secondary.withOpacity(0.4) : Colors.transparent);

    return Container(
      margin: const EdgeInsets.only(bottom: 24), // Spacing between nodes
      child: Transform.translate(
        offset: Offset(offsetX, 0),
        child: Column(
          children: [
            // The Crown indicating current level
            if (isCurrentLevel) ...[
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.background,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primary, width: 2),
                  boxShadow: [
                    BoxShadow(color: AppColors.primary.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)
                  ]
                ),
                child: const Text('INICIAR CIRCUITO', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
              ),
              const SizedBox(height: 8),
              const Icon(Icons.arrow_drop_down, color: AppColors.primary, size: 32),
            ],

            // The Node Button
            GestureDetector(
              onTap: isUnlocked ? () {
                // Navegar para lição
              } : null,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: isUnlocked ? bgColor : AppColors.surface,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isUnlocked ? Colors.transparent : AppColors.border,
                    width: 3,
                  ),
                  boxShadow: isUnlocked ? [
                    BoxShadow(
                      color: shadowColor,
                      blurRadius: 15,
                      offset: const Offset(0, 0), // Glowing effect instead of solid 3d shadow
                    ),
                  ] : null,
                ),
                child: Center(
                  child: Icon(
                    isCurrentLevel ? Icons.bolt_rounded : (isUnlocked ? Icons.check_rounded : Icons.lock_rounded),
                    color: isUnlocked ? AppColors.background : AppColors.textSecondary,
                    size: 40,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
