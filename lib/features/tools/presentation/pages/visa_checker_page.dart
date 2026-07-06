import 'package:flutter/material.dart';
import 'package:travelmateai/core/services/visa_service.dart';
import 'package:travelmateai/core/theme/app_spacing.dart';

class VisaCheckerPage extends StatefulWidget {
  const VisaCheckerPage({super.key});

  @override
  State<VisaCheckerPage> createState() => _VisaCheckerPageState();
}

class _VisaCheckerPageState extends State<VisaCheckerPage> {
  final _service = VisaService();
  String _passport = VisaService.passportCountries.first;
  String _destination = VisaService.destinationCountries.first;
  VisaRequirement? _result;

  void _check() {
    setState(() {
      _result = _service.check(
        passportCountry: _passport,
        destinationCountry: _destination,
      );
    });
  }

  @override
  void initState() {
    super.initState();
    _check();
  }

  @override
  Widget build(BuildContext context) {
    final result = _result;

    return Scaffold(
      appBar: AppBar(title: const Text('Visa Checker')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          Text(
            'Check entry requirements',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            'Select your passport and destination. Always verify with official sources before travel.',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: AppSpacing.lg),
          DropdownButtonFormField<String>(
            initialValue: _passport,
            decoration: const InputDecoration(
              labelText: 'Your passport',
              prefixIcon: Icon(Icons.badge_outlined),
            ),
            items: VisaService.passportCountries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) {
              setState(() => _passport = v ?? _passport);
              _check();
            },
          ),
          const SizedBox(height: AppSpacing.md),
          DropdownButtonFormField<String>(
            initialValue: _destination,
            decoration: const InputDecoration(
              labelText: 'Destination country',
              prefixIcon: Icon(Icons.flight_land_outlined),
            ),
            items: VisaService.destinationCountries
                .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                .toList(),
            onChanged: (v) {
              setState(() => _destination = v ?? _destination);
              _check();
            },
          ),
          const SizedBox(height: AppSpacing.lg),
          if (result != null) _ResultCard(requirement: result),
          const SizedBox(height: AppSpacing.md),
          Card(
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'This tool provides general guidance only. Visa rules change — '
                      'confirm with the embassy or official government site.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  const _ResultCard({required this.requirement});

  final VisaRequirement requirement;

  Color _statusColor(BuildContext context, VisaStatus status) => switch (status) {
        VisaStatus.visaFree => Colors.green,
        VisaStatus.visaOnArrival => Colors.teal,
        VisaStatus.eVisa => Colors.blue,
        VisaStatus.eta => Colors.orange,
        VisaStatus.visaRequired => Theme.of(context).colorScheme.error,
      };

  @override
  Widget build(BuildContext context) {
    final color = _statusColor(context, requirement.status);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.verified_outlined, color: color),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    requirement.status.label,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: color,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              '${requirement.passportCountry} → ${requirement.destinationCountry}',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(requirement.summary),
            const SizedBox(height: AppSpacing.md),
            _DetailRow(label: 'Max stay', value: requirement.maxStay),
            if (requirement.notes.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.md),
              Text('Notes', style: Theme.of(context).textTheme.labelLarge),
              ...requirement.notes.map(
                (n) => Padding(
                  padding: const EdgeInsets.only(top: AppSpacing.xs),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('• '),
                      Expanded(child: Text(n, style: Theme.of(context).textTheme.bodySmall)),
                    ],
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$label: ', style: Theme.of(context).textTheme.labelLarge),
        Text(value),
      ],
    );
  }
}
