import 'package:flutter/material.dart';

import '../components/tabbed_navigator.dart';
import '../utils/assets.dart';
import '../utils/navigation.dart';
import '../utils/theme.dart';
import 'home_screen/home_screen.dart';
import 'profile_screen/profile_screen.dart';

enum TabItem {
  home,
  profile;

  Widget get icon {
    switch (this) {
      case TabItem.home:
        return AppIcons.home.svgPicture();
      case TabItem.profile:
        return AppIcons.profile.svgPicture();
    }
  }

  Widget get filledIcon {
    switch (this) {
      case TabItem.home:
        return AppIcons.home.svgPicture(color: AppColors.blueColor);
      case TabItem.profile:
        return AppIcons.profile.svgPicture(color: AppColors.blueColor);
    }
  }
}

final MaterialTabController tabController = MaterialTabController();

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  static const TabItem mainTab = TabItem.home;

  final tabNavigatorKeys = List<GlobalKey<NavigatorState>>.generate(
    TabItem.values.length,
    (index) => GlobalKey(),
    growable: false,
  );

  void onSelectedTab(TabItem newSelected) {
    final oldValue = TabItem.values[tabController.index];
    if (oldValue == newSelected) {
      final navigatorState = tabNavigatorKeys[newSelected.index].currentState;

      if (navigatorState == null) {
        return;
      }

      if (navigatorState.isCurrentRouteFirst()) {
        onTabReselectedInFirstRoute(newSelected);
      } else {
        //pop to first route
        navigatorState.popUntil((route) => route.isFirst);
      }
    } else {
      tabController.index = newSelected.index;
    }
  }

  void onTabReselectedInFirstRoute(TabItem tabItem) {}

  Future<bool> onWillPop() async {
    final tabIndex = tabController.index;
    final currentTab = TabItem.values[tabIndex];
    final navigatorState = tabNavigatorKeys[tabIndex].currentState;

    if (navigatorState == null) {
      //let system handle back button
      return true;
    }

    final isFirstRouteInCurrentTab = !(await navigatorState.maybePop());
    if (isFirstRouteInCurrentTab) {
      //if not on the 'main' tab
      if (currentTab != mainTab) {
        //select 'main' tab
        tabController.index = mainTab.index;
        //back button handled by app
        return false;
      }
    }
    //let system handle back button if we're on the first route
    return isFirstRouteInCurrentTab;
  }

  Widget buildTabWidget(BuildContext context, int index) {
    final tab = TabItem.values[index];
    final Widget child;
    switch (tab) {
      case TabItem.home:
        child = const HomeScreen();
        break;
      case TabItem.profile:
        child = const ProfileScreen();
        break;
    }
    return MaterialTabView(
      navigatorKey: tabNavigatorKeys[index],
      builder: (context) => child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        extendBody: true,
        body: MaterialTabNavigator(
          tabBuilder: buildTabWidget,
          controller: tabController,
          tabCount: TabItem.values.length,
        ),
        bottomNavigationBar: AnimatedBuilder(
          animation: tabController,
          builder: (context, child) => BottomNavigation(
            currentTab: TabItem.values[tabController.index],
            onSelectTab: onSelectedTab,
          ),
        ),
      ),
    );
  }
}

class BottomNavigation extends StatelessWidget {
  const BottomNavigation({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;

  @override
  Widget build(BuildContext context) {
    final tabItems = <Widget>[];
    for (final tab in TabItem.values) {
      final itemWidget = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => onSelectTab(tab),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 14),
            if (currentTab == tab) tab.filledIcon else tab.icon,
            const SizedBox(height: 16),
          ],
        ),
      );
      tabItems.add(itemWidget);
    }

    final double additionalBottomPadding = MediaQuery.of(context).padding.bottom;

    return Container(
      height: 75,
      decoration: const BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.12),
            blurRadius: 6,
          ),
        ],
        border: Border(top: BorderSide(color: AppColors.greyColor)),
        color: AppColors.darkColor,
      ),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          minHeight: kBottomNavigationBarHeight + additionalBottomPadding,
        ),
        child: Padding(
          padding: EdgeInsets.only(bottom: additionalBottomPadding),
          child: MediaQuery.removePadding(
            context: context,
            removeBottom: true,
            child: Row(
              children: tabItems //
                  .map((child) => Expanded(child: child))
                  .toList(growable: false),
            ),
          ),
        ),
      ),
    );
  }
}
