class WebModel{
  String _appBarName;
  String _webUrl;

  WebModel(this._appBarName, this._webUrl);

  String get webUrl => _webUrl;

  String get appBarName => _appBarName;
}