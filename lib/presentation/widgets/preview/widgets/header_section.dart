import 'package:flutter/material.dart';
import 'package:intelliresume/domain/entities/user_profile.dart';
import 'package:intelliresume/generated/app_localizations.dart'; // New import

class HeaderSection extends StatelessWidget {
  final UserProfile? user;
  final TextTheme theme;

  const HeaderSection({super.key, required this.user, required this.theme});

  @override
  Widget build(BuildContext c) {
    final l10n = AppLocalizations.of(c)!; // Initialize l10n
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
                        l10n.headerSection_nameNotAvailable, // Internationalized
                        style: theme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.headerSection_contactNotAvailable, // Internationalized
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
                  label: l10n.headerSection_profilePictureSemanticLabel(
                      user?.name ?? l10n.profilePage_defaultUserName), // Internationalized
                  image: true,
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage:
                        user?.profilePictureUrl == null
                            ? Image.asset(
                              'assets/images/default_avatar.png', // Updated path
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
