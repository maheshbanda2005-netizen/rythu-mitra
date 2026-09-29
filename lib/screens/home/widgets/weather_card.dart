import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../services/agri_data_service.dart';
import '../../../services/app_state_service.dart';

class WeatherCard extends StatelessWidget {
  const WeatherCard({super.key});

  String _getDayName(String dayName, String lang) {
    if (lang == 'te') {
      switch (dayName) {
        case 'Today': return 'ఈరోజు';
        case 'Tomorrow': return 'రేపు';
        case 'Wed': return 'బుధ';
        case 'Thu': return 'గురు';
        case 'Fri': return 'శుక్ర';
        case 'Sat': return 'శని';
        case 'Sun': return 'ఆది';
        default: return dayName;
      }
    } else if (lang == 'hi') {
      switch (dayName) {
        case 'Today': return 'आज';
        case 'Tomorrow': return 'कल';
        case 'Wed': return 'बुध';
        case 'Thu': return 'गुरु';
        case 'Fri': return 'शुक्र';
        case 'Sat': return 'शनि';
        case 'Sun': return 'रवि';
        default: return dayName;
      }
    }
    return dayName;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final appState = context.watch<AppStateService>();
    final lang = appState.currentLanguage;
    final weather = AgriDataService.currentWeather;

    final locText = lang == 'te' ? 'వరంగల్, తెలంగాణ' : (lang == 'hi' ? 'वारंगल, तेलंगाना' : 'Warangal, Telangana');
    final condText = lang == 'te' ? 'పాక్షికంగా మేఘావృతం' : (lang == 'hi' ? 'आंशिक बादल' : 'Partly Cloudy');
    final rainSubText = lang == 'te'
        ? 'వర్షం: ${weather.rainProbability}% • గాలి: ${weather.windSpeedKmH} కి.మీ/గం'
        : (lang == 'hi'
            ? 'बारिश: ${weather.rainProbability}% • हवा: ${weather.windSpeedKmH} किमी/घंटा'
            : 'Rain: ${weather.rainProbability}% • Wind: ${weather.windSpeedKmH} km/h');

    return Container(
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(
                colors: [Color(0xFF0F324D), Color(0xFF163E5C)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : const LinearGradient(
                colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0284C7).withValues(alpha: 0.25),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.08),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: Location & Refresh/Alert tag
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.location_on_rounded, color: Colors.white, size: 18),
                        const SizedBox(width: 4),
                        Text(
                          locText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.radar_rounded, color: Colors.white, size: 12),
                          const SizedBox(width: 4),
                          Text(
                            lang == 'te' ? 'డాప్లర్ రాడార్' : (lang == 'hi' ? 'डॉप्लर रडार' : 'Live Doppler'),
                            style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Middle: Temp & Metrics
                Row(
                  children: [
                    Text(
                      '${weather.currentTemp}°C',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1.5,
                        height: 1,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          condText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          rainSubText,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.9),
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Icon(weather.icon, color: const Color(0xFFFDE047), size: 44),
                  ],
                ),
                const SizedBox(height: 16),
                // 3 Metrics Pills with Material Icons
                Row(
                  children: [
                    _buildMetricPill(
                      Icons.water_drop_rounded,
                      lang == 'te' ? 'తేమ' : (lang == 'hi' ? 'नमी' : 'Humidity'),
                      '${weather.humidity}%',
                    ),
                    const SizedBox(width: 8),
                    _buildMetricPill(
                      Icons.air_rounded,
                      lang == 'te' ? 'గాలి' : (lang == 'hi' ? 'हवा' : 'Wind'),
                      '${weather.windSpeedKmH} km/h',
                    ),
                    const SizedBox(width: 8),
                    _buildMetricPill(
                      Icons.grain_rounded,
                      lang == 'te' ? 'వర్షం' : (lang == 'hi' ? 'बारिश' : 'Rain'),
                      '${weather.rainProbability}%',
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                // Smart Farm Advisory Box
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.warning_amber_rounded, color: Color(0xFFFDE047), size: 20),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          context.tr('rainExpectedTomorrow'),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12.5,
                            fontWeight: FontWeight.w600,
                            height: 1.35,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),
                // 7-day mini forecast list with Material Icons
                SizedBox(
                  height: 72,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: weather.weeklyForecast.length,
                    separatorBuilder: (_, index) => const SizedBox(width: 10),
                    itemBuilder: (context, idx) {
                      final item = weather.weeklyForecast[idx];
                      return Container(
                        width: 62,
                        padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _getDayName(item.dayName, lang),
                              style: const TextStyle(color: Colors.white70, fontSize: 10, fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 3),
                            Icon(item.icon, color: const Color(0xFFFDE047), size: 18),
                            const SizedBox(height: 3),
                            Text(
                              '${item.tempMax}°',
                              style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricPill(IconData icon, String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 6),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.16),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(icon, color: Colors.white70, size: 12),
                const SizedBox(width: 3),
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.85),
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 13,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
