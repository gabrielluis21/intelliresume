import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';

class AIService {
  // Singleton
  AIService._();
  static final instance = AIService._();

  final _openAI = OpenAI.instance.build(
    token: 'YOUR_OPENAI_API_KEY',
    baseOption: HttpSetup(receiveTimeout: const Duration(seconds: 60)),
  );

  Future<String> evaluate(String text) async {
    final chat = await _openAI.onChatCompletion(
      request: ChatCompleteText(
        model: GptTurboChatModel(),
        messages: [
          Map.of({
            'role': Role.system,
            'content': 'Você é um recrutador sênior. Avalie o currículo:',
          }),
          Map.of({'role': Role.user, 'content': text}),
        ],
      ),
    );
    return chat!.choices.first.message!.content;
  }

  Future<String> translate(String text, String to) async {
    final chat = await _openAI.onChatCompletion(
      request: ChatCompleteText(
        model: GptTurboChatModel(),
        messages: [
          Map.of({
            'role': Role.system,
            'content': 'Traduza o texto para $to, mantendo nomes e formatação.',
          }),
          Map.of({'role': Role.user, 'content': text}),
        ],
      ),
    );
    return chat!.choices.first.message!.content;
  }

  Future<String> correct(String text) async {
    final chat = await _openAI.onChatCompletion(
      request: ChatCompleteText(
        model: GptTurboChatModel(),
        messages: [
          Map.of({
            'role': Role.system,
            'content': 'Corrija erros gramaticais e de estilo:',
          }),
          Map.of({'role': Role.user, 'content': text}),
        ],
      ),
    );
    return chat!.choices.first.message!.content;
  }
}
