// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'site.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$Site extends Site {
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
  @override
  final int id;

  factory _$Site([void Function(SiteBuilder)? updates]) =>
      (new SiteBuilder()..update(updates))._build();

  _$Site._(
      {required this.name,
      this.description,
      required this.host,
      this.favicon,
      this.rss,
      required this.id})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(name, r'Site', 'name');
    BuiltValueNullFieldError.checkNotNull(host, r'Site', 'host');
    BuiltValueNullFieldError.checkNotNull(id, r'Site', 'id');
  }

  @override
  Site rebuild(void Function(SiteBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  SiteBuilder toBuilder() => new SiteBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Site &&
        name == other.name &&
        description == other.description &&
        host == other.host &&
        favicon == other.favicon &&
        rss == other.rss &&
        id == other.id;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, name.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, host.hashCode);
    _$hash = $jc(_$hash, favicon.hashCode);
    _$hash = $jc(_$hash, rss.hashCode);
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'Site')
          ..add('name', name)
          ..add('description', description)
          ..add('host', host)
          ..add('favicon', favicon)
          ..add('rss', rss)
          ..add('id', id))
        .toString();
  }
}

class SiteBuilder implements Builder<Site, SiteBuilder> {
  _$Site? _$v;

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

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  SiteBuilder() {
    Site._defaults(this);
  }

  SiteBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _name = $v.name;
      _description = $v.description;
      _host = $v.host;
      _favicon = $v.favicon;
      _rss = $v.rss;
      _id = $v.id;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Site other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$Site;
  }

  @override
  void update(void Function(SiteBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  Site build() => _build();

  _$Site _build() {
    final _$result = _$v ??
        new _$Site._(
          name: BuiltValueNullFieldError.checkNotNull(name, r'Site', 'name'),
          description: description,
          host: BuiltValueNullFieldError.checkNotNull(host, r'Site', 'host'),
          favicon: favicon,
          rss: rss,
          id: BuiltValueNullFieldError.checkNotNull(id, r'Site', 'id'),
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
