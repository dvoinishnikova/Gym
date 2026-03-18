enum AppRoute {
  home('/home'),
  profile('/profile'),
  settings('/settings'),
  product('/product');

  final String path;
  const AppRoute(this.path);
}