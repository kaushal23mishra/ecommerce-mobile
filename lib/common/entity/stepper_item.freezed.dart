// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stepper_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

/// @nodoc
mixin _$StepperItem {
  int get step => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  Widget get content => throw _privateConstructorUsedError;
  String get imagePath => throw _privateConstructorUsedError;
  bool get isDisabled => throw _privateConstructorUsedError;

  /// Create a copy of StepperItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $StepperItemCopyWith<StepperItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StepperItemCopyWith<$Res> {
  factory $StepperItemCopyWith(
    StepperItem value,
    $Res Function(StepperItem) then,
  ) = _$StepperItemCopyWithImpl<$Res, StepperItem>;
  @useResult
  $Res call({
    int step,
    String title,
    Widget content,
    String imagePath,
    bool isDisabled,
  });
}

/// @nodoc
class _$StepperItemCopyWithImpl<$Res, $Val extends StepperItem>
    implements $StepperItemCopyWith<$Res> {
  _$StepperItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StepperItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? title = null,
    Object? content = null,
    Object? imagePath = null,
    Object? isDisabled = null,
  }) {
    return _then(
      _value.copyWith(
            step:
                null == step
                    ? _value.step
                    : step // ignore: cast_nullable_to_non_nullable
                        as int,
            title:
                null == title
                    ? _value.title
                    : title // ignore: cast_nullable_to_non_nullable
                        as String,
            content:
                null == content
                    ? _value.content
                    : content // ignore: cast_nullable_to_non_nullable
                        as Widget,
            imagePath:
                null == imagePath
                    ? _value.imagePath
                    : imagePath // ignore: cast_nullable_to_non_nullable
                        as String,
            isDisabled:
                null == isDisabled
                    ? _value.isDisabled
                    : isDisabled // ignore: cast_nullable_to_non_nullable
                        as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$StepperItemImplCopyWith<$Res>
    implements $StepperItemCopyWith<$Res> {
  factory _$$StepperItemImplCopyWith(
    _$StepperItemImpl value,
    $Res Function(_$StepperItemImpl) then,
  ) = __$$StepperItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    int step,
    String title,
    Widget content,
    String imagePath,
    bool isDisabled,
  });
}

/// @nodoc
class __$$StepperItemImplCopyWithImpl<$Res>
    extends _$StepperItemCopyWithImpl<$Res, _$StepperItemImpl>
    implements _$$StepperItemImplCopyWith<$Res> {
  __$$StepperItemImplCopyWithImpl(
    _$StepperItemImpl _value,
    $Res Function(_$StepperItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of StepperItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? step = null,
    Object? title = null,
    Object? content = null,
    Object? imagePath = null,
    Object? isDisabled = null,
  }) {
    return _then(
      _$StepperItemImpl(
        step:
            null == step
                ? _value.step
                : step // ignore: cast_nullable_to_non_nullable
                    as int,
        title:
            null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                    as String,
        content:
            null == content
                ? _value.content
                : content // ignore: cast_nullable_to_non_nullable
                    as Widget,
        imagePath:
            null == imagePath
                ? _value.imagePath
                : imagePath // ignore: cast_nullable_to_non_nullable
                    as String,
        isDisabled:
            null == isDisabled
                ? _value.isDisabled
                : isDisabled // ignore: cast_nullable_to_non_nullable
                    as bool,
      ),
    );
  }
}

/// @nodoc

class _$StepperItemImpl implements _StepperItem {
  const _$StepperItemImpl({
    required this.step,
    required this.title,
    required this.content,
    required this.imagePath,
    this.isDisabled = false,
  });

  @override
  final int step;
  @override
  final String title;
  @override
  final Widget content;
  @override
  final String imagePath;
  @override
  @JsonKey()
  final bool isDisabled;

  @override
  String toString() {
    return 'StepperItem(step: $step, title: $title, content: $content, imagePath: $imagePath, isDisabled: $isDisabled)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StepperItemImpl &&
            (identical(other.step, step) || other.step == step) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.content, content) || other.content == content) &&
            (identical(other.imagePath, imagePath) ||
                other.imagePath == imagePath) &&
            (identical(other.isDisabled, isDisabled) ||
                other.isDisabled == isDisabled));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, step, title, content, imagePath, isDisabled);

  /// Create a copy of StepperItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StepperItemImplCopyWith<_$StepperItemImpl> get copyWith =>
      __$$StepperItemImplCopyWithImpl<_$StepperItemImpl>(this, _$identity);
}

abstract class _StepperItem implements StepperItem {
  const factory _StepperItem({
    required final int step,
    required final String title,
    required final Widget content,
    required final String imagePath,
    final bool isDisabled,
  }) = _$StepperItemImpl;

  @override
  int get step;
  @override
  String get title;
  @override
  Widget get content;
  @override
  String get imagePath;
  @override
  bool get isDisabled;

  /// Create a copy of StepperItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StepperItemImplCopyWith<_$StepperItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
