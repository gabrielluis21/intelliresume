// lib/data/datasources/remote/api_resume_ds.dart

/* import 'package:http/http.dart' as http;
 import 'dart:convert';
 import 'remote_resume_ds.dart';

 class ApiResumeDataSource implements RemoteResumeDataSource {
   final String baseUrl;
   ApiResumeDataSource({required this.baseUrl});

   @override
   Future<void> saveResume(String userId, Map<String, dynamic> data) async {
     final url = Uri.parse('$baseUrl/resumes/$userId');
     final resp = await http.put(
       url,
       headers: {'Content-Type': 'application/json'},
       body: jsonEncode(data),
     );
     if (resp.statusCode != 200) {
       throw Exception('Falha ao salvar: ${resp.body}');
     }
   }

   @override
   Future<Map<String, dynamic>?> fetchResume(String userId) async {
     final url = Uri.parse('$baseUrl/resumes/$userId');
     final resp = await http.get(url);
     if (resp.statusCode == 200) {
       return jsonDecode(resp.body) as Map<String, dynamic>;
     }
     if (resp.statusCode == 404) return null;
     throw Exception('Erro na API: ${resp.body}');
   }
 }
 */
