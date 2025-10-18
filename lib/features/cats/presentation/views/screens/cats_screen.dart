import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/shared_widgets/custom_button.dart';
import '../../../../../core/shared_widgets/loading_widget.dart';
import '../../../../../core/shared_widgets/error_display_widget.dart';
import '../../cubit/cats_cubit.dart';
import '../widgets/cat_item_card.dart';

class CatsScreen extends StatelessWidget {
  const CatsScreen({super.key});

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
              child: BlocBuilder<CatsCubit, CatsState>(
                builder: (context, state) {
                  return switch (state) {
                    CatsLoading() => const LoadingWidget(),
                    CatsListLoaded() => _buildCatsList(context, state),
                    CatsError() => ErrorDisplayWidget(
                        message: state.message,
                        onRetry: () => context.read<CatsCubit>().getCatsList(),
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
        'Random Cats',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildCatsList(BuildContext context, CatsListLoaded state) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            itemCount: state.cats.length,
            itemBuilder: (context, index) {
              return CatItemCard(catImage: state.cats[index]);
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20),
          child: CustomButton(
            text: 'Get Another Cats',
            onPressed: () => context.read<CatsCubit>().getCatsList(),
          ),
        ),
      ],
    );
  }
}
