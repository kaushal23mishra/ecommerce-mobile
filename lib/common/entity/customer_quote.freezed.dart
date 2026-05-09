// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'customer_quote.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$CustomerQuote {
  int? get tookQuote => throw _privateConstructorUsedError;
  String? get quoteDate => throw _privateConstructorUsedError;

  /// Create a copy of CustomerQuote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CustomerQuoteCopyWith<CustomerQuote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CustomerQuoteCopyWith<$Res> {
  factory $CustomerQuoteCopyWith(
    CustomerQuote value,
    $Res Function(CustomerQuote) then,
  ) = _$CustomerQuoteCopyWithImpl<$Res, CustomerQuote>;
  @useResult
  $Res call({int? tookQuote, String? quoteDate});
}

/// @nodoc
class _$CustomerQuoteCopyWithImpl<$Res, $Val extends CustomerQuote>
    implements $CustomerQuoteCopyWith<$Res> {
  _$CustomerQuoteCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CustomerQuote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tookQuote = freezed, Object? quoteDate = freezed}) {
    return _then(
      _value.copyWith(
            tookQuote:
                freezed == tookQuote
                    ? _value.tookQuote
                    : tookQuote // ignore: cast_nullable_to_non_nullable
                        as int?,
            quoteDate:
                freezed == quoteDate
                    ? _value.quoteDate
                    : quoteDate // ignore: cast_nullable_to_non_nullable
                        as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CustomerQuoteImplCopyWith<$Res>
    implements $CustomerQuoteCopyWith<$Res> {
  factory _$$CustomerQuoteImplCopyWith(
    _$CustomerQuoteImpl value,
    $Res Function(_$CustomerQuoteImpl) then,
  ) = __$$CustomerQuoteImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int? tookQuote, String? quoteDate});
}

/// @nodoc
class __$$CustomerQuoteImplCopyWithImpl<$Res>
    extends _$CustomerQuoteCopyWithImpl<$Res, _$CustomerQuoteImpl>
    implements _$$CustomerQuoteImplCopyWith<$Res> {
  __$$CustomerQuoteImplCopyWithImpl(
    _$CustomerQuoteImpl _value,
    $Res Function(_$CustomerQuoteImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CustomerQuote
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? tookQuote = freezed, Object? quoteDate = freezed}) {
    return _then(
      _$CustomerQuoteImpl(
        tookQuote:
            freezed == tookQuote
                ? _value.tookQuote
                : tookQuote // ignore: cast_nullable_to_non_nullable
                    as int?,
        quoteDate:
            freezed == quoteDate
                ? _value.quoteDate
                : quoteDate // ignore: cast_nullable_to_non_nullable
                    as String?,
      ),
    );
  }
}

/// @nodoc

class _$CustomerQuoteImpl implements _CustomerQuote {
  const _$CustomerQuoteImpl({this.tookQuote, this.quoteDate});

  @override
  final int? tookQuote;
  @override
  final String? quoteDate;

  @override
  String toString() {
    return 'CustomerQuote(tookQuote: $tookQuote, quoteDate: $quoteDate)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CustomerQuoteImpl &&
            (identical(other.tookQuote, tookQuote) ||
                other.tookQuote == tookQuote) &&
            (identical(other.quoteDate, quoteDate) ||
                other.quoteDate == quoteDate));
  }

  @override
  int get hashCode => Object.hash(runtimeType, tookQuote, quoteDate);

  /// Create a copy of CustomerQuote
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CustomerQuoteImplCopyWith<_$CustomerQuoteImpl> get copyWith =>
      __$$CustomerQuoteImplCopyWithImpl<_$CustomerQuoteImpl>(this, _$identity);
}

abstract class _CustomerQuote implements CustomerQuote {
  const factory _CustomerQuote({
    final int? tookQuote,
    final String? quoteDate,
  }) = _$CustomerQuoteImpl;

  @override
  int? get tookQuote;
  @override
  String? get quoteDate;

  /// Create a copy of CustomerQuote
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CustomerQuoteImplCopyWith<_$CustomerQuoteImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
