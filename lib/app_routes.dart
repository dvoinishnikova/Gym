enum AppRoute {
  home('/home'),
  profile('/profile'),
  settings('/settings'),
  product('/product'),
  login('/login'),
  registration('/registration'),
  survey('/survey'),
  surveyComplete('/survey_complete');

  final String path;
  const AppRoute(this.path);
}