//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

// ignore_for_file: unused_element
import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';

part 'site_create.g.dart';

/// SiteCreate
///
/// Properties:
/// * [name]
/// * [description]
/// * [url]
/// * [favicon]
/// * [rss]
@BuiltValue()
abstract class SiteCreate implements Built<SiteCreate, SiteCreateBuilder> {
  @BuiltValueField(wireName: r'name')
  String get name;

  @BuiltValueField(wireName: r'description')
  String? get description;

  @BuiltValueField(wireName: r'url')
  String get url;

  @BuiltValueField(wireName: r'favicon')
  String? get favicon;

  @BuiltValueField(wireName: r'rss')
  String? get rss;

  SiteCreate._();

  factory SiteCreate([void updates(SiteCreateBuilder b)]) = _$SiteCreate;

  @BuiltValueHook(initializeBuilder: true)
  static void _defaults(SiteCreateBuilder b) => b;

  @BuiltValueSerializer(custom: true)
  static Serializer<SiteCreate> get serializer => _$SiteCreateSerializer();
}

class _$SiteCreateSerializer implements PrimitiveSerializer<SiteCreate> {
  @override
  final Iterable<Type> types = const [SiteCreate, _$SiteCreate];

  @override
  final String wireName = r'SiteCreate';

  Iterable<Object?> _serializeProperties(
    Serializers serializers,
    SiteCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) sync* {
    yield r'name';
    yield serializers.serialize(
      object.name,
      specifiedType: const FullType(String),
    );
    yield r'description';
    yield object.description == null
        ? null
        : serializers.serialize(
            object.description,
            specifiedType: const FullType.nullable(String),
          );
    yield r'url';
    yield serializers.serialize(
      object.url,
      specifiedType: const FullType(String),
    );
    yield r'favicon';
    yield object.favicon == null
        ? null
        : serializers.serialize(
            object.favicon,
            specifiedType: const FullType.nullable(String),
          );
    yield r'rss';
    yield object.rss == null
        ? null
        : serializers.serialize(
            object.rss,
            specifiedType: const FullType.nullable(String),
          );
  }

  @override
  Object serialize(
    Serializers serializers,
    SiteCreate object, {
    FullType specifiedType = FullType.unspecified,
  }) {
    return _serializeProperties(serializers, object,
            specifiedType: specifiedType)
        .toList();
  }

  void _deserializeProperties(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
    required List<Object?> serializedList,
    required SiteCreateBuilder result,
    required List<Object?> unhandled,
  }) {
    for (var i = 0; i < serializedList.length; i += 2) {
      final key = serializedList[i] as String;
      final value = serializedList[i + 1];
      switch (key) {
        case r'name':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.name = valueDes;
          break;
        case r'description':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.description = valueDes;
          break;
        case r'url':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType(String),
          ) as String;
          result.url = valueDes;
          break;
        case r'favicon':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.favicon = valueDes;
          break;
        case r'rss':
          final valueDes = serializers.deserialize(
            value,
            specifiedType: const FullType.nullable(String),
          ) as String?;
          if (valueDes == null) continue;
          result.rss = valueDes;
          break;
        default:
          unhandled.add(key);
          unhandled.add(value);
          break;
      }
    }
  }

  @override
  SiteCreate deserialize(
    Serializers serializers,
    Object serialized, {
    FullType specifiedType = FullType.unspecified,
  }) {
    final result = SiteCreateBuilder();
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
