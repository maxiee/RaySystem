// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site_create.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$SiteCreate extends SiteCreate {
  @override
  final String name;
  @override
  final String? description;
  @override
  final String url;
  @override
  final String? favicon;
  @override
  final String? rss;

  factory _$SiteCreate([void Function(SiteCreateBuilder)? updates]) =>
      (new SiteCreateBuilder()..update(updates))._build();

  _$SiteCreate._(
      {required this.name,
      this.description,
      required this.url,
      this.favicon,
      this.rss})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'SiteCreate', 'name');
    BuiltValueNullFieldError.checkNotNull(url, r'SiteCreate', 'url');
  }

  @override
  SiteCreate rebuild(void Function(SiteCreateBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteCreateBuilder toBuilder() => new SiteCreateBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is SiteCreate &&
        name == other.name &&
        description == other.description &&
        url == other.url &&
        favicon == other.favicon &&
        rss == other.rss;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, favicon.hashCode);
    _$hash = $jc(_$hash, rss.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'SiteCreate')
          ..add('name', name)
          ..add('description', description)
          ..add('url', url)
          ..add('favicon', favicon)
          ..add('rss', rss))
        .toString();
  }
}

class SiteCreateBuilder implements Builder<SiteCreate, SiteCreateBuilder> {
  _$SiteCreate? _$v;

  String? _name;
  String? get name => _$this._name;
  set name(String? name) => _$this._name = name;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  String? _favicon;
  String? get favicon => _$this._favicon;
  set favicon(String? favicon) => _$this._favicon = favicon;

  String? _rss;
  String? get rss => _$this._rss;
  set rss(String? rss) => _$this._rss = rss;

  SiteCreateBuilder() {
    SiteCreate._defaults(this);
  }

  SiteCreateBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _url = $v.url;
      _favicon = $v.favicon;
      _rss = $v.rss;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(SiteCreate other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$SiteCreate;
  }

  @override
  void update(void Function(SiteCreateBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  SiteCreate build() => _build();

  _$SiteCreate _build() {
    final _$result = _$v ??
        new _$SiteCreate._(
          name: BuiltValueNullFieldError.checkNotNull(
              name, r'SiteCreate', 'name'),
          description: description,
          url: BuiltValueNullFieldError.checkNotNull(url, r'SiteCreate', 'url'),
          favicon: favicon,
          rss: rss,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
