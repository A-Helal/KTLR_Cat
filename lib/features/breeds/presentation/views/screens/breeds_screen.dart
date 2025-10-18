import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/shared_widgets/loading_widget.dart';
import '../../../../../core/shared_widgets/empty_state_widget.dart';
import '../../../../../core/shared_widgets/error_display_widget.dart';
import '../../cubit/breeds_cubit.dart';
import '../widgets/breed_list_item.dart';

class BreedsScreen extends StatelessWidget {
  const BreedsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            _buildSearchBar(context),
            const SizedBox(height: 20),
            Expanded(
              child: BlocBuilder<BreedsCubit, BreedsState>(
                builder: (context, state) {
                  return switch (state) {
                    BreedsLoading() => const LoadingWidget(),
                    BreedsLoaded() => _buildBreedsList(context, state),
                    BreedsError() => ErrorDisplayWidget(
                        message: state.message,
                        onRetry: () => context
                            .read<BreedsCubit>()
                            .getBreeds(refresh: true),
                      ),
                    _ => const SizedBox.shrink(),
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
        'Cat Breeds',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Search breeds...',
          prefixIcon: const Icon(Icons.search, color: AppColors.iconGrey),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
        onChanged: (value) =>
            context.read<BreedsCubit>().searchBreeds(value),
      ),
    );
  }

  Widget _buildBreedsList(BuildContext context, BreedsLoaded state) {
    if (state.breeds.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.search_off,
        title: 'No breeds found',
        subtitle: 'Try searching for something else',
        actionText: 'View All Breeds',
        onActionPressed: () =>
            context.read<BreedsCubit>().getBreeds(refresh: true),
      );
    }

    return RefreshIndicator(
      onRefresh: () => context.read<BreedsCubit>().getBreeds(refresh: true),
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: state.breeds.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == state.breeds.length) {
            context.read<BreedsCubit>().loadMore();
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          return BreedListItem(breed: state.breeds[index]);
        },
      ),
    );
  }
}
