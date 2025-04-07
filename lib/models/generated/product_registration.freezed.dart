// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of '../product_registration.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ProductRegistrationData _$ProductRegistrationDataFromJson(
    Map<String, dynamic> json) {
  return _ProductRegistrationData.fromJson(json);
}

/// @nodoc
mixin _$ProductRegistrationData {
  int get id => throw _privateConstructorUsedError;
  String get name =>
      throw _privateConstructorUsedError; // ignore: invalid_annotation_target
  @JsonKey(name: 'category_type')
  String? get category => throw _privateConstructorUsedError;
  int? get quantity => throw _privateConstructorUsedError;
  double get value => throw _privateConstructorUsedError;
  String? get url => throw _privateConstructorUsedError;

  /// Serializes this ProductRegistrationData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductRegistrationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductRegistrationDataCopyWith<ProductRegistrationData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductRegistrationDataCopyWith<$Res> {
  factory $ProductRegistrationDataCopyWith(ProductRegistrationData value,
          $Res Function(ProductRegistrationData) then) =
      _$ProductRegistrationDataCopyWithImpl<$Res, ProductRegistrationData>;
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'category_type') String? category,
      int? quantity,
      double value,
      String? url});
}

/// @nodoc
class _$ProductRegistrationDataCopyWithImpl<$Res,
        $Val extends ProductRegistrationData>
    implements $ProductRegistrationDataCopyWith<$Res> {
  _$ProductRegistrationDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductRegistrationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = freezed,
    Object? quantity = freezed,
    Object? value = null,
    Object? url = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ProductRegistrationDataImplCopyWith<$Res>
    implements $ProductRegistrationDataCopyWith<$Res> {
  factory _$$ProductRegistrationDataImplCopyWith(
          _$ProductRegistrationDataImpl value,
          $Res Function(_$ProductRegistrationDataImpl) then) =
      __$$ProductRegistrationDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String name,
      @JsonKey(name: 'category_type') String? category,
      int? quantity,
      double value,
      String? url});
}

/// @nodoc
class __$$ProductRegistrationDataImplCopyWithImpl<$Res>
    extends _$ProductRegistrationDataCopyWithImpl<$Res,
        _$ProductRegistrationDataImpl>
    implements _$$ProductRegistrationDataImplCopyWith<$Res> {
  __$$ProductRegistrationDataImplCopyWithImpl(
      _$ProductRegistrationDataImpl _value,
      $Res Function(_$ProductRegistrationDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of ProductRegistrationData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? category = freezed,
    Object? quantity = freezed,
    Object? value = null,
    Object? url = freezed,
  }) {
    return _then(_$ProductRegistrationDataImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      category: freezed == category
          ? _value.category
          : category // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: freezed == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int?,
      value: null == value
          ? _value.value
          : value // ignore: cast_nullable_to_non_nullable
              as double,
      url: freezed == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductRegistrationDataImpl implements _ProductRegistrationData {
  const _$ProductRegistrationDataImpl(
      {required this.id,
      required this.name,
      @JsonKey(name: 'category_type') this.category,
      this.quantity,
      required this.value,
      this.url});

  factory _$ProductRegistrationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductRegistrationDataImplFromJson(json);

  @override
  final int id;
  @override
  final String name;
// ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'category_type')
  final String? category;
  @override
  final int? quantity;
  @override
  final double value;
  @override
  final String? url;

  @override
  String toString() {
    return 'ProductRegistrationData(id: $id, name: $name, category: $category, quantity: $quantity, value: $value, url: $url)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductRegistrationDataImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.category, category) ||
                other.category == category) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.value, value) || other.value == value) &&
            (identical(other.url, url) || other.url == url));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, name, category, quantity, value, url);

  /// Create a copy of ProductRegistrationData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductRegistrationDataImplCopyWith<_$ProductRegistrationDataImpl>
      get copyWith => __$$ProductRegistrationDataImplCopyWithImpl<
          _$ProductRegistrationDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductRegistrationDataImplToJson(
      this,
    );
  }
}

abstract class _ProductRegistrationData implements ProductRegistrationData {
  const factory _ProductRegistrationData(
      {required final int id,
      required final String name,
      @JsonKey(name: 'category_type') final String? category,
      final int? quantity,
      required final double value,
      final String? url}) = _$ProductRegistrationDataImpl;

  factory _ProductRegistrationData.fromJson(Map<String, dynamic> json) =
      _$ProductRegistrationDataImpl.fromJson;

  @override
  int get id;
  @override
  String get name; // ignore: invalid_annotation_target
  @override
  @JsonKey(name: 'category_type')
  String? get category;
  @override
  int? get quantity;
  @override
  double get value;
  @override
  String? get url;

  /// Create a copy of ProductRegistrationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductRegistrationDataImplCopyWith<_$ProductRegistrationDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
