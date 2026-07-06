/// Visa requirement lookup for common passport / destination pairs.
class VisaRequirement {
  const VisaRequirement({
    required this.passportCountry,
    required this.destinationCountry,
    required this.status,
    required this.summary,
    required this.maxStay,
    this.notes = const [],
  });

  final String passportCountry;
  final String destinationCountry;
  final VisaStatus status;
  final String summary;
  final String maxStay;
  final List<String> notes;
}

enum VisaStatus {
  visaFree('Visa Free', 'No visa required'),
  visaOnArrival('Visa on Arrival', 'Visa available at border'),
  eVisa('e-Visa', 'Apply online before travel'),
  visaRequired('Visa Required', 'Apply at embassy or consulate'),
  eta('ETA / eTA', 'Electronic travel authorization required');

  const VisaStatus(this.label, this.description);
  final String label;
  final String description;
}

class VisaService {
  static const passportCountries = [
    'United States',
    'United Kingdom',
    'Canada',
    'Australia',
    'India',
    'Germany',
    'France',
    'Japan',
    'Brazil',
    'United Arab Emirates',
  ];

  static const destinationCountries = [
    'France',
    'Japan',
    'Thailand',
    'United States',
    'United Kingdom',
    'Australia',
    'India',
    'United Arab Emirates',
    'Turkey',
    'Brazil',
    'Mexico',
    'Singapore',
    'South Korea',
    'Italy',
    'Spain',
  ];

  VisaRequirement check({
    required String passportCountry,
    required String destinationCountry,
  }) {
    final key = '${passportCountry.toLowerCase()}|${destinationCountry.toLowerCase()}';
    return _rules[key] ?? _defaultRequirement(passportCountry, destinationCountry);
  }

  VisaRequirement _defaultRequirement(String passport, String destination) {
    if (passport.toLowerCase() == destination.toLowerCase()) {
      return VisaRequirement(
        passportCountry: passport,
        destinationCountry: destination,
        status: VisaStatus.visaFree,
        summary: 'Domestic travel — no visa needed.',
        maxStay: 'Unlimited',
      );
    }
    return VisaRequirement(
      passportCountry: passport,
      destinationCountry: destination,
      status: VisaStatus.visaRequired,
      summary: 'A visa may be required. Confirm with the official embassy website.',
      maxStay: 'Varies',
      notes: const [
        'Requirements change frequently — verify before booking.',
        'Check passport validity (often 6 months beyond stay).',
      ],
    );
  }

  static final _rules = <String, VisaRequirement>{
    'united states|france': VisaRequirement(
      passportCountry: 'United States',
      destinationCountry: 'France',
      status: VisaStatus.visaFree,
      summary: 'US citizens can visit France visa-free for tourism.',
      maxStay: '90 days (Schengen)',
      notes: ['ETIAS may be required from 2025 onward.'],
    ),
    'united states|japan': VisaRequirement(
      passportCountry: 'United States',
      destinationCountry: 'Japan',
      status: VisaStatus.visaFree,
      summary: 'US passport holders may enter Japan without a visa for short stays.',
      maxStay: '90 days',
    ),
    'united states|thailand': VisaRequirement(
      passportCountry: 'United States',
      destinationCountry: 'Thailand',
      status: VisaStatus.visaFree,
      summary: 'US citizens can enter Thailand visa-free for tourism.',
      maxStay: '60 days',
    ),
    'united kingdom|france': VisaRequirement(
      passportCountry: 'United Kingdom',
      destinationCountry: 'France',
      status: VisaStatus.visaFree,
      summary: 'UK citizens can visit France visa-free.',
      maxStay: '90 days (Schengen)',
    ),
    'united kingdom|united states': VisaRequirement(
      passportCountry: 'United Kingdom',
      destinationCountry: 'United States',
      status: VisaStatus.eta,
      summary: 'UK citizens need ESTA approval before flying to the US.',
      maxStay: '90 days (VWP)',
      notes: ['Apply at least 72 hours before departure.'],
    ),
    'india|france': VisaRequirement(
      passportCountry: 'India',
      destinationCountry: 'France',
      status: VisaStatus.visaRequired,
      summary: 'Indian citizens need a Schengen visa for France.',
      maxStay: 'As per visa',
      notes: ['Apply at VFS Global or French consulate.'],
    ),
    'india|thailand': VisaRequirement(
      passportCountry: 'India',
      destinationCountry: 'Thailand',
      status: VisaStatus.visaOnArrival,
      summary: 'Indian citizens can obtain a visa on arrival in Thailand.',
      maxStay: '15 days (VOA) or apply e-Visa for longer stays',
    ),
    'india|united arab emirates': VisaRequirement(
      passportCountry: 'India',
      destinationCountry: 'United Arab Emirates',
      status: VisaStatus.visaFree,
      summary: 'Indian passport holders with valid US/UK/Schengen visa may get visa on arrival.',
      maxStay: '14 days',
      notes: ['Rules vary — confirm with UAE immigration.'],
    ),
    'india|singapore': VisaRequirement(
      passportCountry: 'India',
      destinationCountry: 'Singapore',
      status: VisaStatus.visaFree,
      summary: 'Indian citizens can visit Singapore visa-free for short tourism.',
      maxStay: '30 days',
    ),
    'australia|japan': VisaRequirement(
      passportCountry: 'Australia',
      destinationCountry: 'Japan',
      status: VisaStatus.visaFree,
      summary: 'Australian citizens can visit Japan without a visa.',
      maxStay: '90 days',
    ),
    'canada|united states': VisaRequirement(
      passportCountry: 'Canada',
      destinationCountry: 'United States',
      status: VisaStatus.eta,
      summary: 'Canadian citizens generally enter the US without a visa.',
      maxStay: '6 months (at discretion of CBP)',
    ),
    'germany|japan': VisaRequirement(
      passportCountry: 'Germany',
      destinationCountry: 'Japan',
      status: VisaStatus.visaFree,
      summary: 'German citizens can visit Japan visa-free.',
      maxStay: '90 days',
    ),
    'united arab emirates|united kingdom': VisaRequirement(
      passportCountry: 'United Arab Emirates',
      destinationCountry: 'United Kingdom',
      status: VisaStatus.eta,
      summary: 'UAE citizens need an ETA to visit the UK.',
      maxStay: '6 months',
    ),
    'brazil|france': VisaRequirement(
      passportCountry: 'Brazil',
      destinationCountry: 'France',
      status: VisaStatus.visaFree,
      summary: 'Brazilian citizens can visit France visa-free.',
      maxStay: '90 days (Schengen)',
    ),
    'japan|united states': VisaRequirement(
      passportCountry: 'Japan',
      destinationCountry: 'United States',
      status: VisaStatus.eta,
      summary: 'Japanese citizens need ESTA for visa-free entry to the US.',
      maxStay: '90 days (VWP)',
    ),
    'united states|turkey': VisaRequirement(
      passportCountry: 'United States',
      destinationCountry: 'Turkey',
      status: VisaStatus.eVisa,
      summary: 'US citizens can apply for a Turkish e-Visa online.',
      maxStay: '90 days',
    ),
    'united states|australia': VisaRequirement(
      passportCountry: 'United States',
      destinationCountry: 'Australia',
      status: VisaStatus.eta,
      summary: 'US citizens need an ETA for Australia.',
      maxStay: '90 days',
    ),
    'united states|india': VisaRequirement(
      passportCountry: 'United States',
      destinationCountry: 'India',
      status: VisaStatus.eVisa,
      summary: 'US citizens can apply for an Indian e-Visa.',
      maxStay: '30–180 days depending on visa type',
    ),
  };
}
