import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:groceryapp/features/cart/ui/cart.dart';
import 'package:groceryapp/features/home/ui/product_tile_widget.dart';
import 'package:groceryapp/features/wishlist/ui/wishlist.dart';

import '../bloc/home_bloc.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    homeBloc.add(HomeInitialEvent());
    super.initState();
  }

  final HomeBloc homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<HomeBloc, HomeState>(
      bloc: homeBloc,
      listenWhen: (previous, current) => current is HomeActionState,
      buildWhen: (previous, current) => current is! HomeActionState,
      listener: (context, state) {
        if (state is HomeNavigateToCartPageActionState) {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => const Cart()));
        } else if (state is HomeNavigateToWishlistPageActionState) {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const Wishlist()));
        } else if (state is HomeProductItemCartedActionState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Item Carted')));
        } else if (state is HomeProductItemWishlistedActionState) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text('Item Wishlisted')));
        } else if (state is HomeProductItemCartedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Your item has been added to the Cart')));
        } else if (state is HomeProductItemWishlistedActionState) {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
              content: Text('Your item has been added to the Wishlist')));
        }
      },
      builder: (context, state) {
        if (state.runtimeType == HomeLoadingState) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (state.runtimeType == HomeLoadedSuccessState) {
          final successState = state as HomeLoadedSuccessState;
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.teal,
              title: const Text('Grocery App'),
              actions: [
                IconButton(
                  onPressed: () {
                    homeBloc.add(HomeWishlistButtonNavigateEvent());
                  },
                  icon: const Icon(Icons.favorite_border),
                ),
                IconButton(
                  onPressed: () {
                    homeBloc.add(HomeCartButtonNavigateEvent());
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                ),
              ],
            ),
            body: ListView.builder(
              itemCount: successState.products.length,
              itemBuilder: (context, index) {
                return ProductTileWidget(
                  homeBloc: homeBloc,
                  productDataModel: successState.products[index],
                );
              },
            ),
          );
        } else if (state.runtimeType == HomeErrorState) {
          return const Scaffold(
            body: Center(
              child: Text('Error'),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }
}
