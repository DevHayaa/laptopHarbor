import 'package:flutter/material.dart';
import 'package:laptop_harbor/components/Banner/S/banner_s_style_1.dart';
import 'package:laptop_harbor/constants.dart';
import 'package:laptop_harbor/route/screen_export.dart';

import 'components/best_sellers.dart';
import 'components/most_popular.dart';
import 'components/offer_carousel_and_categories.dart';
import 'components/popular_products.dart';
import 'components/all_products_slider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            const SliverToBoxAdapter(child: OffersCarouselAndCategories()),
            const SliverToBoxAdapter(child: AllProductsSlider()),
            const SliverToBoxAdapter(child: MostPopularDynamic()),

            const SliverToBoxAdapter(child: SizedBox(height: 16)),

            SliverToBoxAdapter(
              child: Column(
                children: [
                  BannerSStyle1(
                    title: "On Sale",
                    subtitle: "SPECIAL OFFER",
                    discountParcent: 50,
                    press: () {
                      Navigator.pushNamed(context, onSaleScreenRoute);
                    },
                  ),
                  const SizedBox(height: defaultPadding / 4),
                ],
              ),
            ),

            const SliverToBoxAdapter(child: BestSellersDynamic()),

            // Optional: Add MostPopularDynamic if needed
            // const SliverToBoxAdapter(child: MostPopularDynamic()),
          ],
        ),
      ),
    );
  }
}
