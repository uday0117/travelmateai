/// Emergency numbers and contacts by country.
abstract final class EmergencyContactsData {
  static const countries = [
    EmergencyCountry(
      name: 'United States',
      flag: '🇺🇸',
      general: '911',
      police: '911',
      ambulance: '911',
      fire: '911',
      embassyNote: 'Contact your home country embassy via state.gov',
    ),
    EmergencyCountry(
      name: 'United Kingdom',
      flag: '🇬🇧',
      general: '999 or 112',
      police: '999',
      ambulance: '999',
      fire: '999',
      embassyNote: 'Foreign Commonwealth Office: +44 20 7008 1500',
    ),
    EmergencyCountry(
      name: 'France',
      flag: '🇫🇷',
      general: '112',
      police: '17',
      ambulance: '15',
      fire: '18',
      embassyNote: 'EU emergency number 112 works everywhere',
    ),
    EmergencyCountry(
      name: 'Germany',
      flag: '🇩🇪',
      general: '112',
      police: '110',
      ambulance: '112',
      fire: '112',
    ),
    EmergencyCountry(
      name: 'Japan',
      flag: '🇯🇵',
      general: '110 / 119',
      police: '110',
      ambulance: '119',
      fire: '119',
      embassyNote: 'Japan Visitor Hotline: 050-3816-2787',
    ),
    EmergencyCountry(
      name: 'Australia',
      flag: '🇦🇺',
      general: '000',
      police: '000',
      ambulance: '000',
      fire: '000',
    ),
    EmergencyCountry(
      name: 'India',
      flag: '🇮🇳',
      general: '112',
      police: '100',
      ambulance: '102',
      fire: '101',
      embassyNote: 'Tourist Helpline: 1363 or 1800111363',
    ),
    EmergencyCountry(
      name: 'Thailand',
      flag: '🇹🇭',
      general: '191',
      police: '191',
      ambulance: '1669',
      fire: '199',
      embassyNote: 'Tourist Police: 1155',
    ),
    EmergencyCountry(
      name: 'United Arab Emirates',
      flag: '🇦🇪',
      general: '999',
      police: '999',
      ambulance: '998',
      fire: '997',
    ),
    EmergencyCountry(
      name: 'Singapore',
      flag: '🇸🇬',
      general: '999',
      police: '999',
      ambulance: '995',
      fire: '995',
    ),
    EmergencyCountry(
      name: 'Italy',
      flag: '🇮🇹',
      general: '112',
      police: '113',
      ambulance: '118',
      fire: '115',
    ),
    EmergencyCountry(
      name: 'Spain',
      flag: '🇪🇸',
      general: '112',
      police: '091',
      ambulance: '061',
      fire: '080',
    ),
    EmergencyCountry(
      name: 'Brazil',
      flag: '🇧🇷',
      general: '190 / 192',
      police: '190',
      ambulance: '192',
      fire: '193',
    ),
    EmergencyCountry(
      name: 'Mexico',
      flag: '🇲🇽',
      general: '911',
      police: '911',
      ambulance: '911',
      fire: '911',
    ),
    EmergencyCountry(
      name: 'Turkey',
      flag: '🇹🇷',
      general: '112',
      police: '155',
      ambulance: '112',
      fire: '110',
    ),
    EmergencyCountry(
      name: 'South Korea',
      flag: '🇰🇷',
      general: '119',
      police: '112',
      ambulance: '119',
      fire: '119',
      embassyNote: 'Tourist Hotline: 1330',
    ),
  ];
}

class EmergencyCountry {
  const EmergencyCountry({
    required this.name,
    required this.flag,
    required this.general,
    required this.police,
    required this.ambulance,
    required this.fire,
    this.embassyNote,
  });

  final String name;
  final String flag;
  final String general;
  final String police;
  final String ambulance;
  final String fire;
  final String? embassyNote;
}
