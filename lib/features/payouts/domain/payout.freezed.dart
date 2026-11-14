// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'payout.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PayoutEntry {

 int get userId; String get memberName; int get position; Cents get amount; PayoutStatus get status; DateTime? get paidAtUtc;
/// Create a copy of PayoutEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PayoutEntryCopyWith<PayoutEntry> get copyWith => _$PayoutEntryCopyWithImpl<PayoutEntry>(this as PayoutEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as PayoutEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PayoutEntry&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.position, _this.position) || other.position == _this.position)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.paidAtUtc, _this.paidAtUtc) || other.paidAtUtc == _this.paidAtUtc));
}


@override
int get hashCode {
  final _this = this as PayoutEntry;
  return Object.hash(runtimeType,_this.userId,_this.memberName,_this.position,_this.amount,_this.status,_this.paidAtUtc);
}

@override
String toString() {
  final _this = this as PayoutEntry;
  return 'PayoutEntry(userId: ${_this.userId}, memberName: ${_this.memberName}, position: ${_this.position}, amount: ${_this.amount}, status: ${_this.status}, paidAtUtc: ${_this.paidAtUtc})';
}


}

/// @nodoc
abstract mixin class $PayoutEntryCopyWith<$Res>  {
  factory $PayoutEntryCopyWith(PayoutEntry value, $Res Function(PayoutEntry) _then) = _$PayoutEntryCopyWithImpl;
@useResult
$Res call({
 int userId, String memberName, int position, Cents amount, PayoutStatus status, DateTime? paidAtUtc
});




}
/// @nodoc
class _$PayoutEntryCopyWithImpl<$Res>
    implements $PayoutEntryCopyWith<$Res> {
  _$PayoutEntryCopyWithImpl(this._self, this._then);

  final PayoutEntry _self;
  final $Res Function(PayoutEntry) _then;

/// Create a copy of PayoutEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? memberName = null,Object? position = null,Object? amount = null,Object? status = null,Object? paidAtUtc = freezed,}) {
  return _then(PayoutEntry(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PayoutStatus,paidAtUtc: freezed == paidAtUtc ? _self.paidAtUtc : paidAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [PayoutEntry].
extension PayoutEntryPatterns on PayoutEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PayoutEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PayoutEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PayoutEntry value)  $default,){
final _that = this;
switch (_that) {
case _PayoutEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PayoutEntry value)?  $default,){
final _that = this;
switch (_that) {
case _PayoutEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  String memberName,  int position,  Cents amount,  PayoutStatus status,  DateTime? paidAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PayoutEntry() when $default != null:
return $default(_that.userId,_that.memberName,_that.position,_that.amount,_that.status,_that.paidAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  String memberName,  int position,  Cents amount,  PayoutStatus status,  DateTime? paidAtUtc)  $default,) {final _that = this;
switch (_that) {
case _PayoutEntry():
return $default(_that.userId,_that.memberName,_that.position,_that.amount,_that.status,_that.paidAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  String memberName,  int position,  Cents amount,  PayoutStatus status,  DateTime? paidAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _PayoutEntry() when $default != null:
return $default(_that.userId,_that.memberName,_that.position,_that.amount,_that.status,_that.paidAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _PayoutEntry implements PayoutEntry {
  const _PayoutEntry({required this.userId, required this.memberName, required this.position, required this.amount, required this.status, this.paidAtUtc});
  

@override final  int userId;
@override final  String memberName;
@override final  int position;
@override final  Cents amount;
@override final  PayoutStatus status;
@override final  DateTime? paidAtUtc;

/// Create a copy of PayoutEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PayoutEntryCopyWith<_PayoutEntry> get copyWith => __$PayoutEntryCopyWithImpl<_PayoutEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PayoutEntry&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.position, position) || other.position == position)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidAtUtc, paidAtUtc) || other.paidAtUtc == paidAtUtc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,memberName,position,amount,status,paidAtUtc);
}

@override
String toString() {
    return 'PayoutEntry(userId: $userId, memberName: $memberName, position: $position, amount: $amount, status: $status, paidAtUtc: $paidAtUtc)';
}


}

/// @nodoc
abstract mixin class _$PayoutEntryCopyWith<$Res> implements $PayoutEntryCopyWith<$Res> {
  factory _$PayoutEntryCopyWith(_PayoutEntry value, $Res Function(_PayoutEntry) _then) = __$PayoutEntryCopyWithImpl;
@override @useResult
$Res call({
 int userId, String memberName, int position, Cents amount, PayoutStatus status, DateTime? paidAtUtc
});




}
/// @nodoc
class __$PayoutEntryCopyWithImpl<$Res>
    implements _$PayoutEntryCopyWith<$Res> {
  __$PayoutEntryCopyWithImpl(this._self, this._then);

  final _PayoutEntry _self;
  final $Res Function(_PayoutEntry) _then;

/// Create a copy of PayoutEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? memberName = null,Object? position = null,Object? amount = null,Object? status = null,Object? paidAtUtc = freezed,}) {
  return _then(_PayoutEntry(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as PayoutStatus,paidAtUtc: freezed == paidAtUtc ? _self.paidAtUtc : paidAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
