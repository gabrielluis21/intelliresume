import 'package:flutter/material.dart'; // Added import
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intelliresume/domain/entities/linkedin_profile_entity.dart';
import 'package:intelliresume/domain/repositories/linkedin_repository.dart';
import 'package:url_launcher/url_launcher.dart';

class LinkedInRepositoryImpl implements LinkedInRepository {
  // TODO: Move to a config file
  // TODO: Configure these values in your .env file
  final String _backendUrl = 'YOUR_BACKEND_AUTH_LINKEDIN_URL';
  final String _clientId = 'YOUR_LINKEDIN_CLIENT_ID';
  final String _clientSecret = 'YOUR_LINKEDIN_CLIENT_SECRET';
  final String _redirectUrl =
      'YOUR_LINKEDIN_REDIRECT_URL'; // e.g., 'https://your-app.com/linkedin-redirect' or a custom scheme like 'your-app://linkedin-redirect'

  LinkedInRepositoryImpl();

  @override
  Future<void> signIn(BuildContext context, {String? nextUrl}) async {
    final backendUrl = dotenv.env['BACKEND_URL'];
    final frontendUrl = dotenv.env['FRONTEND_URL'];

    if (backendUrl == null || frontendUrl == null) {
      throw Exception('BACKEND_URL or FRONTEND_URL not configured in .env');
    }

    // The backend will redirect to this URL after authenticating with LinkedIn.
    // We encode the final destination (`nextUrl`) into the `redirect_url` itself.
    final redirectUrl =
        '$frontendUrl/auth-callback?next=${Uri.encodeComponent(nextUrl ?? '/dashboard')}';

    final url = Uri.parse(
      '$backendUrl/auth/linkedin?redirect_url=${Uri.encodeComponent(redirectUrl)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Future<LinkedInProfileEntity> importProfile() async {
    // This method would use the LinkedIn access token (stored securely)
    // to make calls to the LinkedIn API and fetch profile data.
    // For now, it returns dummy data.

    // TODO: Implement actual data fetching from LinkedIn API

    return Future.value(
      LinkedInProfileEntity(
        name: 'John Doe',
        headline: 'Software Engineer at Acme Inc.',
        summary:
            'A passionate software engineer with experience in Flutter and Dart.',
        experiences: [
          ExperienceEntity(
            companyName: 'Acme Inc.',
            title: 'Software Engineer',
            startDate: DateTime(2022, 1, 1),
          ),
        ],
        educations: [
          EducationEntity(
            schoolName: 'University of Example',
            degree: 'Bachelor of Science',
            fieldOfStudy: 'Computer Science',
            startDate: DateTime(2018, 9, 1),
            endDate: DateTime(2022, 5, 1),
          ),
        ],
      ),
    );
  }
}
