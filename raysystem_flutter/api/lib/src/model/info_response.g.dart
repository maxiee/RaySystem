// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'info_response.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

class _$InfoResponse extends InfoResponse {
  @override
  final int id;
  @override
  final String title;
  @override
  final String url;
  @override
  final DateTime? published;
  @override
  final DateTime createdAt;
  @override
  final String? description;
  @override
  final String? image;
  @override
  final bool isNew;
  @override
  final bool isMark;
  @override
  final int siteId;
  @override
  final int? channelId;
  @override
  final int? subchannelId;
  @override
  final String? storageHtml;

  factory _$InfoResponse([void Function(InfoResponseBuilder)? updates]) =>
      (new InfoResponseBuilder()..update(updates))._build();

  _$InfoResponse._(
      {required this.id,
      required this.title,
      required this.url,
      this.published,
      required this.createdAt,
      this.description,
      this.image,
      required this.isNew,
      required this.isMark,
      required this.siteId,
      this.channelId,
      this.subchannelId,
      this.storageHtml})
      : super._() {
    BuiltValueNullFieldError.checkNotNull(id, r'InfoResponse', 'id');
    BuiltValueNullFieldError.checkNotNull(title, r'InfoResponse', 'title');
    BuiltValueNullFieldError.checkNotNull(url, r'InfoResponse', 'url');
    BuiltValueNullFieldError.checkNotNull(
        createdAt, r'InfoResponse', 'createdAt');
    BuiltValueNullFieldError.checkNotNull(isNew, r'InfoResponse', 'isNew');
    BuiltValueNullFieldError.checkNotNull(isMark, r'InfoResponse', 'isMark');
    BuiltValueNullFieldError.checkNotNull(siteId, r'InfoResponse', 'siteId');
  }

  @override
  InfoResponse rebuild(void Function(InfoResponseBuilder) updates) =>
      (toBuilder()..update(updates)).build();

  @override
  InfoResponseBuilder toBuilder() => new InfoResponseBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is InfoResponse &&
        id == other.id &&
        title == other.title &&
        url == other.url &&
        published == other.published &&
        createdAt == other.createdAt &&
        description == other.description &&
        image == other.image &&
        isNew == other.isNew &&
        isMark == other.isMark &&
        siteId == other.siteId &&
        channelId == other.channelId &&
        subchannelId == other.subchannelId &&
        storageHtml == other.storageHtml;
  }

  @override
  int get hashCode {
    var _$hash = 0;
    _$hash = $jc(_$hash, id.hashCode);
    _$hash = $jc(_$hash, title.hashCode);
    _$hash = $jc(_$hash, url.hashCode);
    _$hash = $jc(_$hash, published.hashCode);
    _$hash = $jc(_$hash, createdAt.hashCode);
    _$hash = $jc(_$hash, description.hashCode);
    _$hash = $jc(_$hash, image.hashCode);
    _$hash = $jc(_$hash, isNew.hashCode);
    _$hash = $jc(_$hash, isMark.hashCode);
    _$hash = $jc(_$hash, siteId.hashCode);
    _$hash = $jc(_$hash, channelId.hashCode);
    _$hash = $jc(_$hash, subchannelId.hashCode);
    _$hash = $jc(_$hash, storageHtml.hashCode);
    _$hash = $jf(_$hash);
    return _$hash;
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper(r'InfoResponse')
          ..add('id', id)
          ..add('title', title)
          ..add('url', url)
          ..add('published', published)
          ..add('createdAt', createdAt)
          ..add('description', description)
          ..add('image', image)
          ..add('isNew', isNew)
          ..add('isMark', isMark)
          ..add('siteId', siteId)
          ..add('channelId', channelId)
          ..add('subchannelId', subchannelId)
          ..add('storageHtml', storageHtml))
        .toString();
  }
}

class InfoResponseBuilder
    implements Builder<InfoResponse, InfoResponseBuilder> {
  _$InfoResponse? _$v;

  int? _id;
  int? get id => _$this._id;
  set id(int? id) => _$this._id = id;

  String? _title;
  String? get title => _$this._title;
  set title(String? title) => _$this._title = title;

  String? _url;
  String? get url => _$this._url;
  set url(String? url) => _$this._url = url;

  DateTime? _published;
  DateTime? get published => _$this._published;
  set published(DateTime? published) => _$this._published = published;

  DateTime? _createdAt;
  DateTime? get createdAt => _$this._createdAt;
  set createdAt(DateTime? createdAt) => _$this._createdAt = createdAt;

  String? _description;
  String? get description => _$this._description;
  set description(String? description) => _$this._description = description;

  String? _image;
  String? get image => _$this._image;
  set image(String? image) => _$this._image = image;

  bool? _isNew;
  bool? get isNew => _$this._isNew;
  set isNew(bool? isNew) => _$this._isNew = isNew;

  bool? _isMark;
  bool? get isMark => _$this._isMark;
  set isMark(bool? isMark) => _$this._isMark = isMark;

  int? _siteId;
  int? get siteId => _$this._siteId;
  set siteId(int? siteId) => _$this._siteId = siteId;

  int? _channelId;
  int? get channelId => _$this._channelId;
  set channelId(int? channelId) => _$this._channelId = channelId;

  int? _subchannelId;
  int? get subchannelId => _$this._subchannelId;
  set subchannelId(int? subchannelId) => _$this._subchannelId = subchannelId;

  String? _storageHtml;
  String? get storageHtml => _$this._storageHtml;
  set storageHtml(String? storageHtml) => _$this._storageHtml = storageHtml;

  InfoResponseBuilder() {
    InfoResponse._defaults(this);
  }

  InfoResponseBuilder get _$this {
    final $v = _$v;
    if ($v != null) {
      _id = $v.id;
      _title = $v.title;
      _url = $v.url;
      _published = $v.published;
      _createdAt = $v.createdAt;
      _description = $v.description;
      _image = $v.image;
      _isNew = $v.isNew;
      _isMark = $v.isMark;
      _siteId = $v.siteId;
      _channelId = $v.channelId;
      _subchannelId = $v.subchannelId;
      _storageHtml = $v.storageHtml;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(InfoResponse other) {
    ArgumentError.checkNotNull(other, 'other');
    _$v = other as _$InfoResponse;
  }

  @override
  void update(void Function(InfoResponseBuilder)? updates) {
    if (updates != null) updates(this);
  }

  @override
  InfoResponse build() => _build();

  _$InfoResponse _build() {
    final _$result = _$v ??
        new _$InfoResponse._(
          id: BuiltValueNullFieldError.checkNotNull(id, r'InfoResponse', 'id'),
          title: BuiltValueNullFieldError.checkNotNull(
              title, r'InfoResponse', 'title'),
          url: BuiltValueNullFieldError.checkNotNull(
              url, r'InfoResponse', 'url'),
          published: published,
          createdAt: BuiltValueNullFieldError.checkNotNull(
              createdAt, r'InfoResponse', 'createdAt'),
          description: description,
          image: image,
          isNew: BuiltValueNullFieldError.checkNotNull(
              isNew, r'InfoResponse', 'isNew'),
          isMark: BuiltValueNullFieldError.checkNotNull(
              isMark, r'InfoResponse', 'isMark'),
          siteId: BuiltValueNullFieldError.checkNotNull(
              siteId, r'InfoResponse', 'siteId'),
          channelId: channelId,
          subchannelId: subchannelId,
          storageHtml: storageHtml,
        );
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: deprecated_member_use_from_same_package,type=lint
