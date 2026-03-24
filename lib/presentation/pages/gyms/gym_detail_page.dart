import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/entities/gym_entity.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../blocs/saved_gyms/saved_gyms_cubit.dart';

/// Detailed gym view with Hero-animated banner, image gallery, amenity chips,
/// and a Save/Unsave FAB.
class GymDetailPage extends StatelessWidget {
  const GymDetailPage({super.key, required this.gym});

  final GymEntity gym;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ── Hero-animated collapsible app bar ───────────────────────────
          SliverAppBar(
            expandedHeight: 280,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                gym.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  shadows: [
                    Shadow(blurRadius: 4, color: Colors.black87),
                    Shadow(blurRadius: 12, color: Colors.black54),
                  ],
                ),
              ),
              background: Hero(
                tag: '${AppConstants.heroTagPrefix}${gym.id}',
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    gym.thumbnailUrl != null
                        ? CachedNetworkImage(
                            imageUrl: gym.thumbnailUrl!,
                            fit: BoxFit.cover,
                            placeholder: (ctx, url) => Container(
                              color: AppColors.primary.withAlpha(30),
                            ),
                            errorWidget: (ctx, url, err) => Container(
                              color: AppColors.primary.withAlpha(20),
                              child: const Icon(Icons.fitness_center,
                                  size: 64, color: AppColors.primary),
                            ),
                          )
                        : Container(
                            color: AppColors.primary.withAlpha(20),
                            child: const Icon(Icons.fitness_center,
                                size: 64, color: AppColors.primary),
                          ),
                    // Gradient scrim so title text is always legible.
                    const DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.45, 1.0],
                          colors: [Colors.transparent, Colors.black54],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          SliverToBoxAdapter(
            child: SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── District + Price row ──────────────────────────────
                    Row(
                      children: [
                        _DistrictBadge(district: gym.district),
                        const Spacer(),
                        _PriceBadge(price: gym.subscriptionPrice),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // ── Description ───────────────────────────────────────
                    Text(
                      'About',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gym.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.6,
                          ),
                    ),

                    // ── Amenities ─────────────────────────────────────────
                    if (gym.amenities.isNotEmpty) ...[
                      const SizedBox(height: 24),
                      Text(
                        'Amenities',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 8,
                        runSpacing: 6,
                        children: gym.amenities
                            .map((a) => Chip(
                                  label: Text(a),
                                  avatar: const Icon(Icons.check, size: 14),
                                ))
                            .toList(),
                      ),
                    ],

                    // ── Photo gallery ─────────────────────────────────────
                    if (gym.galleryUrls.length > 1) ...[
                      const SizedBox(height: 28),
                      Text(
                        'Photo Gallery',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                      const SizedBox(height: 12),
                      _GalleryCarousel(urls: gym.galleryUrls),
                    ],

                    const SizedBox(height: 80), // FAB spacing
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: BlocBuilder<SavedGymsCubit, SavedGymsState>(
        builder: (ctx, savedState) {
          final isSaved = savedState.isGymSaved(gym.id);
          final authState = ctx.read<AuthBloc>().state;
          final uid =
              authState is Authenticated ? authState.user.uid : '';

          return FloatingActionButton.extended(
            onPressed: () =>
                ctx.read<SavedGymsCubit>().toggleSaveGym(uid, gym.id),
            icon: Icon(isSaved ? Icons.bookmark : Icons.bookmark_border),
            label: Text(isSaved ? 'Saved' : 'Save Gym'),
          );
        },
      ),
    );
  }
}

// ── Private helper widgets ──────────────────────────────────────────────────

class _DistrictBadge extends StatelessWidget {
  const _DistrictBadge({required this.district});
  final String district;

  Color get _color {
    switch (district) {
      case 'Gasabo':
        return AppColors.gasaboChip;
      case 'Kicukiro':
        return AppColors.kicukiroChip;
      case 'Nyarugenge':
        return AppColors.nyarugengeChip;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: _color.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _color.withAlpha(80)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.location_on, size: 14, color: _color),
          const SizedBox(width: 4),
          Text(
            district,
            style: TextStyle(
              color: _color,
              fontWeight: FontWeight.w700,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  const _PriceBadge({required this.price});
  final double price;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.accent.withAlpha(30),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.accent.withAlpha(80)),
      ),
      child: RichText(
        text: TextSpan(
          children: [
            TextSpan(
              text: 'RWF ${price.toStringAsFixed(0)}',
              style: const TextStyle(
                color: AppColors.accent,
                fontWeight: FontWeight.w800,
                fontSize: 15,
              ),
            ),
            const TextSpan(
              text: '/mo',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 11,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal paged gallery of gym photos with dot indicators.
class _GalleryCarousel extends StatefulWidget {
  const _GalleryCarousel({required this.urls});
  final List<String> urls;

  @override
  State<_GalleryCarousel> createState() => _GalleryCarouselState();
}

class _GalleryCarouselState extends State<_GalleryCarousel> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            itemCount: widget.urls.length,
            onPageChanged: (i) => setState(() => _currentIndex = i),
            itemBuilder: (_, i) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.urls[i],
                    fit: BoxFit.cover,
                    placeholder: (ctx, url) => Container(
                      color: AppColors.primary.withAlpha(20),
                      child:
                          const Center(child: CircularProgressIndicator()),
                    ),
                    errorWidget: (ctx, url, err) => Container(
                      color: AppColors.primary.withAlpha(20),
                      child: const Icon(Icons.broken_image,
                          size: 40, color: AppColors.primary),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 10),
        // Dot indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.urls.length, (i) {
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              width: _currentIndex == i ? 18 : 8,
              height: 8,
              decoration: BoxDecoration(
                color: _currentIndex == i
                    ? AppColors.primary
                    : AppColors.primary.withAlpha(60),
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
      ],
    );
  }
}
