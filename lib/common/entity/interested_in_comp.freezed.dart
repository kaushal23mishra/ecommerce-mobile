// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interested_in_comp.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$InterestedInComp {
  String? get status => throw _privateConstructorUsedError;
  int? get model => throw _privateConstructorUsedError;
  String? get modelName => throw _privateConstructorUsedError;
  int? get brand => throw _privateConstructorUsedError;
  String? get brandName => throw _privateConstructorUsedError;

  /// Create a copy of InterestedInComp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $InterestedInCompCopyWith<InterestedInComp> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $InterestedInCompCopyWith<$Res> {
  factory $InterestedInCompCopyWith(
    InterestedInComp value,
    $Res Function(InterestedInComp) then,
  ) = _$InterestedInCompCopyWithImpl<$Res, InterestedInComp>;
  @useResult
  $Res call({
    String? status,
    int? model,
    String? modelName,
    int? brand,
    String? brandName,
  });
}

/// @nodoc
class _$InterestedInCompCopyWithImpl<$Res, $Val extends InterestedInComp>
    implements $InterestedInCompCopyWith<$Res> {
  _$InterestedInCompCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of InterestedInComp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? model = freezed,
    Object? modelName = freezed,
    Object? brand = freezed,
    Object? brandName = freezed,
  }) {
    return _then(
      _value.copyWith(
            status:
                freezed == status
                    ? _value.status
                    : status // ignore: cast_nullable_to_non_nullable
                        as String?,
            model:
                freezed == model
                    ? _value.model
                    : model // ignore: cast_nullable_to_non_nullable
                        as int?,
            modelName:
                freezed == modelName
                    ? _value.modelName
                    : modelName // ignore: cast_nullable_to_non_nullable
                        as String?,
            brand:
                freezed == brand
                    ? _value.brand
                    : brand // ignore: cast_nullable_to_non_nullable
                        as int?,
            brandName:
                freezed == brandName
                    ? _value.brandName
                    : brandName // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$InterestedInCompImplCopyWith<$Res>
    implements $InterestedInCompCopyWith<$Res> {
  factory _$$InterestedInCompImplCopyWith(
    _$InterestedInCompImpl value,
    $Res Function(_$InterestedInCompImpl) then,
  ) = __$$InterestedInCompImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String? status,
    int? model,
    String? modelName,
    int? brand,
    String? brandName,
  });
}

/// @nodoc
class __$$InterestedInCompImplCopyWithImpl<$Res>
    extends _$InterestedInCompCopyWithImpl<$Res, _$InterestedInCompImpl>
    implements _$$InterestedInCompImplCopyWith<$Res> {
  __$$InterestedInCompImplCopyWithImpl(
    _$InterestedInCompImpl _value,
    $Res Function(_$InterestedInCompImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of InterestedInComp
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? status = freezed,
    Object? model = freezed,
    Object? modelName = freezed,
    Object? brand = freezed,
    Object? brandName = freezed,
  }) {
    return _then(
      _$InterestedInCompImpl(
        status:
            freezed == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                    as String?,
        model:
            freezed == model
                ? _value.model
                : model // ignore: cast_nullable_to_non_nullable
                    as int?,
        modelName:
            freezed == modelName
                ? _value.modelName
                : modelName // ignore: cast_nullable_to_non_nullable
                    as String?,
        brand:
            freezed == brand
                ? _value.brand
                : brand // ignore: cast_nullable_to_non_nullable
                    as int?,
        brandName:
            freezed == brandName
                ? _value.brandName
                : brandName // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$InterestedInCompImpl implements _InterestedInComp {
  const _$InterestedInCompImpl({
    this.status,
    this.model,
    this.modelName,
    this.brand,
    this.brandName,
  });

  @override
  final String? status;
  @override
  final int? model;
  @override
  final String? modelName;
  @override
  final int? brand;
  @override
  final String? brandName;

  @override
  String toString() {
    return 'InterestedInComp(status: $status, model: $model, modelName: $modelName, brand: $brand, brandName: $brandName)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$InterestedInCompImpl &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.model, model) || other.model == model) &&
            (identical(other.modelName, modelName) ||
                other.modelName == modelName) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.brandName, brandName) ||
                other.brandName == brandName));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, status, model, modelName, brand, brandName);

  /// Create a copy of InterestedInComp
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$InterestedInCompImplCopyWith<_$InterestedInCompImpl> get copyWith =>
      __$$InterestedInCompImplCopyWithImpl<_$InterestedInCompImpl>(
        this,
        _$identity,
      );
}

abstract class _InterestedInComp implements InterestedInComp {
  const factory _InterestedInComp({
    final String? status,
    final int? model,
    final String? modelName,
    final int? brand,
    final String? brandName,
  }) = _$InterestedInCompImpl;

  @override
  String? get status;
  @override
  int? get model;
  @override
  String? get modelName;
  @override
  int? get brand;
  @override
  String? get brandName;

  /// Create a copy of InterestedInComp
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$InterestedInCompImplCopyWith<_$InterestedInCompImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
