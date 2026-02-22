import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../auth/presentation/auth_controller.dart';
import '../profile/presentation/profile_providers.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userState = ref.watch(authStateProvider);
    final profileState = ref.watch(currentStudentProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('EasyPeak: Trilha'),
        actions: [
          profileState.when(
            data: (profile) => Row(
              children: [
                const Icon(Icons.whatshot, color: Colors.orange),
                const SizedBox(width: 4),
                Text('${profile?.streakDays ?? 0}', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 4),
                Text('${profile?.xp ?? 0} XP', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(width: 16),
              ],
            ),
            loading: () => const Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))),
            ),
            error: (_, __) => const SizedBox(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ref.read(authControllerProvider.notifier).signOut();
            },
          )
        ],
      ),
      body: userState.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Redirecionando para login...'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Bem-vindo, ${user.name ?? user.email}!',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: 12, // 12 Níveis (Pré-A1 a C2)
                  itemBuilder: (context, index) {
                    final levelNumber = index + 1;
                    
                    final currentDbLevel = profileState.value?.currentLevelId ?? 1;
                    
                    final isUnlocked = levelNumber <= currentDbLevel; 
                    final isCurrentLevel = levelNumber == currentDbLevel;

                    return Card(
                      color: isUnlocked ? null : Colors.grey.shade300,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: isCurrentLevel
                              ? Colors.deepPurple
                              : (isUnlocked ? Colors.green : Colors.grey),
                          child: Icon(
                            isCurrentLevel
                                ? Icons.play_arrow
                                : (isUnlocked ? Icons.check : Icons.lock),
                            color: Colors.white,
                          ),
                        ),
                        title: Text('Nível $levelNumber - ${_getLevelName(levelNumber)}'),
                        subtitle: Text(
                          isCurrentLevel
                              ? 'Progresso atual'
                              : (isUnlocked ? 'Concluído' : 'Bloqueado'),
                        ),
                        onTap: isUnlocked
                            ? () {
                                // Navegar para a tela de lições
                              }
                            : null,
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Erro: $err')),
      ),
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
