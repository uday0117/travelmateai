import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:travelmateai/core/constants/emergency_contacts_data.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';

class EmergencyContactsPage extends StatefulWidget {
  const EmergencyContactsPage({super.key});

  @override
  State<EmergencyContactsPage> createState() => _EmergencyContactsPageState();
}

class _EmergencyContactsPageState extends State<EmergencyContactsPage> {
  String _query = '';

  List<EmergencyCountry> get _filtered {
    if (_query.isEmpty) return EmergencyContactsData.countries;
    final q = _query.toLowerCase();
    return EmergencyContactsData.countries
        .where((c) => c.name.toLowerCase().contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Emergency Contacts')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.md,
              AppSpacing.sm,
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search country…',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(AppSpacing.md),
              itemCount: _filtered.length,
              itemBuilder: (context, i) {
                final country = _filtered[i];
                return Card(
                  margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: ExpansionTile(
                    leading: Text(country.flag, style: const TextStyle(fontSize: 28)),
                    title: Text(country.name),
                    subtitle: Text('General: ${country.general}'),
                    children: [
                      _ContactTile(
                        icon: Icons.local_police_outlined,
                        label: 'Police',
                        number: country.police,
                      ),
                      _ContactTile(
                        icon: Icons.medical_services_outlined,
                        label: 'Ambulance',
                        number: country.ambulance,
                      ),
                      _ContactTile(
                        icon: Icons.local_fire_department_outlined,
                        label: 'Fire',
                        number: country.fire,
                      ),
                      if (country.embassyNote != null)
                        Padding(
                          padding: const EdgeInsets.fromLTRB(
                            AppSpacing.md,
                            0,
                            AppSpacing.md,
                            AppSpacing.md,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.info_outline,
                                size: 18,
                                color: Theme.of(context).colorScheme.onSurfaceVariant,
                              ),
                              const SizedBox(width: AppSpacing.sm),
                              Expanded(
                                child: Text(
                                  country.embassyNote!,
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                      ),
                                ),
                              ),
                            ],
                          ),
                        ),
                    ],
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

class _ContactTile extends StatelessWidget {
  const _ContactTile({
    required this.icon,
    required this.label,
    required this.number,
  });

  final IconData icon;
  final String label;
  final String number;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon),
      title: Text(label),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            number,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          IconButton(
            icon: const Icon(Icons.copy_outlined),
            tooltip: 'Copy number',
            onPressed: () {
              Clipboard.setData(ClipboardData(text: number));
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Copied $number')),
              );
            },
          ),
        ],
      ),
    );
  }
}
