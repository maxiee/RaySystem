//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'info_response.g.dart';

/// InfoResponse
///
/// Properties:
/// * [id] 
/// * [title] 
/// * [url] 
/// * [published] 
/// * [createdAt] 
/// * [description] 
/// * [image] 
/// * [isNew] 
/// * [isMark] 
/// * [siteId] 
/// * [channelId] 
/// * [subchannelId] 
/// * [storageHtml] 
@BuiltValue()
abstract class InfoResponse implements Built<InfoResponse, InfoResponseBuilder> {
  @BuiltValueField(wireName: r'id')
  int get id;

  @BuiltValueField(wireName: r'title')
  String get title;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'published')
  DateTime? get published;

  @BuiltValueField(wireName: r'created_at')
  DateTime get createdAt;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'image')
  String? get image;

  @BuiltValueField(wireName: r'is_new')
  bool get isNew;

  @BuiltValueField(wireName: r'is_mark')
  bool get isMark;

  @BuiltValueField(wireName: r'site_id')
  int get siteId;

  @BuiltValueField(wireName: r'channel_id')
  int? get channelId;

  @BuiltValueField(wireName: r'subchannel_id')
  int? get subchannelId;

  @BuiltValueField(wireName: r'storage_html')
  String? get storageHtml;

  InfoResponse._();

  factory InfoResponse([void updates(InfoResponseBuilder b)]) = _$InfoResponse;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(InfoResponseBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<InfoResponse> get serializer => _$InfoResponseSerializer();
}

class _$InfoResponseSerializer implements PrimitiveSerializer<InfoResponse> {
  @override
  final Iterable<Type> types = const [InfoResponse, _$InfoResponse];

  @override
  final String wireName = r'InfoResponse';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    InfoResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'id';
    yield serializers.serialize(
      object.id,
      specifiedType: const FullType(int),
    );
    yield r'title';
    yield serializers.serialize(
      object.title,
      specifiedType: const FullType(String),
    );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    if (object.published != null) {
      yield r'published';
      yield serializers.serialize(
        object.published,
        specifiedType: const FullType.nullable(DateTime),
      );
    }
    yield r'created_at';
    yield serializers.serialize(
      object.createdAt,
      specifiedType: const FullType(DateTime),
    );
    if (object.description != null) {
      yield r'description';
      yield serializers.serialize(
        object.description,
        specifiedType: const FullType.nullable(String),
      );
    }
    if (object.image != null) {
      yield r'image';
      yield serializers.serialize(
        object.image,
        specifiedType: const FullType.nullable(String),
      );
    }
    yield r'is_new';
    yield serializers.serialize(
      object.isNew,
      specifiedType: const FullType(bool),
    );
    yield r'is_mark';
    yield serializers.serialize(
      object.isMark,
      specifiedType: const FullType(bool),
    );
    yield r'site_id';
    yield serializers.serialize(
      object.siteId,
      specifiedType: const FullType(int),
    );
    if (object.channelId != null) {
      yield r'channel_id';
      yield serializers.serialize(
        object.channelId,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.subchannelId != null) {
      yield r'subchannel_id';
      yield serializers.serialize(
        object.subchannelId,
        specifiedType: const FullType.nullable(int),
      );
    }
    if (object.storageHtml != null) {
      yield r'storage_html';
      yield serializers.serialize(
        object.storageHtml,
        specifiedType: const FullType.nullable(String),
      );
    }
  }

  @override
  Object serialize(
    Serializers serializers,
    InfoResponse object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object, specifiedType: specifiedType).toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required InfoResponseBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.id = valueDes;
          break;
        case r'title':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.title = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'published':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(DateTime),
          ) as DateTime?;
          if (valueDes == null) continue;
          result.published = valueDes;
          break;
        case r'created_at':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(DateTime),
          ) as DateTime;
          result.createdAt = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'image':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.image = valueDes;
          break;
        case r'is_new':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isNew = valueDes;
          break;
        case r'is_mark':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(bool),
          ) as bool;
          result.isMark = valueDes;
          break;
        case r'site_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(int),
          ) as int;
          result.siteId = valueDes;
          break;
        case r'channel_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.channelId = valueDes;
          break;
        case r'subchannel_id':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(int),
          ) as int?;
          if (valueDes == null) continue;
          result.subchannelId = valueDes;
          break;
        case r'storage_html':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.storageHtml = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  InfoResponse deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = InfoResponseBuilder();
    final serializedList = (serialized as Iterable<Object?>).toList();
    final unhandled = <Object?>[];
    _deserializeProperties(
      serializers,
      serialized,
      specifiedType: specifiedType,
      serializedList: serializedList,
      unhandled: unhandled,
      result: result,
    );
    return result.build();
  }
}

