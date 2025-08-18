import 'package:flutter/material.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';

class HeaderSection extends StatelessWidget {
  final UserProfile? user;
  final TextTheme theme;

  const HeaderSection({super.key, required this.user, required this.theme});

  @override
  Widget build(BuildContext c) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child:
          user == null
              ? Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nome não disponível",
                        style: theme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Email não disponível | Telefone não disponível",
                        style: theme.headlineSmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ],
              )
              : ListTile(
                contentPadding: const EdgeInsets.all(16),
                leading: Semantics(
                  label: 'Foto de perfil de ${user?.name ?? "usuário"}',
                  image: true,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        user?.profilePictureUrl == null
                            ? Image.asset(
                              'images/default_avatar.png',
                              fit: BoxFit.contain,
                            ).image
                            : Image.network(
                              user!.profilePictureUrl!,
                              fit: BoxFit.contain,
                            ).image,
                    backgroundColor: Colors.grey.shade200,
                  ),
                ),
                title: Text(
                  "${user?.name}",
                  style: theme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  "${user?.email} | ${user?.phone}",
                  maxLines: 2,
                  style: theme.headlineSmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ),
    );
  }
}
