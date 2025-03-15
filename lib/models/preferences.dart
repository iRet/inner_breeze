class Preferences {
  bool notificationEnabled;
  String theme;
  int tempo;
  int breaths;
  bool breathsPrecise;
  int volume;
  bool screenAlwaysOn;
  int recoveryPause;

  Preferences({
    this.notificationEnabled = true,
    this.theme = 'dark',
    this.tempo = 1668,
    this.breaths = 30,
    this.breathsPrecise = false,
    this.volume = 100, 
    this.screenAlwaysOn = true,
    this.recoveryPause = 15,
  });

  Map<String, dynamic> toJson() {
    return {
      'notificationEnabled': notificationEnabled,
      'theme': theme,
      'tempo': tempo,
      'breaths': breaths,
      'breathsPrecise': breathsPrecise,
      'volume': volume,
      'screenAlwaysOn': screenAlwaysOn,
      'recoveryPause': recoveryPause,
    };
  }

  factory Preferences.fromJson(Map<String, dynamic> json) {
    return Preferences(
      notificationEnabled: json['notificationEnabled'] ?? true,
      theme: json['theme'] ?? 'dark',
      tempo: json['tempo'] ?? 1668,
      breaths: json['breaths'] ?? 30,
      breathsPrecise: json['breathsPrecise'] ?? false,
      volume: json['volume'] ?? 90,
      screenAlwaysOn: json['screenAlwaysOn'] ?? true,
      recoveryPause: json['recoveryPause'] ?? 15,
    );
  }
}
