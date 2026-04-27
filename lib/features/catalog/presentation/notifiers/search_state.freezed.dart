// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'search_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SearchState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState()';
}


}

/// @nodoc
class $SearchStateCopyWith<$Res>  {
$SearchStateCopyWith(SearchState _, $Res Function(SearchState) __);
}


/// Adds pattern-matching-related methods to [SearchState].
extension SearchStatePatterns on SearchState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( SearchStateInitial value)?  initial,TResult Function( SearchStateLoading value)?  loading,TResult Function( SearchStateResults value)?  results,TResult Function( SearchStateEmpty value)?  empty,TResult Function( SearchStateError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case SearchStateInitial() when initial != null:
return initial(_that);case SearchStateLoading() when loading != null:
return loading(_that);case SearchStateResults() when results != null:
return results(_that);case SearchStateEmpty() when empty != null:
return empty(_that);case SearchStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( SearchStateInitial value)  initial,required TResult Function( SearchStateLoading value)  loading,required TResult Function( SearchStateResults value)  results,required TResult Function( SearchStateEmpty value)  empty,required TResult Function( SearchStateError value)  error,}){
final _that = this;
switch (_that) {
case SearchStateInitial():
return initial(_that);case SearchStateLoading():
return loading(_that);case SearchStateResults():
return results(_that);case SearchStateEmpty():
return empty(_that);case SearchStateError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( SearchStateInitial value)?  initial,TResult? Function( SearchStateLoading value)?  loading,TResult? Function( SearchStateResults value)?  results,TResult? Function( SearchStateEmpty value)?  empty,TResult? Function( SearchStateError value)?  error,}){
final _that = this;
switch (_that) {
case SearchStateInitial() when initial != null:
return initial(_that);case SearchStateLoading() when loading != null:
return loading(_that);case SearchStateResults() when results != null:
return results(_that);case SearchStateEmpty() when empty != null:
return empty(_that);case SearchStateError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<ProductEntity> products)?  results,TResult Function( String query)?  empty,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case SearchStateInitial() when initial != null:
return initial();case SearchStateLoading() when loading != null:
return loading();case SearchStateResults() when results != null:
return results(_that.products);case SearchStateEmpty() when empty != null:
return empty(_that.query);case SearchStateError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<ProductEntity> products)  results,required TResult Function( String query)  empty,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case SearchStateInitial():
return initial();case SearchStateLoading():
return loading();case SearchStateResults():
return results(_that.products);case SearchStateEmpty():
return empty(_that.query);case SearchStateError():
return error(_that.message);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<ProductEntity> products)?  results,TResult? Function( String query)?  empty,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case SearchStateInitial() when initial != null:
return initial();case SearchStateLoading() when loading != null:
return loading();case SearchStateResults() when results != null:
return results(_that.products);case SearchStateEmpty() when empty != null:
return empty(_that.query);case SearchStateError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class SearchStateInitial implements SearchState {
  const SearchStateInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchStateInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState.initial()';
}


}




/// @nodoc


class SearchStateLoading implements SearchState {
  const SearchStateLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchStateLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'SearchState.loading()';
}


}




/// @nodoc


class SearchStateResults implements SearchState {
  const SearchStateResults(final  List<ProductEntity> products): _products = products;
  

 final  List<ProductEntity> _products;
 List<ProductEntity> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}


/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateResultsCopyWith<SearchStateResults> get copyWith => _$SearchStateResultsCopyWithImpl<SearchStateResults>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchStateResults&&const DeepCollectionEquality().equals(other._products, _products));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products));

@override
String toString() {
  return 'SearchState.results(products: $products)';
}


}

/// @nodoc
abstract mixin class $SearchStateResultsCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchStateResultsCopyWith(SearchStateResults value, $Res Function(SearchStateResults) _then) = _$SearchStateResultsCopyWithImpl;
@useResult
$Res call({
 List<ProductEntity> products
});




}
/// @nodoc
class _$SearchStateResultsCopyWithImpl<$Res>
    implements $SearchStateResultsCopyWith<$Res> {
  _$SearchStateResultsCopyWithImpl(this._self, this._then);

  final SearchStateResults _self;
  final $Res Function(SearchStateResults) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,}) {
  return _then(SearchStateResults(
null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<ProductEntity>,
  ));
}


}

/// @nodoc


class SearchStateEmpty implements SearchState {
  const SearchStateEmpty(this.query);
  

 final  String query;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateEmptyCopyWith<SearchStateEmpty> get copyWith => _$SearchStateEmptyCopyWithImpl<SearchStateEmpty>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchStateEmpty&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'SearchState.empty(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchStateEmptyCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchStateEmptyCopyWith(SearchStateEmpty value, $Res Function(SearchStateEmpty) _then) = _$SearchStateEmptyCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchStateEmptyCopyWithImpl<$Res>
    implements $SearchStateEmptyCopyWith<$Res> {
  _$SearchStateEmptyCopyWithImpl(this._self, this._then);

  final SearchStateEmpty _self;
  final $Res Function(SearchStateEmpty) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchStateEmpty(
null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SearchStateError implements SearchState {
  const SearchStateError(this.message);
  

 final  String message;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchStateErrorCopyWith<SearchStateError> get copyWith => _$SearchStateErrorCopyWithImpl<SearchStateError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchStateError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'SearchState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $SearchStateErrorCopyWith<$Res> implements $SearchStateCopyWith<$Res> {
  factory $SearchStateErrorCopyWith(SearchStateError value, $Res Function(SearchStateError) _then) = _$SearchStateErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SearchStateErrorCopyWithImpl<$Res>
    implements $SearchStateErrorCopyWith<$Res> {
  _$SearchStateErrorCopyWithImpl(this._self, this._then);

  final SearchStateError _self;
  final $Res Function(SearchStateError) _then;

/// Create a copy of SearchState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SearchStateError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
