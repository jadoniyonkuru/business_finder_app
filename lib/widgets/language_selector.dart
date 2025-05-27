import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/language_provider.dart';
import '../l10n/app_localizations.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({super.key});

  @override
  Widget build(BuildContext context) {
    final languageProvider = Provider.of<LanguageProvider>(context);
    final localizations = AppLocalizations.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(16.0),
          child: Text(
            'Select Language',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _buildLanguageTile(
              context,
              'English',
              'en',
              languageProvider,
              localizations,
            ),
            _buildLanguageTile(
              context,
              'Español',
              'es',
              languageProvider,
              localizations,
            ),
            _buildLanguageTile(
              context,
              'Français',
              'fr',
              languageProvider,
              localizations,
            ),
            _buildLanguageTile(
              context,
              'Deutsch',
              'de',
              languageProvider,
              localizations,
            ),
            _buildLanguageTile(
              context,
              'Italiano',
              'it',
              languageProvider,
              localizations,
            ),
            _buildLanguageTile(
              context,
              'Português',
              'pt',
              languageProvider,
              localizations,
            ),
            _buildLanguageTile(
              context,
              'Русский',
              'ru',
              languageProvider,
              localizations,
            ),
            _buildLanguageTile(
              context,
              '中文',
              'zh',
              languageProvider,
              localizations,
            ),
            _buildLanguageTile(
              context,
              '日本語',
              'ja',
              languageProvider,
              localizations,
            ),
            _buildLanguageTile(
              context,
              '한국어',
              'ko',
              languageProvider,
              localizations,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLanguageTile(
    BuildContext context,
    String languageName,
    String languageCode,
    LanguageProvider languageProvider,
    AppLocalizations localizations,
  ) {
    final isSelected = languageProvider.currentLocale.languageCode == languageCode;

    return ListTile(
      title: Text(languageName),
      trailing: isSelected ? const Icon(Icons.check, color: Colors.blue) : null,
      onTap: () async {
        await languageProvider.setLanguage(languageCode);
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('${localizations.language} changed to $languageName'),
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
    );
  }
} 