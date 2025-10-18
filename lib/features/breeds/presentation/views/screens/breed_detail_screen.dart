import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/utils/extensions.dart';
import '../../../../../core/shared_widgets/favorite_button.dart';
import '../../../data/models/breed_model.dart';

class BreedDetailScreen extends StatelessWidget {
  final BreedModel breed;

  const BreedDetailScreen({super.key, required this.breed});

  @override
  Widget build(BuildContext context) {
    final imageId = breed.referenceImageId ?? '0XYvRd7oD';
    final imageUrl = imageId.toImageUrl();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Column(
        children: [
          _buildHeader(context, imageId, imageUrl),
          Expanded(
            child: _buildContent(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, String imageId, String imageUrl) {
    return Stack(
      children: [
        Hero(
          tag: 'breed_${breed.id}',
          child: Image.network(
            imageUrl,
            height: 400,
            width: double.infinity,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(
              height: 400,
              color: Colors.grey[200],
              child: const Icon(
                Icons.pets,
                size: 100,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
        SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildBackButton(context),
                FavoriteButton(
                  imageId: imageId,
                  filled: true,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: const BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
      ),
    );
  }

  Widget _buildContent() {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle(),
            const SizedBox(height: 24),
            _buildInfoCards(),
            const SizedBox(height: 24),
            if (breed.temperament != null) _buildSection(
              'Temperament:',
              breed.temperament!,
            ),
            if (breed.description != null) _buildSection(
              'About:',
              breed.description!,
            ),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          breed.name,
          style: const TextStyle(
            fontSize: 28,
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
      ],
    );
  }

  Widget _buildInfoCards() {
    return Row(
      children: [
        if (breed.lifeSpan != null)
          Expanded(child: _buildInfoCard('Life Span', breed.lifeSpan!)),
        if (breed.adaptability != null) ...[
          const SizedBox(width: 12),
          Expanded(
            child: _buildInfoCard('Adaptability', '${breed.adaptability}/5'),
          ),
        ],
        if (breed.affectionLevel != null) ...[
          const SizedBox(width: 12),
          Expanded(
            child: _buildInfoCard('Affection', '${breed.affectionLevel}/5'),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoCard(String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          content,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
