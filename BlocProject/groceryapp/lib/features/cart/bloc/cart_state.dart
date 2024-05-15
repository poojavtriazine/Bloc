part of 'cart_bloc.dart';

@immutable
abstract class CartState {}

class CartInitial extends CartState {}

class CartActionState extends CartState {}

class CartSuccessState extends CartState {
  final List<ProductDataModel> cartItems;
  CartSuccessState({required this.cartItems});
}
