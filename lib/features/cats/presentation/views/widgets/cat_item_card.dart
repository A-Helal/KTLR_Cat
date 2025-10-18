import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/shared_widgets/cached_image_wrapper.dart';
import '../../../../../core/shared_widgets/favorite_button.dart';
import '../../../../breeds/presentation/views/screens/breed_detail_screen.dart';
import '../../../data/models/cat_image_model.dart';

class CatItemCard extends StatelessWidget {
  final CatImageModel catImage;

  const CatItemCard({super.key, required this.catImage});

  @override
  Widget build(BuildContext context) {
    final breed =
        catImage.breeds?.isNotEmpty == true ? catImage.breeds!.first : null;

    return GestureDetector(
      onTap:
          breed != null
              ? () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => BreedDetailScreen(breed: breed),
                ),
              )
              : null,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageSection(),
            if (breed != null) _buildBreedInfo(breed),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection() {
    return Stack(
      children: [
        CachedImageWrapper(
          imageUrl: catImage.url,
          height: 300,
          width: double.infinity,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        Positioned(
          top: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: FavoriteButton(imageId: catImage.id),
          ),
        ),
      ],
    );
  }

  Widget _buildBreedInfo(dynamic breed) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            breed.name ?? '',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          if (breed.origin != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                const Icon(
                  Icons.location_on,
                  size: 16,
                  color: AppColors.locationRed,
                ),
                const SizedBox(width: 4),
                Text(
                  breed.origin!,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
          if (breed.temperament != null) ...[
            const SizedBox(height: 12),
            Text(
              breed.temperament!,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (breed.description != null) ...[
            const SizedBox(height: 12),
            Text(
              breed.description!,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ],
      ),
    );
  }
}
