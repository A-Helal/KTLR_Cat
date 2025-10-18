import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../di/injection_container.dart';
import '../../features/cats/presentation/cubit/cats_cubit.dart';
import '../../features/cats/presentation/views/screens/cats_screen.dart';
import '../../features/breeds/presentation/cubit/breeds_cubit.dart';
import '../../features/breeds/presentation/views/screens/breeds_screen.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';
import '../../features/favorites/presentation/views/screens/favorites_screen.dart';

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          BlocProvider(
            create: (_) => sl<CatsCubit>()..getCatsList(),
            child: const CatsScreen(),
          ),
          BlocProvider(
            create: (_) => sl<BreedsCubit>()..getBreeds(),
            child: const BreedsScreen(),
          ),
          BlocProvider(
            create: (_) => sl<FavoritesCubit>()..getFavorites(),
            child: const FavoritesScreen(),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavItem(Icons.pets_outlined, Icons.pets, 0),
                _buildNavItem(Icons.category_outlined, Icons.category, 1),
                _buildNavItem(Icons.favorite_outline, Icons.favorite, 2),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, IconData activeIcon, int index) {
    final isSelected = _currentIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              isSelected
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          isSelected ? activeIcon : icon,
          color: isSelected ? AppColors.primary : AppColors.iconGrey,
          size: 26,
        ),
      ),
    );
  }
}
