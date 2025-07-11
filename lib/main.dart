import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'core/providers/user_provider.dart';
import 'data/datasources/local/local_user_profile_ds.dart';
import 'data/datasources/remote/remote_user_profile_ds.dart';
import 'data/repositories/user_profile_repository.dart';
import 'firebase_options.dart';
import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MobileAds.instance.initialize();
  await Hive.initFlutter();

  final userRepo = UserProfileRepositoryImpl(
    remote: RemoteUserProfileDataSource(), // seu DataSource remoto
    local: HiveUserProfileDataSource(), // seu DataSource local
  );

  runApp(
    ProviderScope(
      overrides: [userProfileRepositoryProvider.overrideWithValue(userRepo)],
      child: App(),
    ),
  );
}
