// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'quiz_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AuthorDto {

 String get id; String get name;
/// Create a copy of AuthorDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthorDtoCopyWith<AuthorDto> get copyWith => _$AuthorDtoCopyWithImpl<AuthorDto>(this as AuthorDto, _$identity);

  /// Serializes this AuthorDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthorDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AuthorDto(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class $AuthorDtoCopyWith<$Res>  {
  factory $AuthorDtoCopyWith(AuthorDto value, $Res Function(AuthorDto) _then) = _$AuthorDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class _$AuthorDtoCopyWithImpl<$Res>
    implements $AuthorDtoCopyWith<$Res> {
  _$AuthorDtoCopyWithImpl(this._self, this._then);

  final AuthorDto _self;
  final $Res Function(AuthorDto) _then;

/// Create a copy of AuthorDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthorDto].
extension AuthorDtoPatterns on AuthorDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthorDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthorDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthorDto value)  $default,){
final _that = this;
switch (_that) {
case _AuthorDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthorDto value)?  $default,){
final _that = this;
switch (_that) {
case _AuthorDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthorDto() when $default != null:
return $default(_that.id,_that.name);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name)  $default,) {final _that = this;
switch (_that) {
case _AuthorDto():
return $default(_that.id,_that.name);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name)?  $default,) {final _that = this;
switch (_that) {
case _AuthorDto() when $default != null:
return $default(_that.id,_that.name);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AuthorDto extends AuthorDto {
  const _AuthorDto({required this.id, required this.name}): super._();
  factory _AuthorDto.fromJson(Map<String, dynamic> json) => _$AuthorDtoFromJson(json);

@override final  String id;
@override final  String name;

/// Create a copy of AuthorDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthorDtoCopyWith<_AuthorDto> get copyWith => __$AuthorDtoCopyWithImpl<_AuthorDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AuthorDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthorDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name);

@override
String toString() {
  return 'AuthorDto(id: $id, name: $name)';
}


}

/// @nodoc
abstract mixin class _$AuthorDtoCopyWith<$Res> implements $AuthorDtoCopyWith<$Res> {
  factory _$AuthorDtoCopyWith(_AuthorDto value, $Res Function(_AuthorDto) _then) = __$AuthorDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name
});




}
/// @nodoc
class __$AuthorDtoCopyWithImpl<$Res>
    implements _$AuthorDtoCopyWith<$Res> {
  __$AuthorDtoCopyWithImpl(this._self, this._then);

  final _AuthorDto _self;
  final $Res Function(_AuthorDto) _then;

/// Create a copy of AuthorDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,}) {
  return _then(_AuthorDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$OptionDto {

 String get id; String get text;
/// Create a copy of OptionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionDtoCopyWith<OptionDto> get copyWith => _$OptionDtoCopyWithImpl<OptionDto>(this as OptionDto, _$identity);

  /// Serializes this OptionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text);

@override
String toString() {
  return 'OptionDto(id: $id, text: $text)';
}


}

/// @nodoc
abstract mixin class $OptionDtoCopyWith<$Res>  {
  factory $OptionDtoCopyWith(OptionDto value, $Res Function(OptionDto) _then) = _$OptionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String text
});




}
/// @nodoc
class _$OptionDtoCopyWithImpl<$Res>
    implements $OptionDtoCopyWith<$Res> {
  _$OptionDtoCopyWithImpl(this._self, this._then);

  final OptionDto _self;
  final $Res Function(OptionDto) _then;

/// Create a copy of OptionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OptionDto].
extension OptionDtoPatterns on OptionDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OptionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OptionDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OptionDto value)  $default,){
final _that = this;
switch (_that) {
case _OptionDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OptionDto value)?  $default,){
final _that = this;
switch (_that) {
case _OptionDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OptionDto() when $default != null:
return $default(_that.id,_that.text);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String text)  $default,) {final _that = this;
switch (_that) {
case _OptionDto():
return $default(_that.id,_that.text);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String text)?  $default,) {final _that = this;
switch (_that) {
case _OptionDto() when $default != null:
return $default(_that.id,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OptionDto extends OptionDto {
  const _OptionDto({required this.id, required this.text}): super._();
  factory _OptionDto.fromJson(Map<String, dynamic> json) => _$OptionDtoFromJson(json);

@override final  String id;
@override final  String text;

/// Create a copy of OptionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OptionDtoCopyWith<_OptionDto> get copyWith => __$OptionDtoCopyWithImpl<_OptionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OptionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text);

@override
String toString() {
  return 'OptionDto(id: $id, text: $text)';
}


}

/// @nodoc
abstract mixin class _$OptionDtoCopyWith<$Res> implements $OptionDtoCopyWith<$Res> {
  factory _$OptionDtoCopyWith(_OptionDto value, $Res Function(_OptionDto) _then) = __$OptionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String text
});




}
/// @nodoc
class __$OptionDtoCopyWithImpl<$Res>
    implements _$OptionDtoCopyWith<$Res> {
  __$OptionDtoCopyWithImpl(this._self, this._then);

  final _OptionDto _self;
  final $Res Function(_OptionDto) _then;

/// Create a copy of OptionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = null,}) {
  return _then(_OptionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$QuestionDto {

 String get id; String get statement; List<OptionDto> get options; String get correctOptionId;
/// Create a copy of QuestionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionDtoCopyWith<QuestionDto> get copyWith => _$QuestionDtoCopyWithImpl<QuestionDto>(this as QuestionDto, _$identity);

  /// Serializes this QuestionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.statement, statement) || other.statement == statement)&&const DeepCollectionEquality().equals(other.options, options)&&(identical(other.correctOptionId, correctOptionId) || other.correctOptionId == correctOptionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,statement,const DeepCollectionEquality().hash(options),correctOptionId);

@override
String toString() {
  return 'QuestionDto(id: $id, statement: $statement, options: $options, correctOptionId: $correctOptionId)';
}


}

/// @nodoc
abstract mixin class $QuestionDtoCopyWith<$Res>  {
  factory $QuestionDtoCopyWith(QuestionDto value, $Res Function(QuestionDto) _then) = _$QuestionDtoCopyWithImpl;
@useResult
$Res call({
 String id, String statement, List<OptionDto> options, String correctOptionId
});




}
/// @nodoc
class _$QuestionDtoCopyWithImpl<$Res>
    implements $QuestionDtoCopyWith<$Res> {
  _$QuestionDtoCopyWithImpl(this._self, this._then);

  final QuestionDto _self;
  final $Res Function(QuestionDto) _then;

/// Create a copy of QuestionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? statement = null,Object? options = null,Object? correctOptionId = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self.options : options // ignore: cast_nullable_to_non_nullable
as List<OptionDto>,correctOptionId: null == correctOptionId ? _self.correctOptionId : correctOptionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [QuestionDto].
extension QuestionDtoPatterns on QuestionDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuestionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuestionDto value)  $default,){
final _that = this;
switch (_that) {
case _QuestionDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuestionDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String statement,  List<OptionDto> options,  String correctOptionId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
return $default(_that.id,_that.statement,_that.options,_that.correctOptionId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String statement,  List<OptionDto> options,  String correctOptionId)  $default,) {final _that = this;
switch (_that) {
case _QuestionDto():
return $default(_that.id,_that.statement,_that.options,_that.correctOptionId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String statement,  List<OptionDto> options,  String correctOptionId)?  $default,) {final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
return $default(_that.id,_that.statement,_that.options,_that.correctOptionId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionDto extends QuestionDto {
  const _QuestionDto({required this.id, required this.statement, required final  List<OptionDto> options, required this.correctOptionId}): _options = options,super._();
  factory _QuestionDto.fromJson(Map<String, dynamic> json) => _$QuestionDtoFromJson(json);

@override final  String id;
@override final  String statement;
 final  List<OptionDto> _options;
@override List<OptionDto> get options {
  if (_options is EqualUnmodifiableListView) return _options;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_options);
}

@override final  String correctOptionId;

/// Create a copy of QuestionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuestionDtoCopyWith<_QuestionDto> get copyWith => __$QuestionDtoCopyWithImpl<_QuestionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuestionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.statement, statement) || other.statement == statement)&&const DeepCollectionEquality().equals(other._options, _options)&&(identical(other.correctOptionId, correctOptionId) || other.correctOptionId == correctOptionId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,statement,const DeepCollectionEquality().hash(_options),correctOptionId);

@override
String toString() {
  return 'QuestionDto(id: $id, statement: $statement, options: $options, correctOptionId: $correctOptionId)';
}


}

/// @nodoc
abstract mixin class _$QuestionDtoCopyWith<$Res> implements $QuestionDtoCopyWith<$Res> {
  factory _$QuestionDtoCopyWith(_QuestionDto value, $Res Function(_QuestionDto) _then) = __$QuestionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String statement, List<OptionDto> options, String correctOptionId
});




}
/// @nodoc
class __$QuestionDtoCopyWithImpl<$Res>
    implements _$QuestionDtoCopyWith<$Res> {
  __$QuestionDtoCopyWithImpl(this._self, this._then);

  final _QuestionDto _self;
  final $Res Function(_QuestionDto) _then;

/// Create a copy of QuestionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? statement = null,Object? options = null,Object? correctOptionId = null,}) {
  return _then(_QuestionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,statement: null == statement ? _self.statement : statement // ignore: cast_nullable_to_non_nullable
as String,options: null == options ? _self._options : options // ignore: cast_nullable_to_non_nullable
as List<OptionDto>,correctOptionId: null == correctOptionId ? _self.correctOptionId : correctOptionId // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$QuizDto {

 String get id; String get name; String? get description;@JsonKey(name: 'kahoot_image_url') String? get kahootImageUrl; String get visibility; List<String>? get themes; AuthorDto get author;@JsonKey(name: 'created_at') DateTime get createdAt;@JsonKey(name: 'play_count') int? get playCount; List<QuestionDto> get questions;
/// Create a copy of QuizDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizDtoCopyWith<QuizDto> get copyWith => _$QuizDtoCopyWithImpl<QuizDto>(this as QuizDto, _$identity);

  /// Serializes this QuizDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.kahootImageUrl, kahootImageUrl) || other.kahootImageUrl == kahootImageUrl)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&const DeepCollectionEquality().equals(other.themes, themes)&&(identical(other.author, author) || other.author == author)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,kahootImageUrl,visibility,const DeepCollectionEquality().hash(themes),author,createdAt,playCount,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'QuizDto(id: $id, name: $name, description: $description, kahootImageUrl: $kahootImageUrl, visibility: $visibility, themes: $themes, author: $author, createdAt: $createdAt, playCount: $playCount, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $QuizDtoCopyWith<$Res>  {
  factory $QuizDtoCopyWith(QuizDto value, $Res Function(QuizDto) _then) = _$QuizDtoCopyWithImpl;
@useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'kahoot_image_url') String? kahootImageUrl, String visibility, List<String>? themes, AuthorDto author,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'play_count') int? playCount, List<QuestionDto> questions
});


$AuthorDtoCopyWith<$Res> get author;

}
/// @nodoc
class _$QuizDtoCopyWithImpl<$Res>
    implements $QuizDtoCopyWith<$Res> {
  _$QuizDtoCopyWithImpl(this._self, this._then);

  final QuizDto _self;
  final $Res Function(QuizDto) _then;

/// Create a copy of QuizDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? kahootImageUrl = freezed,Object? visibility = null,Object? themes = freezed,Object? author = null,Object? createdAt = null,Object? playCount = freezed,Object? questions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,kahootImageUrl: freezed == kahootImageUrl ? _self.kahootImageUrl : kahootImageUrl // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,themes: freezed == themes ? _self.themes : themes // ignore: cast_nullable_to_non_nullable
as List<String>?,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as AuthorDto,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,playCount: freezed == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int?,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionDto>,
  ));
}
/// Create a copy of QuizDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorDtoCopyWith<$Res> get author {
  
  return $AuthorDtoCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}


/// Adds pattern-matching-related methods to [QuizDto].
extension QuizDtoPatterns on QuizDto {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _QuizDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _QuizDto() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _QuizDto value)  $default,){
final _that = this;
switch (_that) {
case _QuizDto():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _QuizDto value)?  $default,){
final _that = this;
switch (_that) {
case _QuizDto() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'kahoot_image_url')  String? kahootImageUrl,  String visibility,  List<String>? themes,  AuthorDto author, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'play_count')  int? playCount,  List<QuestionDto> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.kahootImageUrl,_that.visibility,_that.themes,_that.author,_that.createdAt,_that.playCount,_that.questions);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String? description, @JsonKey(name: 'kahoot_image_url')  String? kahootImageUrl,  String visibility,  List<String>? themes,  AuthorDto author, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'play_count')  int? playCount,  List<QuestionDto> questions)  $default,) {final _that = this;
switch (_that) {
case _QuizDto():
return $default(_that.id,_that.name,_that.description,_that.kahootImageUrl,_that.visibility,_that.themes,_that.author,_that.createdAt,_that.playCount,_that.questions);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String? description, @JsonKey(name: 'kahoot_image_url')  String? kahootImageUrl,  String visibility,  List<String>? themes,  AuthorDto author, @JsonKey(name: 'created_at')  DateTime createdAt, @JsonKey(name: 'play_count')  int? playCount,  List<QuestionDto> questions)?  $default,) {final _that = this;
switch (_that) {
case _QuizDto() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.kahootImageUrl,_that.visibility,_that.themes,_that.author,_that.createdAt,_that.playCount,_that.questions);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _QuizDto extends QuizDto {
  const _QuizDto({required this.id, required this.name, this.description, @JsonKey(name: 'kahoot_image_url') this.kahootImageUrl, required this.visibility, final  List<String>? themes, required this.author, @JsonKey(name: 'created_at') required this.createdAt, @JsonKey(name: 'play_count') this.playCount, required final  List<QuestionDto> questions}): _themes = themes,_questions = questions,super._();
  factory _QuizDto.fromJson(Map<String, dynamic> json) => _$QuizDtoFromJson(json);

@override final  String id;
@override final  String name;
@override final  String? description;
@override@JsonKey(name: 'kahoot_image_url') final  String? kahootImageUrl;
@override final  String visibility;
 final  List<String>? _themes;
@override List<String>? get themes {
  final value = _themes;
  if (value == null) return null;
  if (_themes is EqualUnmodifiableListView) return _themes;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  AuthorDto author;
@override@JsonKey(name: 'created_at') final  DateTime createdAt;
@override@JsonKey(name: 'play_count') final  int? playCount;
 final  List<QuestionDto> _questions;
@override List<QuestionDto> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of QuizDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$QuizDtoCopyWith<_QuizDto> get copyWith => __$QuizDtoCopyWithImpl<_QuizDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$QuizDtoToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizDto&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.kahootImageUrl, kahootImageUrl) || other.kahootImageUrl == kahootImageUrl)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&const DeepCollectionEquality().equals(other._themes, _themes)&&(identical(other.author, author) || other.author == author)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,kahootImageUrl,visibility,const DeepCollectionEquality().hash(_themes),author,createdAt,playCount,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'QuizDto(id: $id, name: $name, description: $description, kahootImageUrl: $kahootImageUrl, visibility: $visibility, themes: $themes, author: $author, createdAt: $createdAt, playCount: $playCount, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$QuizDtoCopyWith<$Res> implements $QuizDtoCopyWith<$Res> {
  factory _$QuizDtoCopyWith(_QuizDto value, $Res Function(_QuizDto) _then) = __$QuizDtoCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String? description,@JsonKey(name: 'kahoot_image_url') String? kahootImageUrl, String visibility, List<String>? themes, AuthorDto author,@JsonKey(name: 'created_at') DateTime createdAt,@JsonKey(name: 'play_count') int? playCount, List<QuestionDto> questions
});


@override $AuthorDtoCopyWith<$Res> get author;

}
/// @nodoc
class __$QuizDtoCopyWithImpl<$Res>
    implements _$QuizDtoCopyWith<$Res> {
  __$QuizDtoCopyWithImpl(this._self, this._then);

  final _QuizDto _self;
  final $Res Function(_QuizDto) _then;

/// Create a copy of QuizDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = freezed,Object? kahootImageUrl = freezed,Object? visibility = null,Object? themes = freezed,Object? author = null,Object? createdAt = null,Object? playCount = freezed,Object? questions = null,}) {
  return _then(_QuizDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,kahootImageUrl: freezed == kahootImageUrl ? _self.kahootImageUrl : kahootImageUrl // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,themes: freezed == themes ? _self._themes : themes // ignore: cast_nullable_to_non_nullable
as List<String>?,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
as AuthorDto,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,playCount: freezed == playCount ? _self.playCount : playCount // ignore: cast_nullable_to_non_nullable
as int?,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<QuestionDto>,
  ));
}

/// Create a copy of QuizDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AuthorDtoCopyWith<$Res> get author {
  
  return $AuthorDtoCopyWith<$Res>(_self.author, (value) {
    return _then(_self.copyWith(author: value));
  });
}
}

// dart format on
