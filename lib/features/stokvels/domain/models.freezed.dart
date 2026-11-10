// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Membership {

 int get stokvelId; StokvelRole get role;
/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MembershipCopyWith<Membership> get copyWith => _$MembershipCopyWithImpl<Membership>(this as Membership, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Membership;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Membership&&(identical(other.stokvelId, _this.stokvelId) || other.stokvelId == _this.stokvelId)&&(identical(other.role, _this.role) || other.role == _this.role));
}


@override
int get hashCode {
  final _this = this as Membership;
  return Object.hash(runtimeType,_this.stokvelId,_this.role);
}

@override
String toString() {
  final _this = this as Membership;
  return 'Membership(stokvelId: ${_this.stokvelId}, role: ${_this.role})';
}


}

/// @nodoc
abstract mixin class $MembershipCopyWith<$Res>  {
  factory $MembershipCopyWith(Membership value, $Res Function(Membership) _then) = _$MembershipCopyWithImpl;
@useResult
$Res call({
 int stokvelId, StokvelRole role
});




}
/// @nodoc
class _$MembershipCopyWithImpl<$Res>
    implements $MembershipCopyWith<$Res> {
  _$MembershipCopyWithImpl(this._self, this._then);

  final Membership _self;
  final $Res Function(Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stokvelId = null,Object? role = null,}) {
  return _then(Membership(
stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as StokvelRole,
  ));
}

}


/// Adds pattern-matching-related methods to [Membership].
extension MembershipPatterns on Membership {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Membership value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Membership value)  $default,){
final _that = this;
switch (_that) {
case _Membership():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Membership value)?  $default,){
final _that = this;
switch (_that) {
case _Membership() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int stokvelId,  StokvelRole role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.stokvelId,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int stokvelId,  StokvelRole role)  $default,) {final _that = this;
switch (_that) {
case _Membership():
return $default(_that.stokvelId,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int stokvelId,  StokvelRole role)?  $default,) {final _that = this;
switch (_that) {
case _Membership() when $default != null:
return $default(_that.stokvelId,_that.role);case _:
  return null;

}
}

}

/// @nodoc


class _Membership implements Membership {
  const _Membership({required this.stokvelId, required this.role});
  

@override final  int stokvelId;
@override final  StokvelRole role;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MembershipCopyWith<_Membership> get copyWith => __$MembershipCopyWithImpl<_Membership>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Membership&&(identical(other.stokvelId, stokvelId) || other.stokvelId == stokvelId)&&(identical(other.role, role) || other.role == role));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stokvelId,role);
}

@override
String toString() {
    return 'Membership(stokvelId: $stokvelId, role: $role)';
}


}

/// @nodoc
abstract mixin class _$MembershipCopyWith<$Res> implements $MembershipCopyWith<$Res> {
  factory _$MembershipCopyWith(_Membership value, $Res Function(_Membership) _then) = __$MembershipCopyWithImpl;
@override @useResult
$Res call({
 int stokvelId, StokvelRole role
});




}
/// @nodoc
class __$MembershipCopyWithImpl<$Res>
    implements _$MembershipCopyWith<$Res> {
  __$MembershipCopyWithImpl(this._self, this._then);

  final _Membership _self;
  final $Res Function(_Membership) _then;

/// Create a copy of Membership
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stokvelId = null,Object? role = null,}) {
  return _then(_Membership(
stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as int,role: null == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as StokvelRole,
  ));
}


}

/// @nodoc
mixin _$Stokvel {

 int get id; String get name; Cents get contributionAmount; int get memberCount;
/// Create a copy of Stokvel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StokvelCopyWith<Stokvel> get copyWith => _$StokvelCopyWithImpl<Stokvel>(this as Stokvel, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Stokvel;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Stokvel&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.contributionAmount, _this.contributionAmount) || other.contributionAmount == _this.contributionAmount)&&(identical(other.memberCount, _this.memberCount) || other.memberCount == _this.memberCount));
}


@override
int get hashCode {
  final _this = this as Stokvel;
  return Object.hash(runtimeType,_this.id,_this.name,_this.contributionAmount,_this.memberCount);
}

@override
String toString() {
  final _this = this as Stokvel;
  return 'Stokvel(id: ${_this.id}, name: ${_this.name}, contributionAmount: ${_this.contributionAmount}, memberCount: ${_this.memberCount})';
}


}

/// @nodoc
abstract mixin class $StokvelCopyWith<$Res>  {
  factory $StokvelCopyWith(Stokvel value, $Res Function(Stokvel) _then) = _$StokvelCopyWithImpl;
@useResult
$Res call({
 int id, String name, Cents contributionAmount, int memberCount
});




}
/// @nodoc
class _$StokvelCopyWithImpl<$Res>
    implements $StokvelCopyWith<$Res> {
  _$StokvelCopyWithImpl(this._self, this._then);

  final Stokvel _self;
  final $Res Function(Stokvel) _then;

/// Create a copy of Stokvel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? contributionAmount = null,Object? memberCount = null,}) {
  return _then(Stokvel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contributionAmount: null == contributionAmount ? _self.contributionAmount : contributionAmount // ignore: cast_nullable_to_non_nullable
as Cents,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [Stokvel].
extension StokvelPatterns on Stokvel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Stokvel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Stokvel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Stokvel value)  $default,){
final _that = this;
switch (_that) {
case _Stokvel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Stokvel value)?  $default,){
final _that = this;
switch (_that) {
case _Stokvel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  Cents contributionAmount,  int memberCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Stokvel() when $default != null:
return $default(_that.id,_that.name,_that.contributionAmount,_that.memberCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  Cents contributionAmount,  int memberCount)  $default,) {final _that = this;
switch (_that) {
case _Stokvel():
return $default(_that.id,_that.name,_that.contributionAmount,_that.memberCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  Cents contributionAmount,  int memberCount)?  $default,) {final _that = this;
switch (_that) {
case _Stokvel() when $default != null:
return $default(_that.id,_that.name,_that.contributionAmount,_that.memberCount);case _:
  return null;

}
}

}

/// @nodoc


class _Stokvel implements Stokvel {
  const _Stokvel({required this.id, required this.name, required this.contributionAmount, required this.memberCount});
  

@override final  int id;
@override final  String name;
@override final  Cents contributionAmount;
@override final  int memberCount;

/// Create a copy of Stokvel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StokvelCopyWith<_Stokvel> get copyWith => __$StokvelCopyWithImpl<_Stokvel>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Stokvel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.contributionAmount, contributionAmount) || other.contributionAmount == contributionAmount)&&(identical(other.memberCount, memberCount) || other.memberCount == memberCount));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,name,contributionAmount,memberCount);
}

@override
String toString() {
    return 'Stokvel(id: $id, name: $name, contributionAmount: $contributionAmount, memberCount: $memberCount)';
}


}

/// @nodoc
abstract mixin class _$StokvelCopyWith<$Res> implements $StokvelCopyWith<$Res> {
  factory _$StokvelCopyWith(_Stokvel value, $Res Function(_Stokvel) _then) = __$StokvelCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, Cents contributionAmount, int memberCount
});




}
/// @nodoc
class __$StokvelCopyWithImpl<$Res>
    implements _$StokvelCopyWith<$Res> {
  __$StokvelCopyWithImpl(this._self, this._then);

  final _Stokvel _self;
  final $Res Function(_Stokvel) _then;

/// Create a copy of Stokvel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? contributionAmount = null,Object? memberCount = null,}) {
  return _then(_Stokvel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,contributionAmount: null == contributionAmount ? _self.contributionAmount : contributionAmount // ignore: cast_nullable_to_non_nullable
as Cents,memberCount: null == memberCount ? _self.memberCount : memberCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc
mixin _$Cycle {

 int get id; int get stokvelId; int get number; CycleStatus get status; DateTime get dueDateUtc; Cents get targetAmount; Cents get requiredContribution;
/// Create a copy of Cycle
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CycleCopyWith<Cycle> get copyWith => _$CycleCopyWithImpl<Cycle>(this as Cycle, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Cycle;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Cycle&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.stokvelId, _this.stokvelId) || other.stokvelId == _this.stokvelId)&&(identical(other.number, _this.number) || other.number == _this.number)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.dueDateUtc, _this.dueDateUtc) || other.dueDateUtc == _this.dueDateUtc)&&(identical(other.targetAmount, _this.targetAmount) || other.targetAmount == _this.targetAmount)&&(identical(other.requiredContribution, _this.requiredContribution) || other.requiredContribution == _this.requiredContribution));
}


@override
int get hashCode {
  final _this = this as Cycle;
  return Object.hash(runtimeType,_this.id,_this.stokvelId,_this.number,_this.status,_this.dueDateUtc,_this.targetAmount,_this.requiredContribution);
}

@override
String toString() {
  final _this = this as Cycle;
  return 'Cycle(id: ${_this.id}, stokvelId: ${_this.stokvelId}, number: ${_this.number}, status: ${_this.status}, dueDateUtc: ${_this.dueDateUtc}, targetAmount: ${_this.targetAmount}, requiredContribution: ${_this.requiredContribution})';
}


}

/// @nodoc
abstract mixin class $CycleCopyWith<$Res>  {
  factory $CycleCopyWith(Cycle value, $Res Function(Cycle) _then) = _$CycleCopyWithImpl;
@useResult
$Res call({
 int id, int stokvelId, int number, CycleStatus status, DateTime dueDateUtc, Cents targetAmount, Cents requiredContribution
});




}
/// @nodoc
class _$CycleCopyWithImpl<$Res>
    implements $CycleCopyWith<$Res> {
  _$CycleCopyWithImpl(this._self, this._then);

  final Cycle _self;
  final $Res Function(Cycle) _then;

/// Create a copy of Cycle
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? stokvelId = null,Object? number = null,Object? status = null,Object? dueDateUtc = null,Object? targetAmount = null,Object? requiredContribution = null,}) {
  return _then(Cycle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CycleStatus,dueDateUtc: null == dueDateUtc ? _self.dueDateUtc : dueDateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as Cents,requiredContribution: null == requiredContribution ? _self.requiredContribution : requiredContribution // ignore: cast_nullable_to_non_nullable
as Cents,
  ));
}

}


/// Adds pattern-matching-related methods to [Cycle].
extension CyclePatterns on Cycle {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Cycle value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Cycle() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Cycle value)  $default,){
final _that = this;
switch (_that) {
case _Cycle():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Cycle value)?  $default,){
final _that = this;
switch (_that) {
case _Cycle() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int stokvelId,  int number,  CycleStatus status,  DateTime dueDateUtc,  Cents targetAmount,  Cents requiredContribution)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Cycle() when $default != null:
return $default(_that.id,_that.stokvelId,_that.number,_that.status,_that.dueDateUtc,_that.targetAmount,_that.requiredContribution);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int stokvelId,  int number,  CycleStatus status,  DateTime dueDateUtc,  Cents targetAmount,  Cents requiredContribution)  $default,) {final _that = this;
switch (_that) {
case _Cycle():
return $default(_that.id,_that.stokvelId,_that.number,_that.status,_that.dueDateUtc,_that.targetAmount,_that.requiredContribution);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int stokvelId,  int number,  CycleStatus status,  DateTime dueDateUtc,  Cents targetAmount,  Cents requiredContribution)?  $default,) {final _that = this;
switch (_that) {
case _Cycle() when $default != null:
return $default(_that.id,_that.stokvelId,_that.number,_that.status,_that.dueDateUtc,_that.targetAmount,_that.requiredContribution);case _:
  return null;

}
}

}

/// @nodoc


class _Cycle implements Cycle {
  const _Cycle({required this.id, required this.stokvelId, required this.number, required this.status, required this.dueDateUtc, required this.targetAmount, required this.requiredContribution});
  

@override final  int id;
@override final  int stokvelId;
@override final  int number;
@override final  CycleStatus status;
@override final  DateTime dueDateUtc;
@override final  Cents targetAmount;
@override final  Cents requiredContribution;

/// Create a copy of Cycle
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CycleCopyWith<_Cycle> get copyWith => __$CycleCopyWithImpl<_Cycle>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Cycle&&(identical(other.id, id) || other.id == id)&&(identical(other.stokvelId, stokvelId) || other.stokvelId == stokvelId)&&(identical(other.number, number) || other.number == number)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDateUtc, dueDateUtc) || other.dueDateUtc == dueDateUtc)&&(identical(other.targetAmount, targetAmount) || other.targetAmount == targetAmount)&&(identical(other.requiredContribution, requiredContribution) || other.requiredContribution == requiredContribution));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,stokvelId,number,status,dueDateUtc,targetAmount,requiredContribution);
}

@override
String toString() {
    return 'Cycle(id: $id, stokvelId: $stokvelId, number: $number, status: $status, dueDateUtc: $dueDateUtc, targetAmount: $targetAmount, requiredContribution: $requiredContribution)';
}


}

/// @nodoc
abstract mixin class _$CycleCopyWith<$Res> implements $CycleCopyWith<$Res> {
  factory _$CycleCopyWith(_Cycle value, $Res Function(_Cycle) _then) = __$CycleCopyWithImpl;
@override @useResult
$Res call({
 int id, int stokvelId, int number, CycleStatus status, DateTime dueDateUtc, Cents targetAmount, Cents requiredContribution
});




}
/// @nodoc
class __$CycleCopyWithImpl<$Res>
    implements _$CycleCopyWith<$Res> {
  __$CycleCopyWithImpl(this._self, this._then);

  final _Cycle _self;
  final $Res Function(_Cycle) _then;

/// Create a copy of Cycle
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? stokvelId = null,Object? number = null,Object? status = null,Object? dueDateUtc = null,Object? targetAmount = null,Object? requiredContribution = null,}) {
  return _then(_Cycle(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as int,number: null == number ? _self.number : number // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CycleStatus,dueDateUtc: null == dueDateUtc ? _self.dueDateUtc : dueDateUtc // ignore: cast_nullable_to_non_nullable
as DateTime,targetAmount: null == targetAmount ? _self.targetAmount : targetAmount // ignore: cast_nullable_to_non_nullable
as Cents,requiredContribution: null == requiredContribution ? _self.requiredContribution : requiredContribution // ignore: cast_nullable_to_non_nullable
as Cents,
  ));
}


}

/// @nodoc
mixin _$Contribution {

 int get userId; int get stokvelId; int get cycleId; String get memberName; Cents get amount; ContributionStatus get status; DateTime? get paidAtUtc;
/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ContributionCopyWith<Contribution> get copyWith => _$ContributionCopyWithImpl<Contribution>(this as Contribution, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as Contribution;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Contribution&&(identical(other.userId, _this.userId) || other.userId == _this.userId)&&(identical(other.stokvelId, _this.stokvelId) || other.stokvelId == _this.stokvelId)&&(identical(other.cycleId, _this.cycleId) || other.cycleId == _this.cycleId)&&(identical(other.memberName, _this.memberName) || other.memberName == _this.memberName)&&(identical(other.amount, _this.amount) || other.amount == _this.amount)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.paidAtUtc, _this.paidAtUtc) || other.paidAtUtc == _this.paidAtUtc));
}


@override
int get hashCode {
  final _this = this as Contribution;
  return Object.hash(runtimeType,_this.userId,_this.stokvelId,_this.cycleId,_this.memberName,_this.amount,_this.status,_this.paidAtUtc);
}

@override
String toString() {
  final _this = this as Contribution;
  return 'Contribution(userId: ${_this.userId}, stokvelId: ${_this.stokvelId}, cycleId: ${_this.cycleId}, memberName: ${_this.memberName}, amount: ${_this.amount}, status: ${_this.status}, paidAtUtc: ${_this.paidAtUtc})';
}


}

/// @nodoc
abstract mixin class $ContributionCopyWith<$Res>  {
  factory $ContributionCopyWith(Contribution value, $Res Function(Contribution) _then) = _$ContributionCopyWithImpl;
@useResult
$Res call({
 int userId, int stokvelId, int cycleId, String memberName, Cents amount, ContributionStatus status, DateTime? paidAtUtc
});




}
/// @nodoc
class _$ContributionCopyWithImpl<$Res>
    implements $ContributionCopyWith<$Res> {
  _$ContributionCopyWithImpl(this._self, this._then);

  final Contribution _self;
  final $Res Function(Contribution) _then;

/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? userId = null,Object? stokvelId = null,Object? cycleId = null,Object? memberName = null,Object? amount = null,Object? status = null,Object? paidAtUtc = freezed,}) {
  return _then(Contribution(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContributionStatus,paidAtUtc: freezed == paidAtUtc ? _self.paidAtUtc : paidAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [Contribution].
extension ContributionPatterns on Contribution {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Contribution value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Contribution() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Contribution value)  $default,){
final _that = this;
switch (_that) {
case _Contribution():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Contribution value)?  $default,){
final _that = this;
switch (_that) {
case _Contribution() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int userId,  int stokvelId,  int cycleId,  String memberName,  Cents amount,  ContributionStatus status,  DateTime? paidAtUtc)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Contribution() when $default != null:
return $default(_that.userId,_that.stokvelId,_that.cycleId,_that.memberName,_that.amount,_that.status,_that.paidAtUtc);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int userId,  int stokvelId,  int cycleId,  String memberName,  Cents amount,  ContributionStatus status,  DateTime? paidAtUtc)  $default,) {final _that = this;
switch (_that) {
case _Contribution():
return $default(_that.userId,_that.stokvelId,_that.cycleId,_that.memberName,_that.amount,_that.status,_that.paidAtUtc);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int userId,  int stokvelId,  int cycleId,  String memberName,  Cents amount,  ContributionStatus status,  DateTime? paidAtUtc)?  $default,) {final _that = this;
switch (_that) {
case _Contribution() when $default != null:
return $default(_that.userId,_that.stokvelId,_that.cycleId,_that.memberName,_that.amount,_that.status,_that.paidAtUtc);case _:
  return null;

}
}

}

/// @nodoc


class _Contribution implements Contribution {
  const _Contribution({required this.userId, required this.stokvelId, required this.cycleId, required this.memberName, required this.amount, required this.status, this.paidAtUtc});
  

@override final  int userId;
@override final  int stokvelId;
@override final  int cycleId;
@override final  String memberName;
@override final  Cents amount;
@override final  ContributionStatus status;
@override final  DateTime? paidAtUtc;

/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ContributionCopyWith<_Contribution> get copyWith => __$ContributionCopyWithImpl<_Contribution>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Contribution&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.stokvelId, stokvelId) || other.stokvelId == stokvelId)&&(identical(other.cycleId, cycleId) || other.cycleId == cycleId)&&(identical(other.memberName, memberName) || other.memberName == memberName)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.status, status) || other.status == status)&&(identical(other.paidAtUtc, paidAtUtc) || other.paidAtUtc == paidAtUtc));
}


@override
int get hashCode {
    return Object.hash(runtimeType,userId,stokvelId,cycleId,memberName,amount,status,paidAtUtc);
}

@override
String toString() {
    return 'Contribution(userId: $userId, stokvelId: $stokvelId, cycleId: $cycleId, memberName: $memberName, amount: $amount, status: $status, paidAtUtc: $paidAtUtc)';
}


}

/// @nodoc
abstract mixin class _$ContributionCopyWith<$Res> implements $ContributionCopyWith<$Res> {
  factory _$ContributionCopyWith(_Contribution value, $Res Function(_Contribution) _then) = __$ContributionCopyWithImpl;
@override @useResult
$Res call({
 int userId, int stokvelId, int cycleId, String memberName, Cents amount, ContributionStatus status, DateTime? paidAtUtc
});




}
/// @nodoc
class __$ContributionCopyWithImpl<$Res>
    implements _$ContributionCopyWith<$Res> {
  __$ContributionCopyWithImpl(this._self, this._then);

  final _Contribution _self;
  final $Res Function(_Contribution) _then;

/// Create a copy of Contribution
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? userId = null,Object? stokvelId = null,Object? cycleId = null,Object? memberName = null,Object? amount = null,Object? status = null,Object? paidAtUtc = freezed,}) {
  return _then(_Contribution(
userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as int,stokvelId: null == stokvelId ? _self.stokvelId : stokvelId // ignore: cast_nullable_to_non_nullable
as int,cycleId: null == cycleId ? _self.cycleId : cycleId // ignore: cast_nullable_to_non_nullable
as int,memberName: null == memberName ? _self.memberName : memberName // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Cents,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ContributionStatus,paidAtUtc: freezed == paidAtUtc ? _self.paidAtUtc : paidAtUtc // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

/// @nodoc
mixin _$StokvelDetail {

 Stokvel get stokvel; Membership get membership; int get callerId; List<Contribution> get contributions; Cycle? get currentCycle;
/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StokvelDetailCopyWith<StokvelDetail> get copyWith => _$StokvelDetailCopyWithImpl<StokvelDetail>(this as StokvelDetail, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as StokvelDetail;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StokvelDetail&&(identical(other.stokvel, _this.stokvel) || other.stokvel == _this.stokvel)&&(identical(other.membership, _this.membership) || other.membership == _this.membership)&&(identical(other.callerId, _this.callerId) || other.callerId == _this.callerId)&&const DeepCollectionEquality().equals(other.contributions, _this.contributions)&&(identical(other.currentCycle, _this.currentCycle) || other.currentCycle == _this.currentCycle));
}


@override
int get hashCode {
  final _this = this as StokvelDetail;
  return Object.hash(runtimeType,_this.stokvel,_this.membership,_this.callerId,const DeepCollectionEquality().hash(_this.contributions),_this.currentCycle);
}

@override
String toString() {
  final _this = this as StokvelDetail;
  return 'StokvelDetail(stokvel: ${_this.stokvel}, membership: ${_this.membership}, callerId: ${_this.callerId}, contributions: ${_this.contributions}, currentCycle: ${_this.currentCycle})';
}


}

/// @nodoc
abstract mixin class $StokvelDetailCopyWith<$Res>  {
  factory $StokvelDetailCopyWith(StokvelDetail value, $Res Function(StokvelDetail) _then) = _$StokvelDetailCopyWithImpl;
@useResult
$Res call({
 Stokvel stokvel, Membership membership, int callerId, List<Contribution> contributions, Cycle? currentCycle
});


$StokvelCopyWith<$Res> get stokvel;$MembershipCopyWith<$Res> get membership;$CycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class _$StokvelDetailCopyWithImpl<$Res>
    implements $StokvelDetailCopyWith<$Res> {
  _$StokvelDetailCopyWithImpl(this._self, this._then);

  final StokvelDetail _self;
  final $Res Function(StokvelDetail) _then;

/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? stokvel = null,Object? membership = null,Object? callerId = null,Object? contributions = null,Object? currentCycle = freezed,}) {
  return _then(StokvelDetail(
stokvel: null == stokvel ? _self.stokvel : stokvel // ignore: cast_nullable_to_non_nullable
as Stokvel,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,callerId: null == callerId ? _self.callerId : callerId // ignore: cast_nullable_to_non_nullable
as int,contributions: null == contributions ? _self.contributions : contributions // ignore: cast_nullable_to_non_nullable
as List<Contribution>,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as Cycle?,
  ));
}
/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCopyWith<$Res> get stokvel {
  
  return $StokvelCopyWith<$Res>(_self.stokvel, (value) {
    return _then(_self.copyWith(stokvel: value));
  });
}/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $CycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}


/// Adds pattern-matching-related methods to [StokvelDetail].
extension StokvelDetailPatterns on StokvelDetail {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StokvelDetail value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StokvelDetail() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StokvelDetail value)  $default,){
final _that = this;
switch (_that) {
case _StokvelDetail():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StokvelDetail value)?  $default,){
final _that = this;
switch (_that) {
case _StokvelDetail() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Stokvel stokvel,  Membership membership,  int callerId,  List<Contribution> contributions,  Cycle? currentCycle)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StokvelDetail() when $default != null:
return $default(_that.stokvel,_that.membership,_that.callerId,_that.contributions,_that.currentCycle);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Stokvel stokvel,  Membership membership,  int callerId,  List<Contribution> contributions,  Cycle? currentCycle)  $default,) {final _that = this;
switch (_that) {
case _StokvelDetail():
return $default(_that.stokvel,_that.membership,_that.callerId,_that.contributions,_that.currentCycle);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Stokvel stokvel,  Membership membership,  int callerId,  List<Contribution> contributions,  Cycle? currentCycle)?  $default,) {final _that = this;
switch (_that) {
case _StokvelDetail() when $default != null:
return $default(_that.stokvel,_that.membership,_that.callerId,_that.contributions,_that.currentCycle);case _:
  return null;

}
}

}

/// @nodoc


class _StokvelDetail implements StokvelDetail {
  const _StokvelDetail({required this.stokvel, required this.membership, required this.callerId, required  List<Contribution> contributions, this.currentCycle}): _contributions = contributions;
  

@override final  Stokvel stokvel;
@override final  Membership membership;
@override final  int callerId;
 final  List<Contribution> _contributions;
@override List<Contribution> get contributions {
  if (_contributions is EqualUnmodifiableListView) return _contributions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contributions);
}

@override final  Cycle? currentCycle;

/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StokvelDetailCopyWith<_StokvelDetail> get copyWith => __$StokvelDetailCopyWithImpl<_StokvelDetail>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _StokvelDetail&&(identical(other.stokvel, stokvel) || other.stokvel == stokvel)&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.callerId, callerId) || other.callerId == callerId)&&const DeepCollectionEquality().equals(other.contributions, _contributions)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle));
}


@override
int get hashCode {
    return Object.hash(runtimeType,stokvel,membership,callerId,const DeepCollectionEquality().hash(_contributions),currentCycle);
}

@override
String toString() {
    return 'StokvelDetail(stokvel: $stokvel, membership: $membership, callerId: $callerId, contributions: $contributions, currentCycle: $currentCycle)';
}


}

/// @nodoc
abstract mixin class _$StokvelDetailCopyWith<$Res> implements $StokvelDetailCopyWith<$Res> {
  factory _$StokvelDetailCopyWith(_StokvelDetail value, $Res Function(_StokvelDetail) _then) = __$StokvelDetailCopyWithImpl;
@override @useResult
$Res call({
 Stokvel stokvel, Membership membership, int callerId, List<Contribution> contributions, Cycle? currentCycle
});


@override $StokvelCopyWith<$Res> get stokvel;@override $MembershipCopyWith<$Res> get membership;@override $CycleCopyWith<$Res>? get currentCycle;

}
/// @nodoc
class __$StokvelDetailCopyWithImpl<$Res>
    implements _$StokvelDetailCopyWith<$Res> {
  __$StokvelDetailCopyWithImpl(this._self, this._then);

  final _StokvelDetail _self;
  final $Res Function(_StokvelDetail) _then;

/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? stokvel = null,Object? membership = null,Object? callerId = null,Object? contributions = null,Object? currentCycle = freezed,}) {
  return _then(_StokvelDetail(
stokvel: null == stokvel ? _self.stokvel : stokvel // ignore: cast_nullable_to_non_nullable
as Stokvel,membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,callerId: null == callerId ? _self.callerId : callerId // ignore: cast_nullable_to_non_nullable
as int,contributions: null == contributions ? _self._contributions : contributions // ignore: cast_nullable_to_non_nullable
as List<Contribution>,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as Cycle?,
  ));
}

/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StokvelCopyWith<$Res> get stokvel {
  
  return $StokvelCopyWith<$Res>(_self.stokvel, (value) {
    return _then(_self.copyWith(stokvel: value));
  });
}/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}/// Create a copy of StokvelDetail
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CycleCopyWith<$Res>? get currentCycle {
    if (_self.currentCycle == null) {
    return null;
  }

  return $CycleCopyWith<$Res>(_self.currentCycle!, (value) {
    return _then(_self.copyWith(currentCycle: value));
  });
}
}

// dart format on
