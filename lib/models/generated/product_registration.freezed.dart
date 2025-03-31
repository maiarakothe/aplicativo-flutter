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
  String get productName => throw _privateConstructorUsedError;
  String get url => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;

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
  $Res call({String productName, String url, double price});
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
    Object? productName = null,
    Object? url = null,
    Object? price = null,
  }) {
    return _then(_value.copyWith(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
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
  $Res call({String productName, String url, double price});
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
    Object? productName = null,
    Object? url = null,
    Object? price = null,
  }) {
    return _then(_$ProductRegistrationDataImpl(
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      url: null == url
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      price: null == price
          ? _value.price
          : price // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductRegistrationDataImpl implements _ProductRegistrationData {
  const _$ProductRegistrationDataImpl(
      {required this.productName, required this.url, required this.price});

  factory _$ProductRegistrationDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductRegistrationDataImplFromJson(json);

  @override
  final String productName;
  @override
  final String url;
  @override
  final double price;

  @override
  String toString() {
    return 'ProductRegistrationData(productName: $productName, url: $url, price: $price)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductRegistrationDataImpl &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.url, url) || other.url == url) &&
            (identical(other.price, price) || other.price == price));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, productName, url, price);

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
      {required final String productName,
      required final String url,
      required final double price}) = _$ProductRegistrationDataImpl;

  factory _ProductRegistrationData.fromJson(Map<String, dynamic> json) =
      _$ProductRegistrationDataImpl.fromJson;

  @override
  String get productName;
  @override
  String get url;
  @override
  double get price;

  /// Create a copy of ProductRegistrationData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductRegistrationDataImplCopyWith<_$ProductRegistrationDataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
