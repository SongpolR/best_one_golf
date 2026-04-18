import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_th.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('th')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'BestOneGolf'**
  String get appName;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @currency.
  ///
  /// In en, this message translates to:
  /// **'Currency'**
  String get currency;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @thai.
  ///
  /// In en, this message translates to:
  /// **'Thai'**
  String get thai;

  /// No description provided for @usd.
  ///
  /// In en, this message translates to:
  /// **'USD'**
  String get usd;

  /// No description provided for @thb.
  ///
  /// In en, this message translates to:
  /// **'THB'**
  String get thb;

  /// No description provided for @newGame.
  ///
  /// In en, this message translates to:
  /// **'New Game'**
  String get newGame;

  /// No description provided for @recentGames.
  ///
  /// In en, this message translates to:
  /// **'Recent Games'**
  String get recentGames;

  /// No description provided for @noGamesYet.
  ///
  /// In en, this message translates to:
  /// **'No games yet'**
  String get noGamesYet;

  /// No description provided for @startYourFirstGame.
  ///
  /// In en, this message translates to:
  /// **'Start your first BestOneGolf game'**
  String get startYourFirstGame;

  /// No description provided for @createGameComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Create Game coming soon'**
  String get createGameComingSoon;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @ongoing.
  ///
  /// In en, this message translates to:
  /// **'Ongoing'**
  String get ongoing;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @view.
  ///
  /// In en, this message translates to:
  /// **'View'**
  String get view;

  /// No description provided for @continueGame.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueGame;

  /// No description provided for @restart.
  ///
  /// In en, this message translates to:
  /// **'Restart'**
  String get restart;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @finish.
  ///
  /// In en, this message translates to:
  /// **'Finish'**
  String get finish;

  /// No description provided for @score.
  ///
  /// In en, this message translates to:
  /// **'Score'**
  String get score;

  /// No description provided for @par.
  ///
  /// In en, this message translates to:
  /// **'Par'**
  String get par;

  /// No description provided for @mode.
  ///
  /// In en, this message translates to:
  /// **'Mode'**
  String get mode;

  /// No description provided for @individual.
  ///
  /// In en, this message translates to:
  /// **'Individual'**
  String get individual;

  /// No description provided for @team.
  ///
  /// In en, this message translates to:
  /// **'Team'**
  String get team;

  /// No description provided for @teams.
  ///
  /// In en, this message translates to:
  /// **'Teams'**
  String get teams;

  /// No description provided for @players.
  ///
  /// In en, this message translates to:
  /// **'Players'**
  String get players;

  /// No description provided for @rules.
  ///
  /// In en, this message translates to:
  /// **'Rules'**
  String get rules;

  /// No description provided for @bestOne.
  ///
  /// In en, this message translates to:
  /// **'Best One'**
  String get bestOne;

  /// No description provided for @bestTwo.
  ///
  /// In en, this message translates to:
  /// **'Best Two'**
  String get bestTwo;

  /// No description provided for @holes.
  ///
  /// In en, this message translates to:
  /// **'Holes'**
  String get holes;

  /// No description provided for @scorecard.
  ///
  /// In en, this message translates to:
  /// **'Scorecard'**
  String get scorecard;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @detail.
  ///
  /// In en, this message translates to:
  /// **'Detail'**
  String get detail;

  /// No description provided for @split.
  ///
  /// In en, this message translates to:
  /// **'Split'**
  String get split;

  /// No description provided for @gross.
  ///
  /// In en, this message translates to:
  /// **'Gross'**
  String get gross;

  /// No description provided for @gameTitle.
  ///
  /// In en, this message translates to:
  /// **'Game Title'**
  String get gameTitle;

  /// No description provided for @addPlayer.
  ///
  /// In en, this message translates to:
  /// **'Add Player'**
  String get addPlayer;

  /// No description provided for @addTeam.
  ///
  /// In en, this message translates to:
  /// **'Add Team'**
  String get addTeam;

  /// No description provided for @startGame.
  ///
  /// In en, this message translates to:
  /// **'Start Game'**
  String get startGame;

  /// No description provided for @golfCourse.
  ///
  /// In en, this message translates to:
  /// **'Golf Course'**
  String get golfCourse;

  /// No description provided for @selectGolfCourse.
  ///
  /// In en, this message translates to:
  /// **'Select a golf course'**
  String get selectGolfCourse;

  /// No description provided for @holeSetup.
  ///
  /// In en, this message translates to:
  /// **'Hole Setup'**
  String get holeSetup;

  /// No description provided for @setTurbo9And18.
  ///
  /// In en, this message translates to:
  /// **'Set Turbo 9 & 18'**
  String get setTurbo9And18;

  /// No description provided for @setBirdie9And18.
  ///
  /// In en, this message translates to:
  /// **'Set Birdie 9 & 18'**
  String get setBirdie9And18;

  /// No description provided for @turboX2.
  ///
  /// In en, this message translates to:
  /// **'Turbo x2'**
  String get turboX2;

  /// No description provided for @birdieBonusX2.
  ///
  /// In en, this message translates to:
  /// **'Birdie Bonus x2'**
  String get birdieBonusX2;

  /// No description provided for @useSameAmountForAllRules.
  ///
  /// In en, this message translates to:
  /// **'Use same amount for all rules'**
  String get useSameAmountForAllRules;

  /// No description provided for @useDifferentAmountForEachRule.
  ///
  /// In en, this message translates to:
  /// **'Use different amount for each rule'**
  String get useDifferentAmountForEachRule;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @bestOneAmount.
  ///
  /// In en, this message translates to:
  /// **'Best One Amount'**
  String get bestOneAmount;

  /// No description provided for @bestTwoAmount.
  ///
  /// In en, this message translates to:
  /// **'Best Two Amount'**
  String get bestTwoAmount;

  /// No description provided for @bestTwoAmountOptional.
  ///
  /// In en, this message translates to:
  /// **'Best Two Amount (optional)'**
  String get bestTwoAmountOptional;

  /// No description provided for @scoreEntry.
  ///
  /// In en, this message translates to:
  /// **'Score Entry'**
  String get scoreEntry;

  /// No description provided for @holeResult.
  ///
  /// In en, this message translates to:
  /// **'Hole Result'**
  String get holeResult;

  /// No description provided for @gameSummary.
  ///
  /// In en, this message translates to:
  /// **'Game Summary'**
  String get gameSummary;

  /// No description provided for @prev.
  ///
  /// In en, this message translates to:
  /// **'Prev'**
  String get prev;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @finishGame.
  ///
  /// In en, this message translates to:
  /// **'Finish Game'**
  String get finishGame;

  /// No description provided for @teamAssigned.
  ///
  /// In en, this message translates to:
  /// **'Team assigned'**
  String get teamAssigned;

  /// No description provided for @complete.
  ///
  /// In en, this message translates to:
  /// **'Complete'**
  String get complete;

  /// No description provided for @incomplete.
  ///
  /// In en, this message translates to:
  /// **'Incomplete'**
  String get incomplete;

  /// No description provided for @turboOn.
  ///
  /// In en, this message translates to:
  /// **'Turbo: ON'**
  String get turboOn;

  /// No description provided for @turboOff.
  ///
  /// In en, this message translates to:
  /// **'Turbo: OFF'**
  String get turboOff;

  /// No description provided for @birdieOn.
  ///
  /// In en, this message translates to:
  /// **'Birdie Bonus: ON'**
  String get birdieOn;

  /// No description provided for @birdieOff.
  ///
  /// In en, this message translates to:
  /// **'Birdie Bonus: OFF'**
  String get birdieOff;

  /// No description provided for @turboOnShort.
  ///
  /// In en, this message translates to:
  /// **'Turbo ON'**
  String get turboOnShort;

  /// No description provided for @turboOffShort.
  ///
  /// In en, this message translates to:
  /// **'Turbo OFF'**
  String get turboOffShort;

  /// No description provided for @birdieOnShort.
  ///
  /// In en, this message translates to:
  /// **'Birdie ON'**
  String get birdieOnShort;

  /// No description provided for @birdieOffShort.
  ///
  /// In en, this message translates to:
  /// **'Birdie OFF'**
  String get birdieOffShort;

  /// No description provided for @playerNet.
  ///
  /// In en, this message translates to:
  /// **'Player Net'**
  String get playerNet;

  /// No description provided for @teamNet.
  ///
  /// In en, this message translates to:
  /// **'Team Net'**
  String get teamNet;

  /// No description provided for @playerMovements.
  ///
  /// In en, this message translates to:
  /// **'Player Movements'**
  String get playerMovements;

  /// No description provided for @teamMovements.
  ///
  /// In en, this message translates to:
  /// **'Team Movements'**
  String get teamMovements;

  /// No description provided for @totalsByPlayer.
  ///
  /// In en, this message translates to:
  /// **'Totals by Player'**
  String get totalsByPlayer;

  /// No description provided for @settlements.
  ///
  /// In en, this message translates to:
  /// **'Settlements'**
  String get settlements;

  /// No description provided for @noResultAvailable.
  ///
  /// In en, this message translates to:
  /// **'No result available yet.'**
  String get noResultAvailable;

  /// No description provided for @noPlayerNetResult.
  ///
  /// In en, this message translates to:
  /// **'No player net result.'**
  String get noPlayerNetResult;

  /// No description provided for @noTeamNetResult.
  ///
  /// In en, this message translates to:
  /// **'No team net result.'**
  String get noTeamNetResult;

  /// No description provided for @noPlayerMovements.
  ///
  /// In en, this message translates to:
  /// **'No player movements.'**
  String get noPlayerMovements;

  /// No description provided for @noTeamMovements.
  ///
  /// In en, this message translates to:
  /// **'No team movements.'**
  String get noTeamMovements;

  /// No description provided for @noResultYet.
  ///
  /// In en, this message translates to:
  /// **'No result yet.'**
  String get noResultYet;

  /// No description provided for @noOngoingGames.
  ///
  /// In en, this message translates to:
  /// **'No ongoing games'**
  String get noOngoingGames;

  /// No description provided for @noCompletedGames.
  ///
  /// In en, this message translates to:
  /// **'No completed games'**
  String get noCompletedGames;

  /// No description provided for @noTotalsYet.
  ///
  /// In en, this message translates to:
  /// **'No totals yet.'**
  String get noTotalsYet;

  /// No description provided for @noSettlementsYet.
  ///
  /// In en, this message translates to:
  /// **'No settlements yet.'**
  String get noSettlementsYet;

  /// No description provided for @noSummaryAvailable.
  ///
  /// In en, this message translates to:
  /// **'No summary available yet.'**
  String get noSummaryAvailable;

  /// No description provided for @deleteGame.
  ///
  /// In en, this message translates to:
  /// **'Delete Game'**
  String get deleteGame;

  /// No description provided for @deleteGameConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to delete this game permanently?'**
  String get deleteGameConfirmation;

  /// No description provided for @restartGame.
  ///
  /// In en, this message translates to:
  /// **'Restart Game'**
  String get restartGame;

  /// No description provided for @restartGameConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to create a new game using the same settings?'**
  String get restartGameConfirmation;

  /// No description provided for @resetToDefault.
  ///
  /// In en, this message translates to:
  /// **'Reset to Default'**
  String get resetToDefault;

  /// No description provided for @resetToDefaultConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to reset all game settings to their default values?'**
  String get resetToDefaultConfirmation;

  /// No description provided for @reset.
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// No description provided for @duplicateGame.
  ///
  /// In en, this message translates to:
  /// **'Duplicate Game'**
  String get duplicateGame;

  /// No description provided for @duplicateGameConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to create a copy of this game with the same settings?'**
  String get duplicateGameConfirmation;

  /// No description provided for @duplicate.
  ///
  /// In en, this message translates to:
  /// **'Duplicate'**
  String get duplicate;

  /// No description provided for @finishGameConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Do you want to mark this game as completed and go to the summary?'**
  String get finishGameConfirmation;

  /// No description provided for @playerN.
  ///
  /// In en, this message translates to:
  /// **'Player {n}'**
  String playerN(int n);

  /// No description provided for @teamN.
  ///
  /// In en, this message translates to:
  /// **'Team {n}'**
  String teamN(int n);

  /// No description provided for @holeN.
  ///
  /// In en, this message translates to:
  /// **'Hole {n}'**
  String holeN(int n);

  /// No description provided for @holeNResult.
  ///
  /// In en, this message translates to:
  /// **'Hole {n} Result'**
  String holeNResult(int n);

  /// No description provided for @holeProgress.
  ///
  /// In en, this message translates to:
  /// **'Hole {current} / {total}'**
  String holeProgress(int current, int total);

  /// No description provided for @gameInfo.
  ///
  /// In en, this message translates to:
  /// **'{mode} • {totalHoles} holes'**
  String gameInfo(String mode, int totalHoles);

  /// No description provided for @baseAmount.
  ///
  /// In en, this message translates to:
  /// **'Base Amount: {amount}'**
  String baseAmount(String amount);

  /// No description provided for @baseWithAmount.
  ///
  /// In en, this message translates to:
  /// **'Base {amount}'**
  String baseWithAmount(String amount);

  /// No description provided for @pays.
  ///
  /// In en, this message translates to:
  /// **'{from} pays {to}'**
  String pays(String from, String to);

  /// No description provided for @failedToLoadSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load settings: {error}'**
  String failedToLoadSettings(Object error);

  /// No description provided for @failedToLoadOngoingGames.
  ///
  /// In en, this message translates to:
  /// **'Failed to load ongoing games: {error}'**
  String failedToLoadOngoingGames(Object error);

  /// No description provided for @failedToLoadCompletedGames.
  ///
  /// In en, this message translates to:
  /// **'Failed to load completed games: {error}'**
  String failedToLoadCompletedGames(Object error);

  /// No description provided for @failedToLoadHoleResult.
  ///
  /// In en, this message translates to:
  /// **'Failed to load hole result: {error}'**
  String failedToLoadHoleResult(Object error);

  /// No description provided for @failedToLoadAppSettings.
  ///
  /// In en, this message translates to:
  /// **'Failed to load app settings: {error}'**
  String failedToLoadAppSettings(Object error);

  /// No description provided for @failedToLoadGame.
  ///
  /// In en, this message translates to:
  /// **'Failed to load game: {error}'**
  String failedToLoadGame(Object error);

  /// No description provided for @failedToLoadGameSummary.
  ///
  /// In en, this message translates to:
  /// **'Failed to load game summary: {error}'**
  String failedToLoadGameSummary(Object error);

  /// No description provided for @failedToLoadGameData.
  ///
  /// In en, this message translates to:
  /// **'Failed to load game data: {error}'**
  String failedToLoadGameData(Object error);

  /// No description provided for @removeAds.
  ///
  /// In en, this message translates to:
  /// **'Remove Ads'**
  String get removeAds;

  /// No description provided for @removeAdsPurchased.
  ///
  /// In en, this message translates to:
  /// **'Ads Removed'**
  String get removeAdsPurchased;

  /// No description provided for @removeAdsDescription.
  ///
  /// In en, this message translates to:
  /// **'Enjoy an ad-free experience with a one-time purchase of \$0.99.'**
  String get removeAdsDescription;

  /// No description provided for @removeAdsPurchasedDescription.
  ///
  /// In en, this message translates to:
  /// **'Thank you! You are enjoying an ad-free experience.'**
  String get removeAdsPurchasedDescription;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @restorePurchases.
  ///
  /// In en, this message translates to:
  /// **'Restore Purchases'**
  String get restorePurchases;

  /// No description provided for @storeNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Store not available'**
  String get storeNotAvailable;

  /// No description provided for @adNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'Ad could not be loaded'**
  String get adNotAvailable;

  /// No description provided for @adContinuingIn.
  ///
  /// In en, this message translates to:
  /// **'Continuing in {seconds}s...'**
  String adContinuingIn(int seconds);

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Version {version}'**
  String appVersion(String version);

  /// No description provided for @loadMore.
  ///
  /// In en, this message translates to:
  /// **'Load More'**
  String get loadMore;

  /// No description provided for @legal.
  ///
  /// In en, this message translates to:
  /// **'Legal'**
  String get legal;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'th'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'th':
      return AppLocalizationsTh();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
