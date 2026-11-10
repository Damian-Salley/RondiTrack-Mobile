// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$HomeEntry {

 Membership get membership; String get stokvelName; Cents get paidThisCycle; Cents get stillOwes; Cents get arrears; Cents get totalCollected; int? get currentCycle; CycleStatus? get cycleStatus; DateTime? get nextPayoutDate;
/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$HomeEntryCopyWith<HomeEntry> get copyWith => _$HomeEntryCopyWithImpl<HomeEntry>(this as HomeEntry, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as HomeEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is HomeEntry&&(identical(other.membership, _this.membership) || other.membership == _this.membership)&&(identical(other.stokvelName, _this.stokvelName) || other.stokvelName == _this.stokvelName)&&(identical(other.paidThisCycle, _this.paidThisCycle) || other.paidThisCycle == _this.paidThisCycle)&&(identical(other.stillOwes, _this.stillOwes) || other.stillOwes == _this.stillOwes)&&(identical(other.arrears, _this.arrears) || other.arrears == _this.arrears)&&(identical(other.totalCollected, _this.totalCollected) || other.totalCollected == _this.totalCollected)&&(identical(other.currentCycle, _this.currentCycle) || other.currentCycle == _this.currentCycle)&&(identical(other.cycleStatus, _this.cycleStatus) || other.cycleStatus == _this.cycleStatus)&&(identical(other.nextPayoutDate, _this.nextPayoutDate) || other.nextPayoutDate == _this.nextPayoutDate));
}


@override
int get hashCode {
  final _this = this as HomeEntry;
  return Object.hash(runtimeType,_this.membership,_this.stokvelName,_this.paidThisCycle,_this.stillOwes,_this.arrears,_this.totalCollected,_this.currentCycle,_this.cycleStatus,_this.nextPayoutDate);
}

@override
String toString() {
  final _this = this as HomeEntry;
  return 'HomeEntry(membership: ${_this.membership}, stokvelName: ${_this.stokvelName}, paidThisCycle: ${_this.paidThisCycle}, stillOwes: ${_this.stillOwes}, arrears: ${_this.arrears}, totalCollected: ${_this.totalCollected}, currentCycle: ${_this.currentCycle}, cycleStatus: ${_this.cycleStatus}, nextPayoutDate: ${_this.nextPayoutDate})';
}


}

/// @nodoc
abstract mixin class $HomeEntryCopyWith<$Res>  {
  factory $HomeEntryCopyWith(HomeEntry value, $Res Function(HomeEntry) _then) = _$HomeEntryCopyWithImpl;
@useResult
$Res call({
 Membership membership, String stokvelName, Cents paidThisCycle, Cents stillOwes, Cents arrears, Cents totalCollected, int? currentCycle, CycleStatus? cycleStatus, DateTime? nextPayoutDate
});


$MembershipCopyWith<$Res> get membership;

}
/// @nodoc
class _$HomeEntryCopyWithImpl<$Res>
    implements $HomeEntryCopyWith<$Res> {
  _$HomeEntryCopyWithImpl(this._self, this._then);

  final HomeEntry _self;
  final $Res Function(HomeEntry) _then;

/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? membership = null,Object? stokvelName = null,Object? paidThisCycle = null,Object? stillOwes = null,Object? arrears = null,Object? totalCollected = null,Object? currentCycle = freezed,Object? cycleStatus = freezed,Object? nextPayoutDate = freezed,}) {
  return _then(HomeEntry(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,stokvelName: null == stokvelName ? _self.stokvelName : stokvelName // ignore: cast_nullable_to_non_nullable
as String,paidThisCycle: null == paidThisCycle ? _self.paidThisCycle : paidThisCycle // ignore: cast_nullable_to_non_nullable
as Cents,stillOwes: null == stillOwes ? _self.stillOwes : stillOwes // ignore: cast_nullable_to_non_nullable
as Cents,arrears: null == arrears ? _self.arrears : arrears // ignore: cast_nullable_to_non_nullable
as Cents,totalCollected: null == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as Cents,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as int?,cycleStatus: freezed == cycleStatus ? _self.cycleStatus : cycleStatus // ignore: cast_nullable_to_non_nullable
as CycleStatus?,nextPayoutDate: freezed == nextPayoutDate ? _self.nextPayoutDate : nextPayoutDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}
/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}


/// Adds pattern-matching-related methods to [HomeEntry].
extension HomeEntryPatterns on HomeEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _HomeEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _HomeEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _HomeEntry value)  $default,){
final _that = this;
switch (_that) {
case _HomeEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _HomeEntry value)?  $default,){
final _that = this;
switch (_that) {
case _HomeEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Membership membership,  String stokvelName,  Cents paidThisCycle,  Cents stillOwes,  Cents arrears,  Cents totalCollected,  int? currentCycle,  CycleStatus? cycleStatus,  DateTime? nextPayoutDate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _HomeEntry() when $default != null:
return $default(_that.membership,_that.stokvelName,_that.paidThisCycle,_that.stillOwes,_that.arrears,_that.totalCollected,_that.currentCycle,_that.cycleStatus,_that.nextPayoutDate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Membership membership,  String stokvelName,  Cents paidThisCycle,  Cents stillOwes,  Cents arrears,  Cents totalCollected,  int? currentCycle,  CycleStatus? cycleStatus,  DateTime? nextPayoutDate)  $default,) {final _that = this;
switch (_that) {
case _HomeEntry():
return $default(_that.membership,_that.stokvelName,_that.paidThisCycle,_that.stillOwes,_that.arrears,_that.totalCollected,_that.currentCycle,_that.cycleStatus,_that.nextPayoutDate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Membership membership,  String stokvelName,  Cents paidThisCycle,  Cents stillOwes,  Cents arrears,  Cents totalCollected,  int? currentCycle,  CycleStatus? cycleStatus,  DateTime? nextPayoutDate)?  $default,) {final _that = this;
switch (_that) {
case _HomeEntry() when $default != null:
return $default(_that.membership,_that.stokvelName,_that.paidThisCycle,_that.stillOwes,_that.arrears,_that.totalCollected,_that.currentCycle,_that.cycleStatus,_that.nextPayoutDate);case _:
  return null;

}
}

}

/// @nodoc


class _HomeEntry implements HomeEntry {
  const _HomeEntry({required this.membership, required this.stokvelName, required this.paidThisCycle, required this.stillOwes, required this.arrears, required this.totalCollected, this.currentCycle, this.cycleStatus, this.nextPayoutDate});
  

@override final  Membership membership;
@override final  String stokvelName;
@override final  Cents paidThisCycle;
@override final  Cents stillOwes;
@override final  Cents arrears;
@override final  Cents totalCollected;
@override final  int? currentCycle;
@override final  CycleStatus? cycleStatus;
@override final  DateTime? nextPayoutDate;

/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$HomeEntryCopyWith<_HomeEntry> get copyWith => __$HomeEntryCopyWithImpl<_HomeEntry>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _HomeEntry&&(identical(other.membership, membership) || other.membership == membership)&&(identical(other.stokvelName, stokvelName) || other.stokvelName == stokvelName)&&(identical(other.paidThisCycle, paidThisCycle) || other.paidThisCycle == paidThisCycle)&&(identical(other.stillOwes, stillOwes) || other.stillOwes == stillOwes)&&(identical(other.arrears, arrears) || other.arrears == arrears)&&(identical(other.totalCollected, totalCollected) || other.totalCollected == totalCollected)&&(identical(other.currentCycle, currentCycle) || other.currentCycle == currentCycle)&&(identical(other.cycleStatus, cycleStatus) || other.cycleStatus == cycleStatus)&&(identical(other.nextPayoutDate, nextPayoutDate) || other.nextPayoutDate == nextPayoutDate));
}


@override
int get hashCode {
    return Object.hash(runtimeType,membership,stokvelName,paidThisCycle,stillOwes,arrears,totalCollected,currentCycle,cycleStatus,nextPayoutDate);
}

@override
String toString() {
    return 'HomeEntry(membership: $membership, stokvelName: $stokvelName, paidThisCycle: $paidThisCycle, stillOwes: $stillOwes, arrears: $arrears, totalCollected: $totalCollected, currentCycle: $currentCycle, cycleStatus: $cycleStatus, nextPayoutDate: $nextPayoutDate)';
}


}

/// @nodoc
abstract mixin class _$HomeEntryCopyWith<$Res> implements $HomeEntryCopyWith<$Res> {
  factory _$HomeEntryCopyWith(_HomeEntry value, $Res Function(_HomeEntry) _then) = __$HomeEntryCopyWithImpl;
@override @useResult
$Res call({
 Membership membership, String stokvelName, Cents paidThisCycle, Cents stillOwes, Cents arrears, Cents totalCollected, int? currentCycle, CycleStatus? cycleStatus, DateTime? nextPayoutDate
});


@override $MembershipCopyWith<$Res> get membership;

}
/// @nodoc
class __$HomeEntryCopyWithImpl<$Res>
    implements _$HomeEntryCopyWith<$Res> {
  __$HomeEntryCopyWithImpl(this._self, this._then);

  final _HomeEntry _self;
  final $Res Function(_HomeEntry) _then;

/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? membership = null,Object? stokvelName = null,Object? paidThisCycle = null,Object? stillOwes = null,Object? arrears = null,Object? totalCollected = null,Object? currentCycle = freezed,Object? cycleStatus = freezed,Object? nextPayoutDate = freezed,}) {
  return _then(_HomeEntry(
membership: null == membership ? _self.membership : membership // ignore: cast_nullable_to_non_nullable
as Membership,stokvelName: null == stokvelName ? _self.stokvelName : stokvelName // ignore: cast_nullable_to_non_nullable
as String,paidThisCycle: null == paidThisCycle ? _self.paidThisCycle : paidThisCycle // ignore: cast_nullable_to_non_nullable
as Cents,stillOwes: null == stillOwes ? _self.stillOwes : stillOwes // ignore: cast_nullable_to_non_nullable
as Cents,arrears: null == arrears ? _self.arrears : arrears // ignore: cast_nullable_to_non_nullable
as Cents,totalCollected: null == totalCollected ? _self.totalCollected : totalCollected // ignore: cast_nullable_to_non_nullable
as Cents,currentCycle: freezed == currentCycle ? _self.currentCycle : currentCycle // ignore: cast_nullable_to_non_nullable
as int?,cycleStatus: freezed == cycleStatus ? _self.cycleStatus : cycleStatus // ignore: cast_nullable_to_non_nullable
as CycleStatus?,nextPayoutDate: freezed == nextPayoutDate ? _self.nextPayoutDate : nextPayoutDate // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

/// Create a copy of HomeEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MembershipCopyWith<$Res> get membership {
  
  return $MembershipCopyWith<$Res>(_self.membership, (value) {
    return _then(_self.copyWith(membership: value));
  });
}
}

// dart format on
