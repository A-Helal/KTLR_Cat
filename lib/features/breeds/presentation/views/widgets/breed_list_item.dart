import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/shared_widgets/favorite_button.dart';
import '../../../data/models/breed_model.dart';
import '../screens/breed_detail_screen.dart';

class BreedListItem extends StatelessWidget {
  final BreedModel breed;

  const BreedListItem({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    final imageId = breed.referenceImageId ?? '0XYvRd7oD';
    final imageUrl = imageId.toImageUrl();

    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BreedDetailScreen(breed: breed),
        ),
      ),
      child: Hero(
        tag: 'breed_${breed.id}',
        child: Material(
          color: Colors.transparent,
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
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
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildImage(imageUrl),
                const SizedBox(width: 12),
                Expanded(child: _buildBreedInfo()),
                const SizedBox(width: 8),
                FavoriteButton(imageId: imageId),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildImage(String imageUrl) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Image.network(
        imageUrl,
        width: 64,
        height: 64,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: 64,
          height: 64,
          color: const Color(0xFFF2F2F2),
          child: const Icon(Icons.pets, color: AppColors.primary),
        ),
      ),
    );
  }

  Widget _buildBreedInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          breed.name,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        if (breed.origin != null || breed.lifeSpan != null) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              if (breed.origin != null) ...[
                const Icon(
                  Icons.location_on,
                  size: 14,
                  color: AppColors.locationRed,
                ),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    breed.origin!,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
              if (breed.lifeSpan != null) ...[
                const SizedBox(width: 12),
                const Icon(
                  Icons.access_time,
                  size: 14,
                  color: AppColors.iconGrey,
                ),
                const SizedBox(width: 4),
                Text(
                  '${breed.lifeSpan} years',
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ],
          ),
        ],
        if (breed.temperament != null) ...[
          const SizedBox(height: 6),
          Text(
            breed.temperament!,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
