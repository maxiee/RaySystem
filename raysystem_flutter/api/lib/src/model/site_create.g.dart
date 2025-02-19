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
  final String host;
  @override
  final String? favicon;
  @override
  final String? rss;

  factory _$SiteCreate([void Function(SiteCreateBuilder)? updates]) =>
      (new SiteCreateBuilder()..update(updates))._build();

  _$SiteCreate._(
      {required this.name,
      this.description,
      required this.host,
      this.favicon,
      this.rss})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'SiteCreate', 'name');
    BuiltValueNullFieldError.checkNotNull(host, r'SiteCreate', 'host');
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
        host == other.host &&
        favicon == other.favicon &&
        rss == other.rss;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, host.hashCode);
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
          ..add('host', host)
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

  String? _host;
  String? get host => _$this._host;
  set host(String? host) => _$this._host = host;

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
      _host = $v.host;
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
          host: BuiltValueNullFieldError.checkNotNull(
              host, r'SiteCreate', 'host'),
          favicon: favicon,
          rss: rss,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
