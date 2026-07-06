import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelmateai/core/constants/phrasebook_data.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';

class PhrasebookPage extends StatefulWidget {
  const PhrasebookPage({super.key});

  @override
  State<PhrasebookPage> createState() => _PhrasebookPageState();
}

class _PhrasebookPageState extends State<PhrasebookPage> {
  int _languageIndex = 0;

  PhrasebookLanguage get _language => PhrasebookData.languages[_languageIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Local Phrasebook')),
      body: Column(
        children: [
          SizedBox(
            height: 56,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              itemCount: PhrasebookData.languages.length,
              separatorBuilder: (_, _) => const SizedBox(width: AppSpacing.sm),
              itemBuilder: (context, i) {
                final lang = PhrasebookData.languages[i];
                final selected = i == _languageIndex;
                return FilterChip(
                  label: Text('${lang.flag} ${lang.name}'),
                  selected: selected,
                  onSelected: (_) => setState(() => _languageIndex = i),
                );
              },
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _language.phrases.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final phrase = _language.phrases[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(phrase.english),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        phrase.translation,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      if (phrase.pronunciation != null)
                        Text(
                          phrase.pronunciation!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                                fontStyle: FontStyle.italic,
                              ),
                        ),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.copy_outlined),
                    tooltip: 'Copy phrase',
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: phrase.translation));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Copied "${phrase.translation}"')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
