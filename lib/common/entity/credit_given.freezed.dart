// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'credit_given.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CreditGiven {
  bool? get isGiven => throw _privateConstructorUsedError;
  int? get amountPending => throw _privateConstructorUsedError;
  String? get permittedBy => throw _privateConstructorUsedError;
  String? get expectedDateOfPayment => throw _privateConstructorUsedError;

  /// Create a copy of CreditGiven
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CreditGivenCopyWith<CreditGiven> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CreditGivenCopyWith<$Res> {
  factory $CreditGivenCopyWith(
    CreditGiven value,
    $Res Function(CreditGiven) then,
  ) = _$CreditGivenCopyWithImpl<$Res, CreditGiven>;
  @useResult
  $Res call({
    bool? isGiven,
    int? amountPending,
    String? permittedBy,
    String? expectedDateOfPayment,
  });
}

/// @nodoc
class _$CreditGivenCopyWithImpl<$Res, $Val extends CreditGiven>
    implements $CreditGivenCopyWith<$Res> {
  _$CreditGivenCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CreditGiven
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isGiven = freezed,
    Object? amountPending = freezed,
    Object? permittedBy = freezed,
    Object? expectedDateOfPayment = freezed,
  }) {
    return _then(
      _value.copyWith(
            isGiven:
                freezed == isGiven
                    ? _value.isGiven
                    : isGiven // ignore: cast_nullable_to_non_nullable
                        as bool?,
            amountPending:
                freezed == amountPending
                    ? _value.amountPending
                    : amountPending // ignore: cast_nullable_to_non_nullable
                        as int?,
            permittedBy:
                freezed == permittedBy
                    ? _value.permittedBy
                    : permittedBy // ignore: cast_nullable_to_non_nullable
                        as String?,
            expectedDateOfPayment:
                freezed == expectedDateOfPayment
                    ? _value.expectedDateOfPayment
                    : expectedDateOfPayment // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CreditGivenImplCopyWith<$Res>
    implements $CreditGivenCopyWith<$Res> {
  factory _$$CreditGivenImplCopyWith(
    _$CreditGivenImpl value,
    $Res Function(_$CreditGivenImpl) then,
  ) = __$$CreditGivenImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    bool? isGiven,
    int? amountPending,
    String? permittedBy,
    String? expectedDateOfPayment,
  });
}

/// @nodoc
class __$$CreditGivenImplCopyWithImpl<$Res>
    extends _$CreditGivenCopyWithImpl<$Res, _$CreditGivenImpl>
    implements _$$CreditGivenImplCopyWith<$Res> {
  __$$CreditGivenImplCopyWithImpl(
    _$CreditGivenImpl _value,
    $Res Function(_$CreditGivenImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CreditGiven
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isGiven = freezed,
    Object? amountPending = freezed,
    Object? permittedBy = freezed,
    Object? expectedDateOfPayment = freezed,
  }) {
    return _then(
      _$CreditGivenImpl(
        isGiven:
            freezed == isGiven
                ? _value.isGiven
                : isGiven // ignore: cast_nullable_to_non_nullable
                    as bool?,
        amountPending:
            freezed == amountPending
                ? _value.amountPending
                : amountPending // ignore: cast_nullable_to_non_nullable
                    as int?,
        permittedBy:
            freezed == permittedBy
                ? _value.permittedBy
                : permittedBy // ignore: cast_nullable_to_non_nullable
                    as String?,
        expectedDateOfPayment:
            freezed == expectedDateOfPayment
                ? _value.expectedDateOfPayment
                : expectedDateOfPayment // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$CreditGivenImpl implements _CreditGiven {
  const _$CreditGivenImpl({
    this.isGiven,
    this.amountPending,
    this.permittedBy,
    this.expectedDateOfPayment,
  });

  @override
  final bool? isGiven;
  @override
  final int? amountPending;
  @override
  final String? permittedBy;
  @override
  final String? expectedDateOfPayment;

  @override
  String toString() {
    return 'CreditGiven(isGiven: $isGiven, amountPending: $amountPending, permittedBy: $permittedBy, expectedDateOfPayment: $expectedDateOfPayment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CreditGivenImpl &&
            (identical(other.isGiven, isGiven) || other.isGiven == isGiven) &&
            (identical(other.amountPending, amountPending) ||
                other.amountPending == amountPending) &&
            (identical(other.permittedBy, permittedBy) ||
                other.permittedBy == permittedBy) &&
            (identical(other.expectedDateOfPayment, expectedDateOfPayment) ||
                other.expectedDateOfPayment == expectedDateOfPayment));
  }

  @override
  int get hashCode => Object.hash(
    runtimeType,
    isGiven,
    amountPending,
    permittedBy,
    expectedDateOfPayment,
  );

  /// Create a copy of CreditGiven
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CreditGivenImplCopyWith<_$CreditGivenImpl> get copyWith =>
      __$$CreditGivenImplCopyWithImpl<_$CreditGivenImpl>(this, _$identity);
}

abstract class _CreditGiven implements CreditGiven {
  const factory _CreditGiven({
    final bool? isGiven,
    final int? amountPending,
    final String? permittedBy,
    final String? expectedDateOfPayment,
  }) = _$CreditGivenImpl;

  @override
  bool? get isGiven;
  @override
  int? get amountPending;
  @override
  String? get permittedBy;
  @override
  String? get expectedDateOfPayment;

  /// Create a copy of CreditGiven
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CreditGivenImplCopyWith<_$CreditGivenImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
