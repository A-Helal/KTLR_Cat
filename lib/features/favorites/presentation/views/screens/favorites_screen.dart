import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/shared_widgets/loading_widget.dart';
import '../../../../../core/shared_widgets/empty_state_widget.dart';
import '../../../../../core/shared_widgets/error_display_widget.dart';
import '../../../../../core/shared_widgets/cached_image_wrapper.dart';
import '../../cubit/favorites_cubit.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            Expanded(
              child: BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  return switch (state) {
                    FavoritesLoading() => const LoadingWidget(),
                    FavoritesLoaded() => _buildFavoritesList(context, state),
                    FavoritesError() => ErrorDisplayWidget(
                        message: state.message,
                        onRetry: () =>
                            context.read<FavoritesCubit>().getFavorites(),
                      ),
                    _ => const LoadingWidget(),
                  };
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return const Padding(
      padding: EdgeInsets.all(20),
      child: Text(
        'My Favorites',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildFavoritesList(BuildContext context, FavoritesLoaded state) {
    if (state.favorites.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.favorite_border,
        title: 'No favorites yet',
        subtitle: 'Start adding your favorite cats!',
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<FavoritesCubit>().getFavorites(),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.75,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
        ),
        itemCount: state.favorites.length,
        itemBuilder: (context, index) {
          final favorite = state.favorites[index];
          final imageUrl = favorite.image?.url ?? '';

          return _buildFavoriteCard(context, favorite, imageUrl);
        },
      ),
    );
  }

  Widget _buildFavoriteCard(
    BuildContext context,
    dynamic favorite,
    String imageUrl,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          CachedImageWrapper(
            imageUrl: imageUrl,
            width: double.infinity,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(16),
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: () => _removeFavorite(context, favorite),
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _removeFavorite(BuildContext context, dynamic favorite) async {
    if (favorite.id != null) {
      final success = await context
          .read<FavoritesCubit>()
          .removeFromFavorites(favorite.id!);
      
      if (success && context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Removed from favorites'),
            backgroundColor: AppColors.locationRed,
            duration: Duration(seconds: 2),
          ),
        );
      }
    }
  }
}
