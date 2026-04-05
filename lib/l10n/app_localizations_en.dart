import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appName => 'BestOneGolf';

  @override
  String get settings => 'Settings';

  @override
  String get language => 'Language';

  @override
  String get currency => 'Currency';

  @override
  String get theme => 'Theme';

  @override
  String get systemTheme => 'System';

  @override
  String get lightTheme => 'Light';

  @override
  String get darkTheme => 'Dark';

  @override
  String get english => 'English';

  @override
  String get thai => 'Thai';

  @override
  String get usd => 'USD';

  @override
  String get thb => 'THB';

  @override
  String get newGame => 'New Game';

  @override
  String get recentGames => 'Recent Games';

  @override
  String get noGamesYet => 'No games yet';

  @override
  String get startYourFirstGame => 'Start your first BestOneGolf game';

  @override
  String get createGameComingSoon => 'Create Game coming soon';

  @override
  String get history => 'History';

  @override
  String get ongoing => 'Ongoing';

  @override
  String get completed => 'Completed';

  @override
  String get view => 'View';

  @override
  String get continueGame => 'Continue';

  @override
  String get restart => 'Restart';

  @override
  String get delete => 'Delete';

  @override
  String get cancel => 'Cancel';

  @override
  String get finish => 'Finish';

  @override
  String get score => 'Score';

  @override
  String get par => 'Par';

  @override
  String get mode => 'Mode';

  @override
  String get individual => 'Individual';

  @override
  String get team => 'Team';

  @override
  String get teams => 'Teams';

  @override
  String get players => 'Players';

  @override
  String get rules => 'Rules';

  @override
  String get bestOne => 'Best One';

  @override
  String get bestTwo => 'Best Two';

  @override
  String get holes => 'Holes';

  @override
  String get summary => 'Summary';

  @override
  String get detail => 'Detail';

  @override
  String get split => 'Split';

  @override
  String get gross => 'Gross';

  @override
  String get gameTitle => 'Game Title';

  @override
  String get addPlayer => 'Add Player';

  @override
  String get addTeam => 'Add Team';

  @override
  String get startGame => 'Start Game';

  @override
  String get holeSetup => 'Hole Setup';

  @override
  String get setTurbo9And18 => 'Set Turbo 9 & 18';

  @override
  String get setBirdie9And18 => 'Set Birdie 9 & 18';

  @override
  String get turboX2 => 'Turbo x2';

  @override
  String get birdieBonusX2 => 'Birdie Bonus x2';

  @override
  String get useSameAmountForAllRules => 'Use same amount for all rules';

  @override
  String get useDifferentAmountForEachRule => 'Use different amount for each rule';

  @override
  String get amount => 'Amount';

  @override
  String get bestOneAmount => 'Best One Amount';

  @override
  String get bestTwoAmount => 'Best Two Amount';

  @override
  String get bestTwoAmountOptional => 'Best Two Amount (optional)';

  @override
  String get scoreEntry => 'Score Entry';

  @override
  String get holeResult => 'Hole Result';

  @override
  String get gameSummary => 'Game Summary';

  @override
  String get prev => 'Prev';

  @override
  String get next => 'Next';

  @override
  String get finishGame => 'Finish Game';

  @override
  String get teamAssigned => 'Team assigned';

  @override
  String get complete => 'Complete';

  @override
  String get incomplete => 'Incomplete';

  @override
  String get turboOn => 'Turbo: ON';

  @override
  String get turboOff => 'Turbo: OFF';

  @override
  String get birdieOn => 'Birdie Bonus: ON';

  @override
  String get birdieOff => 'Birdie Bonus: OFF';

  @override
  String get turboOnShort => 'Turbo ON';

  @override
  String get turboOffShort => 'Turbo OFF';

  @override
  String get birdieOnShort => 'Birdie ON';

  @override
  String get birdieOffShort => 'Birdie OFF';

  @override
  String get playerNet => 'Player Net';

  @override
  String get teamNet => 'Team Net';

  @override
  String get playerMovements => 'Player Movements';

  @override
  String get teamMovements => 'Team Movements';

  @override
  String get totalsByPlayer => 'Totals by Player';

  @override
  String get settlements => 'Settlements';

  @override
  String get noResultAvailable => 'No result available yet.';

  @override
  String get noPlayerNetResult => 'No player net result.';

  @override
  String get noTeamNetResult => 'No team net result.';

  @override
  String get noPlayerMovements => 'No player movements.';

  @override
  String get noTeamMovements => 'No team movements.';

  @override
  String get noResultYet => 'No result yet.';

  @override
  String get noOngoingGames => 'No ongoing games';

  @override
  String get noCompletedGames => 'No completed games';

  @override
  String get noTotalsYet => 'No totals yet.';

  @override
  String get noSettlementsYet => 'No settlements yet.';

  @override
  String get noSummaryAvailable => 'No summary available yet.';

  @override
  String get deleteGame => 'Delete Game';

  @override
  String get deleteGameConfirmation => 'Do you want to delete this game permanently?';

  @override
  String get restartGame => 'Restart Game';

  @override
  String get restartGameConfirmation => 'Do you want to create a new game using the same settings?';

  @override
  String get duplicateGame => 'Duplicate Game';

  @override
  String get duplicateGameConfirmation => 'Do you want to create a copy of this game with the same settings?';

  @override
  String get duplicate => 'Duplicate';

  @override
  String get finishGameConfirmation => 'Do you want to mark this game as completed and go to the summary?';

  @override
  String playerN(int n) {
    return 'Player $n';
  }

  @override
  String teamN(int n) {
    return 'Team $n';
  }

  @override
  String holeN(int n) {
    return 'Hole $n';
  }

  @override
  String holeNResult(int n) {
    return 'Hole $n Result';
  }

  @override
  String holeProgress(int current, int total) {
    return 'Hole $current / $total';
  }

  @override
  String gameInfo(String mode, int totalHoles) {
    return '$mode • $totalHoles holes';
  }

  @override
  String baseAmount(String amount) {
    return 'Base Amount: $amount';
  }

  @override
  String baseWithAmount(String amount) {
    return 'Base $amount';
  }

  @override
  String pays(String from, String to) {
    return '$from pays $to';
  }

  @override
  String failedToLoadSettings(Object error) {
    return 'Failed to load settings: $error';
  }

  @override
  String failedToLoadOngoingGames(Object error) {
    return 'Failed to load ongoing games: $error';
  }

  @override
  String failedToLoadCompletedGames(Object error) {
    return 'Failed to load completed games: $error';
  }

  @override
  String failedToLoadHoleResult(Object error) {
    return 'Failed to load hole result: $error';
  }

  @override
  String failedToLoadAppSettings(Object error) {
    return 'Failed to load app settings: $error';
  }

  @override
  String failedToLoadGame(Object error) {
    return 'Failed to load game: $error';
  }

  @override
  String failedToLoadGameSummary(Object error) {
    return 'Failed to load game summary: $error';
  }

  @override
  String failedToLoadGameData(Object error) {
    return 'Failed to load game data: $error';
  }

  @override
  String get removeAds => 'Remove Ads';

  @override
  String get removeAdsPurchased => 'Ads Removed';

  @override
  String get removeAdsDescription => 'Enjoy an ad-free experience with a one-time purchase.';

  @override
  String get removeAdsPurchasedDescription => 'Thank you! You are enjoying an ad-free experience.';

  @override
  String get purchase => 'Purchase';

  @override
  String get restorePurchases => 'Restore Purchases';

  @override
  String get storeNotAvailable => 'Store not available';

  @override
  String get adNotAvailable => 'Ad could not be loaded';

  @override
  String adContinuingIn(int seconds) {
    return 'Continuing in ${seconds}s...';
  }

  @override
  String get loadMore => 'Load More';

  @override
  String get legal => 'Legal';

  @override
  String get termsAndConditions => 'Terms & Conditions';

  @override
  String get privacyPolicy => 'Privacy Policy';
}
