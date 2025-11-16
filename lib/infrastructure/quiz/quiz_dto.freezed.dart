// Freezed-generated file intentionally removed.
// The DTOs (AuthorDto, OptionDto, QuestionDto, QuizDto) are implemented
// manually in `quiz_dto.dart`. Keeping this placeholder prevents accidental
// re-introduction of Freezed-generated code. No code should live here.

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

 String get id;@JsonKey(name: 'answerText') String? get text;@JsonKey(name: 'mediaId') String? get mediaId;@JsonKey(name: 'isCorrect') bool? get isCorrect;
/// Create a copy of OptionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OptionDtoCopyWith<OptionDto> get copyWith => _$OptionDtoCopyWithImpl<OptionDto>(this as OptionDto, _$identity);

  /// Serializes this OptionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OptionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,mediaId,isCorrect);

@override
String toString() {
  return 'OptionDto(id: $id, text: $text, mediaId: $mediaId, isCorrect: $isCorrect)';
}


}

/// @nodoc
abstract mixin class $OptionDtoCopyWith<$Res>  {
  factory $OptionDtoCopyWith(OptionDto value, $Res Function(OptionDto) _then) = _$OptionDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'answerText') String? text,@JsonKey(name: 'mediaId') String? mediaId,@JsonKey(name: 'isCorrect') bool? isCorrect
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? text = freezed,Object? mediaId = freezed,Object? isCorrect = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,mediaId: freezed == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String?,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'answerText')  String? text, @JsonKey(name: 'mediaId')  String? mediaId, @JsonKey(name: 'isCorrect')  bool? isCorrect)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OptionDto() when $default != null:
return $default(_that.id,_that.text,_that.mediaId,_that.isCorrect);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'answerText')  String? text, @JsonKey(name: 'mediaId')  String? mediaId, @JsonKey(name: 'isCorrect')  bool? isCorrect)  $default,) {final _that = this;
switch (_that) {
case _OptionDto():
return $default(_that.id,_that.text,_that.mediaId,_that.isCorrect);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'answerText')  String? text, @JsonKey(name: 'mediaId')  String? mediaId, @JsonKey(name: 'isCorrect')  bool? isCorrect)?  $default,) {final _that = this;
switch (_that) {
case _OptionDto() when $default != null:
return $default(_that.id,_that.text,_that.mediaId,_that.isCorrect);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OptionDto extends OptionDto {
  const _OptionDto({required this.id, @JsonKey(name: 'answerText') this.text, @JsonKey(name: 'mediaId') this.mediaId, @JsonKey(name: 'isCorrect') this.isCorrect}): super._();
  factory _OptionDto.fromJson(Map<String, dynamic> json) => _$OptionDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'answerText') final  String? text;
@override@JsonKey(name: 'mediaId') final  String? mediaId;
@override@JsonKey(name: 'isCorrect') final  bool? isCorrect;

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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OptionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.text, text) || other.text == text)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.isCorrect, isCorrect) || other.isCorrect == isCorrect));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,text,mediaId,isCorrect);

@override
String toString() {
  return 'OptionDto(id: $id, text: $text, mediaId: $mediaId, isCorrect: $isCorrect)';
}


}

/// @nodoc
abstract mixin class _$OptionDtoCopyWith<$Res> implements $OptionDtoCopyWith<$Res> {
  factory _$OptionDtoCopyWith(_OptionDto value, $Res Function(_OptionDto) _then) = __$OptionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'answerText') String? text,@JsonKey(name: 'mediaId') String? mediaId,@JsonKey(name: 'isCorrect') bool? isCorrect
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? text = freezed,Object? mediaId = freezed,Object? isCorrect = freezed,}) {
  return _then(_OptionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,mediaId: freezed == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String?,isCorrect: freezed == isCorrect ? _self.isCorrect : isCorrect // ignore: cast_nullable_to_non_nullable
as bool?,
  ));
}


}


/// @nodoc
mixin _$QuestionDto {

 String get id;@JsonKey(name: 'questionText') String get questionText;@JsonKey(name: 'mediaId') String? get mediaId;@JsonKey(name: 'questionType') String? get questionType;@JsonKey(name: 'timeLimit') int? get timeLimit;@JsonKey(name: 'points') int? get points;@JsonKey(name: 'answers') List<OptionDto> get answers;
/// Create a copy of QuestionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuestionDtoCopyWith<QuestionDto> get copyWith => _$QuestionDtoCopyWithImpl<QuestionDto>(this as QuestionDto, _$identity);

  /// Serializes this QuestionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuestionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.timeLimit, timeLimit) || other.timeLimit == timeLimit)&&(identical(other.points, points) || other.points == points)&&const DeepCollectionEquality().equals(other.answers, answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionText,mediaId,questionType,timeLimit,points,const DeepCollectionEquality().hash(answers));

@override
String toString() {
  return 'QuestionDto(id: $id, questionText: $questionText, mediaId: $mediaId, questionType: $questionType, timeLimit: $timeLimit, points: $points, answers: $answers)';
}


}

/// @nodoc
abstract mixin class $QuestionDtoCopyWith<$Res>  {
  factory $QuestionDtoCopyWith(QuestionDto value, $Res Function(QuestionDto) _then) = _$QuestionDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'questionText') String questionText,@JsonKey(name: 'mediaId') String? mediaId,@JsonKey(name: 'questionType') String? questionType,@JsonKey(name: 'timeLimit') int? timeLimit,@JsonKey(name: 'points') int? points,@JsonKey(name: 'answers') List<OptionDto> answers
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? questionText = null,Object? mediaId = freezed,Object? questionType = freezed,Object? timeLimit = freezed,Object? points = freezed,Object? answers = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,mediaId: freezed == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String?,questionType: freezed == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as String?,timeLimit: freezed == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as int?,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as List<OptionDto>,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'questionText')  String questionText, @JsonKey(name: 'mediaId')  String? mediaId, @JsonKey(name: 'questionType')  String? questionType, @JsonKey(name: 'timeLimit')  int? timeLimit, @JsonKey(name: 'points')  int? points, @JsonKey(name: 'answers')  List<OptionDto> answers)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
return $default(_that.id,_that.questionText,_that.mediaId,_that.questionType,_that.timeLimit,_that.points,_that.answers);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'questionText')  String questionText, @JsonKey(name: 'mediaId')  String? mediaId, @JsonKey(name: 'questionType')  String? questionType, @JsonKey(name: 'timeLimit')  int? timeLimit, @JsonKey(name: 'points')  int? points, @JsonKey(name: 'answers')  List<OptionDto> answers)  $default,) {final _that = this;
switch (_that) {
case _QuestionDto():
return $default(_that.id,_that.questionText,_that.mediaId,_that.questionType,_that.timeLimit,_that.points,_that.answers);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'questionText')  String questionText, @JsonKey(name: 'mediaId')  String? mediaId, @JsonKey(name: 'questionType')  String? questionType, @JsonKey(name: 'timeLimit')  int? timeLimit, @JsonKey(name: 'points')  int? points, @JsonKey(name: 'answers')  List<OptionDto> answers)?  $default,) {final _that = this;
switch (_that) {
case _QuestionDto() when $default != null:
return $default(_that.id,_that.questionText,_that.mediaId,_that.questionType,_that.timeLimit,_that.points,_that.answers);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _QuestionDto extends QuestionDto {
  const _QuestionDto({required this.id, @JsonKey(name: 'questionText') required this.questionText, @JsonKey(name: 'mediaId') this.mediaId, @JsonKey(name: 'questionType') this.questionType, @JsonKey(name: 'timeLimit') this.timeLimit, @JsonKey(name: 'points') this.points, @JsonKey(name: 'answers') required final  List<OptionDto> answers}): _answers = answers,super._();
  factory _QuestionDto.fromJson(Map<String, dynamic> json) => _$QuestionDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'questionText') final  String questionText;
@override@JsonKey(name: 'mediaId') final  String? mediaId;
@override@JsonKey(name: 'questionType') final  String? questionType;
@override@JsonKey(name: 'timeLimit') final  int? timeLimit;
@override@JsonKey(name: 'points') final  int? points;
 final  List<OptionDto> _answers;
@override@JsonKey(name: 'answers') List<OptionDto> get answers {
  if (_answers is EqualUnmodifiableListView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_answers);
}


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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuestionDto&&(identical(other.id, id) || other.id == id)&&(identical(other.questionText, questionText) || other.questionText == questionText)&&(identical(other.mediaId, mediaId) || other.mediaId == mediaId)&&(identical(other.questionType, questionType) || other.questionType == questionType)&&(identical(other.timeLimit, timeLimit) || other.timeLimit == timeLimit)&&(identical(other.points, points) || other.points == points)&&const DeepCollectionEquality().equals(other._answers, _answers));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,questionText,mediaId,questionType,timeLimit,points,const DeepCollectionEquality().hash(_answers));

@override
String toString() {
  return 'QuestionDto(id: $id, questionText: $questionText, mediaId: $mediaId, questionType: $questionType, timeLimit: $timeLimit, points: $points, answers: $answers)';
}


}

/// @nodoc
abstract mixin class _$QuestionDtoCopyWith<$Res> implements $QuestionDtoCopyWith<$Res> {
  factory _$QuestionDtoCopyWith(_QuestionDto value, $Res Function(_QuestionDto) _then) = __$QuestionDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'questionText') String questionText,@JsonKey(name: 'mediaId') String? mediaId,@JsonKey(name: 'questionType') String? questionType,@JsonKey(name: 'timeLimit') int? timeLimit,@JsonKey(name: 'points') int? points,@JsonKey(name: 'answers') List<OptionDto> answers
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? questionText = null,Object? mediaId = freezed,Object? questionType = freezed,Object? timeLimit = freezed,Object? points = freezed,Object? answers = null,}) {
  return _then(_QuestionDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,questionText: null == questionText ? _self.questionText : questionText // ignore: cast_nullable_to_non_nullable
as String,mediaId: freezed == mediaId ? _self.mediaId : mediaId // ignore: cast_nullable_to_non_nullable
as String?,questionType: freezed == questionType ? _self.questionType : questionType // ignore: cast_nullable_to_non_nullable
as String?,timeLimit: freezed == timeLimit ? _self.timeLimit : timeLimit // ignore: cast_nullable_to_non_nullable
as int?,points: freezed == points ? _self.points : points // ignore: cast_nullable_to_non_nullable
as int?,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as List<OptionDto>,
  ));
}


}


/// @nodoc
mixin _$QuizDto {

 String get id;@JsonKey(name: 'title') String get title; String? get description;@JsonKey(name: 'coverImageId') String? get coverImageId; String get visibility;@JsonKey(name: 'themeId') String? get themeId; AuthorDto get author;@JsonKey(name: 'createdAt') DateTime get createdAt;@JsonKey(name: 'playCount') int? get playCount; List<QuestionDto> get questions;
/// Create a copy of QuizDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$QuizDtoCopyWith<QuizDto> get copyWith => _$QuizDtoCopyWithImpl<QuizDto>(this as QuizDto, _$identity);

  /// Serializes this QuizDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is QuizDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.themeId, themeId) || other.themeId == themeId)&&(identical(other.author, author) || other.author == author)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&const DeepCollectionEquality().equals(other.questions, questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,coverImageId,visibility,themeId,author,createdAt,playCount,const DeepCollectionEquality().hash(questions));

@override
String toString() {
  return 'QuizDto(id: $id, title: $title, description: $description, coverImageId: $coverImageId, visibility: $visibility, themeId: $themeId, author: $author, createdAt: $createdAt, playCount: $playCount, questions: $questions)';
}


}

/// @nodoc
abstract mixin class $QuizDtoCopyWith<$Res>  {
  factory $QuizDtoCopyWith(QuizDto value, $Res Function(QuizDto) _then) = _$QuizDtoCopyWithImpl;
@useResult
$Res call({
 String id,@JsonKey(name: 'title') String title, String? description,@JsonKey(name: 'coverImageId') String? coverImageId, String visibility,@JsonKey(name: 'themeId') String? themeId, AuthorDto author,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'playCount') int? playCount, List<QuestionDto> questions
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
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? coverImageId = freezed,Object? visibility = null,Object? themeId = freezed,Object? author = null,Object? createdAt = null,Object? playCount = freezed,Object? questions = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,themeId: freezed == themeId ? _self.themeId : themeId // ignore: cast_nullable_to_non_nullable
as String?,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'title')  String title,  String? description, @JsonKey(name: 'coverImageId')  String? coverImageId,  String visibility, @JsonKey(name: 'themeId')  String? themeId,  AuthorDto author, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'playCount')  int? playCount,  List<QuestionDto> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _QuizDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.coverImageId,_that.visibility,_that.themeId,_that.author,_that.createdAt,_that.playCount,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id, @JsonKey(name: 'title')  String title,  String? description, @JsonKey(name: 'coverImageId')  String? coverImageId,  String visibility, @JsonKey(name: 'themeId')  String? themeId,  AuthorDto author, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'playCount')  int? playCount,  List<QuestionDto> questions)  $default,) {final _that = this;
switch (_that) {
case _QuizDto():
return $default(_that.id,_that.title,_that.description,_that.coverImageId,_that.visibility,_that.themeId,_that.author,_that.createdAt,_that.playCount,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id, @JsonKey(name: 'title')  String title,  String? description, @JsonKey(name: 'coverImageId')  String? coverImageId,  String visibility, @JsonKey(name: 'themeId')  String? themeId,  AuthorDto author, @JsonKey(name: 'createdAt')  DateTime createdAt, @JsonKey(name: 'playCount')  int? playCount,  List<QuestionDto> questions)?  $default,) {final _that = this;
switch (_that) {
case _QuizDto() when $default != null:
return $default(_that.id,_that.title,_that.description,_that.coverImageId,_that.visibility,_that.themeId,_that.author,_that.createdAt,_that.playCount,_that.questions);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _QuizDto extends QuizDto {
  const _QuizDto({required this.id, @JsonKey(name: 'title') required this.title, this.description, @JsonKey(name: 'coverImageId') this.coverImageId, required this.visibility, @JsonKey(name: 'themeId') this.themeId, required this.author, @JsonKey(name: 'createdAt') required this.createdAt, @JsonKey(name: 'playCount') this.playCount, required final  List<QuestionDto> questions}): _questions = questions,super._();
  factory _QuizDto.fromJson(Map<String, dynamic> json) => _$QuizDtoFromJson(json);

@override final  String id;
@override@JsonKey(name: 'title') final  String title;
@override final  String? description;
@override@JsonKey(name: 'coverImageId') final  String? coverImageId;
@override final  String visibility;
@override@JsonKey(name: 'themeId') final  String? themeId;
@override final  AuthorDto author;
@override@JsonKey(name: 'createdAt') final  DateTime createdAt;
@override@JsonKey(name: 'playCount') final  int? playCount;
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
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _QuizDto&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.coverImageId, coverImageId) || other.coverImageId == coverImageId)&&(identical(other.visibility, visibility) || other.visibility == visibility)&&(identical(other.themeId, themeId) || other.themeId == themeId)&&(identical(other.author, author) || other.author == author)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.playCount, playCount) || other.playCount == playCount)&&const DeepCollectionEquality().equals(other._questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,description,coverImageId,visibility,themeId,author,createdAt,playCount,const DeepCollectionEquality().hash(_questions));

@override
String toString() {
  return 'QuizDto(id: $id, title: $title, description: $description, coverImageId: $coverImageId, visibility: $visibility, themeId: $themeId, author: $author, createdAt: $createdAt, playCount: $playCount, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$QuizDtoCopyWith<$Res> implements $QuizDtoCopyWith<$Res> {
  factory _$QuizDtoCopyWith(_QuizDto value, $Res Function(_QuizDto) _then) = __$QuizDtoCopyWithImpl;
@override @useResult
$Res call({
 String id,@JsonKey(name: 'title') String title, String? description,@JsonKey(name: 'coverImageId') String? coverImageId, String visibility,@JsonKey(name: 'themeId') String? themeId, AuthorDto author,@JsonKey(name: 'createdAt') DateTime createdAt,@JsonKey(name: 'playCount') int? playCount, List<QuestionDto> questions
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
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? description = freezed,Object? coverImageId = freezed,Object? visibility = null,Object? themeId = freezed,Object? author = null,Object? createdAt = null,Object? playCount = freezed,Object? questions = null,}) {
  return _then(_QuizDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,coverImageId: freezed == coverImageId ? _self.coverImageId : coverImageId // ignore: cast_nullable_to_non_nullable
as String?,visibility: null == visibility ? _self.visibility : visibility // ignore: cast_nullable_to_non_nullable
as String,themeId: freezed == themeId ? _self.themeId : themeId // ignore: cast_nullable_to_non_nullable
as String?,author: null == author ? _self.author : author // ignore: cast_nullable_to_non_nullable
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
