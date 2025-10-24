## Plano para Implementar Preferências do Usuário (Idioma, Tema, Acessibilidade) com Hive

**Objetivo:** Implementar um sistema robusto de gerenciamento de preferências do usuário usando `hive` para persistência e `flutter_riverpod` para gerenciamento de estado, cobrindo configurações de idioma, tema e acessibilidade.

**Passos:**

1.  **Adicionar Dependências `hive` e `hive_flutter` (se não já presentes):**
    *   Verificar se `hive` e `hive_flutter` estão no `pubspec.yaml`.
    *   Executar `flutter pub get`.

2.  **Definir Modelos de Preferência (ex: `UserPreferences`):**
    *   Criar uma classe `UserPreferences` para armazenar o idioma escolhido pelo usuário, o modo de tema e as configurações de acessibilidade (ex: alto contraste, texto em negrito, escala do tamanho da fonte).
    *   Usar anotações `hive_generator` (`@HiveType`, `@HiveField`) para `UserPreferences` e quaisquer classes de preferência aninhadas.
    *   Executar `flutter pub run build_runner build` para gerar os arquivos `*.g.dart`.

3.  **Criar um `UserPreferencesRepository` para lidar com a persistência usando Hive:**
    *   Este repositório abrirá uma caixa Hive, salvará e carregará o objeto `UserPreferences`.

4.  **Criar um `UserPreferencesNotifier` usando `flutter_riverpod`:**
    *   Este `StateNotifier` manterá o objeto `UserPreferences` atual e fornecerá métodos para atualizar as configurações de idioma, tema e acessibilidade.
    *   Ele notificará os ouvintes sobre as alterações e persistirá as atualizações através do `UserPreferencesRepository`.

5.  **Integrar com `MaterialApp` e UI:**
    *   No `main.dart` (ou na raiz do seu aplicativo), usar `ConsumerWidget` para ouvir o `UserPreferencesNotifier`.
    *   Atualizar `MaterialApp`'s `locale`, `themeMode` e potencialmente outras propriedades relacionadas ao tema com base no estado de `UserPreferences`.
    *   Criar elementos de UI (ex: em uma página de configurações) para permitir que os usuários alterem suas preferências, chamando métodos no `UserPreferencesNotifier`.

**Modificações de Código Detalhadas (Conceitual):**

**`pubspec.yaml`:** (Verificar se `hive` e `hive_flutter` estão presentes)

```yaml
dependencies:
  flutter:
    sdk: flutter
  hive: ^2.0.0 # Ou a versão mais recente
  hive_flutter: ^1.1.0 # Ou a versão mais recente
  flutter_riverpod: ^2.0.0 # Conforme o contexto do projeto
dev_dependencies:
  hive_generator: ^2.0.0 # Ou a versão mais recente
  build_runner: ^2.0.0 # Ou a versão mais recente
```

**`lib/core/models/user_preferences.dart` (Novo Arquivo):**

```dart
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'user_preferences.g.dart';

@HiveType(typeId: 0)
class UserPreferences {
  @HiveField(0)
  final String? languageCode; // ex: 'en', 'pt'

  @HiveField(1)
  final ThemeMode themeMode; // ThemeMode.system, ThemeMode.light, ThemeMode.dark

  @HiveField(2)
  final bool highContrast;

  @HiveField(3)
  final bool boldText;

  @HiveField(4)
  final double fontSizeScale; // ex: 1.0, 1.2

  UserPreferences({
    this.languageCode,
    this.themeMode = ThemeMode.system,
    this.highContrast = false,
    this.boldText = false,
    this.fontSizeScale = 1.0,
  });

  UserPreferences copyWith({
    String? languageCode,
    ThemeMode? themeMode,
    bool? highContrast,
    bool? boldText,
    double? fontSizeScale,
  }) {
    return UserPreferences(
      languageCode: languageCode ?? this.languageCode,
      themeMode: themeMode ?? this.themeMode,
      highContrast: highContrast ?? this.highContrast,
      boldText: boldText ?? this.boldText,
      fontSizeScale: fontSizeScale ?? this.fontSizeScale,
    );
  }
}
```

**`lib/core/repositories/user_preferences_repository.dart` (Novo Arquivo):**

```dart
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intelliresume/core/models/user_preferences.dart';

class UserPreferencesRepository {
  static const String _boxName = 'userPreferencesBox';
  static const String _preferencesKey = 'userPreferences';

  Future<Box<UserPreferences>> _openBox() async {
    if (!Hive.isAdapterRegistered(UserPreferencesAdapter().typeId)) {
      Hive.registerAdapter(UserPreferencesAdapter());
    }
    return await Hive.openBox<UserPreferences>(_boxName);
  }

  Future<UserPreferences> loadPreferences() async {
    final box = await _openBox();
    return box.get(_preferencesKey) ?? UserPreferences(); // Retorna padrão se não encontrado
  }

  Future<void> savePreferences(UserPreferences preferences) async {
    final box = await _openBox();
    await box.put(_preferencesKey, preferences);
  }
}
```

**`lib/core/providers/user_preferences_provider.dart` (Novo Arquivo):**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intelliresume/core/models/user_preferences.dart';
import 'package:intelliresume/core/repositories/user_preferences_repository.dart';

final userPreferencesRepositoryProvider = Provider((ref) => UserPreferencesRepository());

final userPreferencesNotifierProvider = StateNotifierProvider<UserPreferencesNotifier, UserPreferences>((ref) {
  return UserPreferencesNotifier(ref.read(userPreferencesRepositoryProvider));
});

class UserPreferencesNotifier extends StateNotifier<UserPreferences> {
  final UserPreferencesRepository _repository;

  UserPreferencesNotifier(this._repository) : super(UserPreferences()) {
    _loadInitialPreferences();
  }

  Future<void> _loadInitialPreferences() async {
    state = await _repository.loadPreferences();
  }

  Future<void> setLanguage(String? languageCode) async {
    state = state.copyWith(languageCode: languageCode);
    await _repository.savePreferences(state);
  }

  Future<void> setThemeMode(ThemeMode themeMode) async {
    state = state.copyWith(themeMode: themeMode);
    await _repository.savePreferences(state);
  }

  Future<void> setHighContrast(bool highContrast) async {
    state = state.copyWith(highContrast: highContrast);
    await _repository.savePreferences(state);
  }

  Future<void> setBoldText(bool boldText) async {
    state = state.copyWith(boldText: boldText);
    await _repository.savePreferences(state);
  }

  Future<void> setFontSizeScale(double scale) async {
    state = state.copyWith(fontSizeScale: scale);
    await _repository.savePreferences(state);
  }
}
```

**`lib/main.dart` (Modificações):**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hive_flutter/hive_flutter.dart'; // Nova importação
import 'package:intelliresume/core/models/user_preferences.dart'; // Nova importação
import 'package:intelliresume/core/providers/user_preferences_provider.dart'; // Nova importação
import 'package:intelliresume/app.dart'; // Assumindo que seu widget principal do app está aqui

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter(); // Inicializa Hive
  // Registra o adapter se ainda não foi registrado pelo repositório
  if (!Hive.isAdapterRegistered(UserPreferencesAdapter().typeId)) {
    Hive.registerAdapter(UserPreferencesAdapter());
  }

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferences = ref.watch(userPreferencesNotifierProvider);

    return MaterialApp(
      title: 'IntelliResume',
      // Usa o locale das preferências do usuário, ou null para fallback para o locale do sistema
      locale: userPreferences.languageCode != null
          ? Locale(userPreferences.languageCode!)
          : null,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: userPreferences.themeMode, // Usa o modo de tema das preferências
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        // Aplica configurações de acessibilidade aqui (ex: textTheme, visualDensity)
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: userPreferences.fontSizeScale,
              fontWeightDelta: userPreferences.boldText ? 2 : 0,
            ),
        visualDensity: userPreferences.highContrast
            ? VisualDensity.comfortable
            : VisualDensity.adaptivePlatformDensity,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        textTheme: Theme.of(context).textTheme.apply(
              fontSizeFactor: userPreferences.fontSizeScale,
              fontWeightDelta: userPreferences.boldText ? 2 : 0,
            ),
        visualDensity: userPreferences.highContrast
            ? VisualDensity.comfortable
            : VisualDensity.adaptivePlatformDensity,
      ),
      home: const App(), // Seu widget principal do app
    );
  }
}
```

**`lib/app.dart` (Exemplo de como usar preferências na UI):**

```dart
// Exemplo de uma página de configurações onde o usuário pode alterar as preferências
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userPreferences = ref.watch(userPreferencesNotifierProvider);
    final notifier = ref.read(userPreferencesNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: userPreferences.languageCode ?? 'system',
              onChanged: (value) {
                notifier.setLanguage(value == 'system' ? null : value);
              },
              items: const [
                DropdownMenuItem(value: 'system', child: Text('System Default')),
                DropdownMenuItem(value: 'en', child: Text('English')),
                DropdownMenuItem(value: 'pt', child: Text('Portuguese')),
                // Adicionar outros idiomas suportados
              ],
            ),
          ),
          ListTile(
            title: const Text('Theme Mode'),
            trailing: DropdownButton<ThemeMode>(
              value: userPreferences.themeMode,
              onChanged: (value) {
                if (value != null) notifier.setThemeMode(value);
              },
              items: const [
                DropdownMenuItem(value: ThemeMode.system, child: Text('System')),
                DropdownMenuItem(value: ThemeMode.light, child: Text('Light')),
                DropdownMenuItem(value: ThemeMode.dark, child: Text('Dark')),
              ],
            ),
          ),
          SwitchListTile(
            title: const Text('High Contrast'),
            value: userPreferences.highContrast,
            onChanged: (value) => notifier.setHighContrast(value),
          ),
          SwitchListTile(
            title: const Text('Bold Text'),
            value: userPreferences.boldText,
            onChanged: (value) => notifier.setBoldText(value),
          ),
          ListTile(
            title: const Text('Font Size Scale'),
            trailing: Slider(
              value: userPreferences.fontSizeScale,
              min: 0.8,
              max: 1.5,
              divisions: 7,
              onChanged: (value) => notifier.setFontSizeScale(value),
            ),
          ),
        ],
      ),
    );
  }
}
