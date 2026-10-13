import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import '../model/google_office.dart';

class DetailPage extends StatelessWidget {
  final GoogleOffice googleOffice;
  final String? googleOfficeId;

  DetailPage({super.key, GoogleOffice? googleOffice, this.googleOfficeId})
      : googleOffice = googleOffice ??
            listOfGoogleOffice.firstWhere(
              (element) => element.id == googleOfficeId,
              orElse: () => listOfGoogleOffice.first,
            );

  Color _getRegionColor(String region) {
    switch (region) {
      case 'asia-pacific':
        return const Color(0xFF137333);
      case 'europe':
        return const Color(0xFF1A73E8);
      case 'north-america':
        return const Color(0xFF9334E6);
      case 'latin-america':
        return const Color(0xFFE37400);
      case 'africa-middle-east':
        return const Color(0xFFC5221F);
      default:
        return const Color(0xFF5F6368);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: const Text(
          'DetailPage',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Color(0xFF202124),
          ),
        ),
        actions: const [
          FavoriteButton(),
          SizedBox(width: 8),
        ],
      ),
      // TODO 2: change the widget below and add the selected Google office details
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth <= 700) {
              return _buildMobileDetail(context);
            } else {
              return _buildWebDetail(context);
            }
          },
        ),
      ),
    );
  }

  Widget _buildMobileDetail(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeroImage(height: 260),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(context),
                const SizedBox(height: 16),
                _buildQuickActions(context),
                const SizedBox(height: 20),
                const Divider(color: Color(0xFFE8EAED)),
                const SizedBox(height: 16),
                _buildInfoSection(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWebDetail(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1080),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE8EAED)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 5,
                    child: _buildHeroImage(height: 420, borderRadius: 16),
                  ),
                  const SizedBox(width: 28),
                  Expanded(
                    flex: 6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context),
                        const SizedBox(height: 16),
                        _buildQuickActions(context),
                        const SizedBox(height: 20),
                        const Divider(color: Color(0xFFE8EAED)),
                        const SizedBox(height: 16),
                        _buildInfoSection(context),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeroImage({required double height, double borderRadius = 0}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Hero(
        tag: 'office-image-${googleOffice.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(borderRadius),
          child: Image.network(
            googleOffice.image,
            height: height,
            width: double.infinity,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                height: height,
                color: Colors.grey.shade200,
                child: const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Color(0xFF1A73E8),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) => Container(
              height: height,
              color: Colors.grey.shade200,
              child: const Center(
                child: Icon(Icons.business, size: 64, color: Colors.grey),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final regionColor = _getRegionColor(googleOffice.region);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: regionColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                googleOffice.region.toUpperCase(),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: regionColor,
                  letterSpacing: 0.4,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F3F4),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.verified_rounded, size: 14, color: Color(0xFF1A73E8)),
                  SizedBox(width: 4),
                  Text(
                    'Verified Office',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF5F6368),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Text(
          googleOffice.name,
          style: GoogleFonts.poppins(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            color: const Color(0xFF202124),
            letterSpacing: -0.5,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.phone_forwarded_rounded,
            label: 'Call',
            color: const Color(0xFF1A73E8),
            onTap: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Calling ${googleOffice.phone}...'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.copy_rounded,
            label: 'Copy Address',
            color: const Color(0xFF137333),
            onTap: () {
              Clipboard.setData(ClipboardData(text: googleOffice.address));
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Address copied to clipboard!'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildActionButton(
            context: context,
            icon: Icons.share_rounded,
            label: 'Share',
            color: const Color(0xFF9334E6),
            onTap: () {
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Sharing ${googleOffice.name} Google Office info!'),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Material(
      color: color.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: color),
              const SizedBox(height: 4),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildInfoCard(
          icon: Icons.location_on_rounded,
          iconColor: const Color(0xFFEA4335),
          title: 'OFFICE ADDRESS',
          content: googleOffice.address,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.phone_rounded,
          iconColor: const Color(0xFF34A853),
          title: 'PHONE NUMBER',
          content: googleOffice.phone,
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.explore_rounded,
          iconColor: const Color(0xFF1A73E8),
          title: 'GEOGRAPHIC COORDINATES',
          content: 'Latitude: ${googleOffice.lat}\nLongitude: ${googleOffice.lng}',
        ),
        const SizedBox(height: 12),
        _buildInfoCard(
          icon: Icons.fingerprint_rounded,
          iconColor: const Color(0xFFFBBC04),
          title: 'OFFICE ID',
          content: googleOffice.id,
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8EAED)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 22, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF5F6368),
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF202124),
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key});

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  bool isFavorite = false;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: Icon(
          isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
          key: ValueKey<bool>(isFavorite),
          color: isFavorite ? const Color(0xFFEA4335) : const Color(0xFF5F6368),
        ),
      ),
      tooltip: isFavorite ? 'Remove from favorites' : 'Add to favorites',
      onPressed: () {
        setState(() {
          isFavorite = !isFavorite;
        });
        ScaffoldMessenger.of(context).clearSnackBars();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: Row(
              children: [
                Icon(
                  isFavorite ? Icons.check_circle : Icons.info_outline,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 10),
                Text(
                  isFavorite
                      ? 'Office added to favorites'
                      : 'Office removed from favorites',
                ),
              ],
            ),
            duration: const Duration(seconds: 1),
          ),
        );
      },
    );
  }
}
