import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './helpers/custom_route.dart';
import './screens/splash_screen.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/user_product_screen.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/product_detail_screen.dart';
import './screens/orders_screen.dart';

import './screens/products_overview_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
              create: null,
              update: (context, auth, previousProducts) => Products(
                  auth.token,
                  previousProducts == null ? [] : previousProducts.items,
                  auth.userId)),

          //ChangeNotifierProvider(create: (ctx) => Products()),
          ChangeNotifierProvider.value(
            value: Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: null,
              update: (context, auth, previousOrders) => Orders(
                  auth.token,
                  previousOrders == null ? [] : previousOrders.orders,
                  auth.userId))
          //ChangeNotifierProvider(create: (ctx) => Orders()),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
                pageTransitionsTheme: PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder()
                })),
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductScreen.routeName: (ctx) => UserProductScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen(),
              // ProductsOverviewScreen.routeName: (ctx) =>
              //   ProductsOverviewScreen()
            },
          ),
        ));
  }
}
