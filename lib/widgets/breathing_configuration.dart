import 'package:flutter/material.dart';
import 'package:inner_breeze/providers/user_provider.dart';
import 'package:inner_breeze/widgets/animated_circle.dart';
import 'package:localization/localization.dart';
import 'package:provider/provider.dart';
import 'package:inner_breeze/models/preferences.dart';

class BreathingConfiguration extends StatefulWidget {
  @override
  BreathingConfigurationState createState() => BreathingConfigurationState();
}

class BreathingConfigurationState extends State<BreathingConfiguration> {
  int breaths = 30;
  int volume = 100;
  double secondsPerBreath = 1.668; // Default tempo in seconds
  String animationCommand = 'repeat';
  int recoveryPause = 15;
  bool breathsPrecise = false;

  @override
  void initState() {
    super.initState();
    _loadUserPreferences();
  }

  Future<void> _loadUserPreferences() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final prefs = await userProvider.loadUserPreferences([
      'breaths', 
      'breathsPrecise',
      'tempo', 
      'volume', 
      'recoveryPause',
    ]);

    setState(() {
      secondsPerBreath = prefs.tempo / 1000; // Convert milliseconds to seconds
      breaths = prefs.breaths;
      breathsPrecise = prefs.breathsPrecise;
      volume = prefs.volume;
      recoveryPause = prefs.recoveryPause;
    });
  }

  void _updateUser() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    final preferences = Preferences(
      tempo: (secondsPerBreath * 1000).round(), // Convert seconds to milliseconds
      breaths: breaths,
      breathsPrecise: breathsPrecise,
      volume: volume,
      recoveryPause: recoveryPause,
    );
    userProvider.saveUserPreferences(preferences);
  }

  void _updateTempo(double newTempo) {
    setState(() {
      secondsPerBreath = newTempo;
      animationCommand = 'reset';
    });
    _updateUser();
  }

  void _updateVolume(double newVolume) {
    setState(() {
      volume = newVolume.toInt();
      animationCommand = 'repeat';
    });
    _updateUser();
  }

  void _updateBreaths(double newBreaths) {
    setState(() {
      breaths = newBreaths.toInt();
      animationCommand = 'repeat';
    });
    _updateUser();
  }

  void _updateBreathsPrecise() {
    setState(() {
      breathsPrecise = !breathsPrecise;
      animationCommand = 'repeat';
    });
    _updateUser();
  }

  void _updateRecoveryPause(double newPause) {
    setState(() {
      recoveryPause = newPause.toInt();
      animationCommand = 'repeat';
    });
    _updateUser();
  }

  String _getTempoLabel(double seconds) {
    if (seconds < 1) return 'tempo_very_fast'.i18n();
    if (seconds < 1.5) return 'tempo_fast'.i18n();
    if (seconds < 2) return 'tempo_medium'.i18n();
    return 'tempo_slow'.i18n();
  }

  String _getVolumeLabel(double volume) {
    String label = volume.round().toString();
    if (volume == 0) {
      label += ' (no sound)';
    }
    return label;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 90),
        Center(
          child: AnimatedCircle(
            tempoDuration: Duration(milliseconds: (secondsPerBreath * 1000).round()),
            volume: volume,
            controlCallback: () {
              return animationCommand;
            },
          ),
        ),
        SizedBox(height: 90),
        Text(
          'breathing_tempo_label'.i18n(),
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          min: 0.5,
          max: 3.0,
          divisions: 25,
          value: secondsPerBreath,
          label: '${secondsPerBreath.toStringAsFixed(1)}s (${_getTempoLabel(secondsPerBreath)})',
          onChanged: (value) {
            _updateTempo(value);
          },
        ),
        SizedBox(height: 10),
        Text(
          'volume_label'.i18n(),
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          min: 0.0,
          max: 100.0,
          label: _getVolumeLabel(volume.toDouble()),
          divisions: 10,
          value: volume.toDouble(),
          onChanged: (dynamic value) {
            _updateVolume(value);
          },
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'breaths_label'.i18n(),
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(width: 10),
                  IconButton(
                    icon: Icon(
                      breathsPrecise 
                          ? Icons.precision_manufacturing 
                          : Icons.precision_manufacturing_outlined,
                      size: 20,
                      color: breathsPrecise 
                          ? Theme.of(context).colorScheme.primary
                          : null,
                    ),
                    onPressed: () {
                      _updateBreathsPrecise();
                    },
                    tooltip: 'Precise control',
                  ),
                ],
              ),
              Slider(
                min: 20.0,
                max: 40.0,
                label: '${breaths.round()}',
                divisions: breathsPrecise ? 20 : 4,
                value: breaths.toDouble(),
                onChanged: (dynamic value) {
                  _updateBreaths(value);
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Text(
          'recovery_pause_label'.i18n(),
          style: TextStyle(
            fontSize: 22.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        Slider(
          min: 10.0,
          max: 25.0,
          label: '${recoveryPause}s',
          divisions: 15,
          value: recoveryPause.toDouble(),
          onChanged: (value) {
            _updateRecoveryPause(value);
          },
        ),
      ],
    );
  }
}
