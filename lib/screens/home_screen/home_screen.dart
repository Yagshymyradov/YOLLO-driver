import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';

import '../../components/create_oreder_manually.dart';
import '../../data/response.dart';
import '../../providers.dart';
import '../../utils/assets.dart';
import '../../utils/theme.dart';
import 'order_tile.dart';

final ordersProvider = FutureProvider((ref) {
  final apiClient = ref.watch(apiClientProvider);
  return apiClient.getOrdersBox();
});

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final pagingController = PagingController<int?, OrdersBox>(
    firstPageKey: 1,
    invisibleItemsThreshold: 1,
  );

  Object? currentPageRequestToken;

  void fetchPage(int? page) {
    final requestToken = Object();
    currentPageRequestToken = requestToken;
    
    const LimitOrder = 10;

    ref
        .read(apiClientProvider)
        .getOrdersBox(
          page: page!,
          size: LimitOrder,
        )
        .then((response) {
      if (!identical(currentPageRequestToken, requestToken)) {
        return;
      }

      final newItems = response.boxes;
      final isLastPage = newItems!.isEmpty || newItems.length < LimitOrder;
      if (isLastPage) {
        pagingController.appendLastPage(newItems);
      } else {
        final newPageKey = page + 1;
        pagingController.appendPage(newItems, newPageKey);
      }
    }).catchError((dynamic e) {
      if (!identical(currentPageRequestToken, requestToken)) {
        return;
      }
      pagingController.error = e;
    });
  }

  @override
  void initState() {
    super.initState();
    pagingController.addPageRequestListener(fetchPage);
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    return Scaffold(
      appBar: AppBar(
        title: AppIcons.logo.svgPicture(),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          pagingController.refresh();
        },
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            const CreateOrderManually(),
            const SizedBox(height: 29),
            Text(
              'Paýlamaly ýükler',
              style: appThemeData.textTheme.displayMedium,
            ),
            const SizedBox(height: 20),
            PagedListView<int?, OrdersBox>.separated(
              physics: const ScrollPhysics(),
              shrinkWrap: true,
              pagingController: pagingController,
              builderDelegate: PagedChildBuilderDelegate(
                itemBuilder: (context, item, index) {
                  log(pagingController.error.toString());
                  return OrderTile(order: item);
                },
                // firstPageErrorIndicatorBuilder: (_) {
                //   return NoConnectionIndicator(
                //     onRetryTap: pagingController.refresh,
                //   );
                // },
                // noItemsFoundIndicatorBuilder: (_) => const NoProductsIndicator(),
                // firstPageProgressIndicatorBuilder: (_) => const LoadingIndicator(),
                // newPageErrorIndicatorBuilder: (_) => const LoadMoreIndicator(),
              ),
              separatorBuilder: (context, index) {
                return const Padding(padding: EdgeInsets.only(bottom: 16));
              },
            ),
          ],
        ),
      ),
    );
  }
}
