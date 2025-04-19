import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eurovision_song_contest_clone/core/constants/constant_index.dart';

class CountryCodeConverter {
  static const Map<String, String> countryMap = {
    'AL': 'Albania',
    'AD': 'Andorra',
    'AM': 'Armenia',
    'AU': 'Australia',
    'AT': 'Austria',
    'AZ': 'Azerbaijan',
    'BY': 'Belarus',
    'BE': 'Belgium',
    'BA': 'Bosnia & Herzegovina',
    'BG': 'Bulgaria',
    'HR': 'Croatia',
    'CY': 'Cyprus',
    'CZ': 'Czech Republic',
    'DK': 'Denmark',
    'EE': 'Estonia',
    'FI': 'Finland',
    'FR': 'France',
    'GE': 'Georgia',
    'DE': 'Germany',
    'GR': 'Greece',
    'HU': 'Hungary',
    'IS': 'Iceland',
    'IE': 'Ireland',
    'IL': 'Israel',
    'IT': 'Italy',
    'LV': 'Latvia',
    'LT': 'Lithuania',
    'LU': 'Luxembourg',
    'MT': 'Malta',
    'MD': 'Moldova',
    'MC': 'Monaco',
    'ME': 'Montenegro',
    'MA': 'Morocco',
    'NL': 'Netherlands',
    'MK': 'North Macedonia',
    'NO': 'Norway',
    'PL': 'Poland',
    'PT': 'Portugal',
    'RO': 'Romania',
    'RU': 'Russia',
    'SM': 'San Marino',
    'RS': 'Serbia',
    'CS': 'Serbia & Montenegro',
    'SK': 'Slovakia',
    'SI': 'Slovenia',
    'ES': 'Spain',
    'SE': 'Sweden',
    'CH': 'Switzerland',
    'TR': 'Turkey',
    'UA': 'Ukraine',
    'GB': 'United Kingdom',
    'YU': 'Yugoslavia',
  };

  static Future<String> convertCountryCodeToCountryName(
      String countryCode) async {
    if (countryMap.containsKey(countryCode)) {
      return countryMap[countryCode]!;
    }

    try {
      final response = await http.get(
        Uri.parse('${Consts.baseUrl}/countries/$countryCode'),
      );

      if (response.statusCode == 200) {
        try {
          final String countryName = json.decode(response.body);
          if (countryName.isNotEmpty) {
            return countryName;
          }
        } catch (e) {}
      }
    } catch (e) {}

    return countryCode;
  }

  static String convertCountryCodeToCountryNameSync(String countryCode) {
    return countryMap[countryCode] ?? countryCode;
  }
}
