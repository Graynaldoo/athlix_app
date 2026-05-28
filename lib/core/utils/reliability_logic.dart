class ReliabilityLogic {
  
  /// Base score for all new users
  static const double baseScore = 100.0;

  /// Penalti ketika tidak hadir di match (no-show)
  static const double penaltyNoShow = -15.0;

  /// Penalti ketika batal h-1 atau mendadak
  static const double penaltyLateCancel = -5.0;

  /// Reward ketika hadir dan menyelesaikan match
  static const double rewardAttendance = 2.0;

  /// Hitung skor baru berdasarkan event
  static double calculateNewScore(double currentScore, String eventType) {
    double change = 0.0;
    
    switch (eventType) {
      case 'no_show':
        change = penaltyNoShow;
        break;
      case 'late_cancel':
        change = penaltyLateCancel;
        break;
      case 'attended':
        change = rewardAttendance;
        break;
      default:
        change = 0.0;
    }

    double newScore = currentScore + change;
    
    // Clamp score between 0 and 100
    if (newScore > 100.0) newScore = 100.0;
    if (newScore < 0.0) newScore = 0.0;
    
    return newScore;
  }
}
