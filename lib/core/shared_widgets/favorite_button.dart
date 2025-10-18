import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../constants/app_colors.dart';
import '../di/injection_container.dart';
import '../../features/favorites/presentation/cubit/favorites_cubit.dart';

class FavoriteButton extends StatelessWidget {
  final String imageId;
  final bool filled;
  final double size;
  final Color? activeColor;
  final Color? inactiveColor;
  final VoidCallback? onSuccess;

  const FavoriteButton({
    super.key,
    required this.imageId,
    this.filled = false,
    this.size = 24,
    this.activeColor,
    this.inactiveColor,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      bloc: sl<FavoritesCubit>(),
      builder: (context, state) {
        final cubit = sl<FavoritesCubit>();
        final isFav = cubit.isFavorite(imageId);

        return GestureDetector(
          onTap: () => _handleTap(context, cubit, isFav),
          child: Container(
            padding: EdgeInsets.all(filled ? 8 : 0),
            decoration: filled
                ? BoxDecoration(
                    color: isFav ? AppColors.primary : Colors.white,
                    shape: BoxShape.circle,
                  )
                : null,
            child: Icon(
              isFav ? Icons.favorite : Icons.favorite_border,
              color: _getIconColor(isFav),
              size: size,
            ),
          ),
        );
      },
    );
  }

  Color _getIconColor(bool isFav) {
    if (filled) {
      return isFav ? Colors.white : (inactiveColor ?? AppColors.primary);
    }
    return isFav ? (activeColor ?? AppColors.primary) : (inactiveColor ?? AppColors.primary);
  }

  Future<void> _handleTap(
    BuildContext context,
    FavoritesCubit cubit,
    bool isFav,
  ) async {
    if (isFav) {
      final favoriteId = cubit.getFavoriteId(imageId);
      if (favoriteId != null) {
        final success = await cubit.removeFromFavorites(favoriteId);
        if (success && context.mounted) {
          _showSnackbar(context, 'Removed from favorites', AppColors.locationRed);
          onSuccess?.call();
        }
      }
    } else {
      final success = await cubit.addToFavorites(imageId);
      if (success && context.mounted) {
        _showSnackbar(context, 'Added to favorites!', AppColors.primary);
        onSuccess?.call();
      }
    }
  }

  void _showSnackbar(BuildContext context, String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: color,
        duration: const Duration(seconds: 2),
      ),
    );
  }
}


