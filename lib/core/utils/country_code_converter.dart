import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:eurovision_song_contest_clone/core/constants/constant_index.dart';

class CountryCodeConverter {
  // Map of country codes to country names
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

  /// Converts a country code to its full name
  ///
  /// First tries to fetch from the Eurovision API, and if that fails or
  /// returns an invalid response, falls back to the local map.
  static Future<String> convertCountryCodeToCountryName(
      String countryCode) async {
    // First check our local map as it's faster
    if (countryMap.containsKey(countryCode)) {
      return countryMap[countryCode]!;
    }

    // If not found, try the API
    try {
      final response = await http.get(
        Uri.parse('${Consts.baseUrl}/countries/$countryCode'),
      );

      if (response.statusCode == 200) {
        // Try to parse the response
        try {
          final String countryName = json.decode(response.body);
          if (countryName.isNotEmpty) {
            return countryName;
          }
        } catch (e) {
          // Handle JSON parse error
        }
      }
    } catch (e) {
      // Handle network or other errors
    }

    // If we reach here, either the API request failed or returned invalid data
    // Return the country code itself as a fallback
    return countryCode;
  }

  /// Synchronous version that uses only the local map
  static String convertCountryCodeToCountryNameSync(String countryCode) {
    return countryMap[countryCode] ?? countryCode;
  }
}
