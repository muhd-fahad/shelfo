import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shelfo/provider/business_provider.dart';
import 'package:shelfo/routes/app_routes.dart';
import 'package:shelfo/widgets/sfo_common/sfo_card.dart';

class SettingsProfileCard extends StatelessWidget {
  const SettingsProfileCard({super.key});

  @override
  Widget build(BuildContext context) {
    final businessProvider = Provider.of<BusinessProvider>(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return SFOCard(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: ShapeDecoration(
                  color: colorScheme.primary.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  image: businessProvider.logoPath != null
                      ? DecorationImage(
                          image: businessProvider.logoPath!.startsWith('assets/')
                              ? AssetImage(businessProvider.logoPath!)
                              : FileImage(File(businessProvider.logoPath!))
                                  as ImageProvider,
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: businessProvider.logoPath == null
                    ? Icon(
                        Icons.store_rounded,
                        color: colorScheme.primary,
                        size: 30,
                      )
                    : null,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      businessProvider.nameController.text.isNotEmpty
                          ? businessProvider.nameController.text
                          : "Business Name",
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      businessProvider.phoneController.text.isNotEmpty
                          ? businessProvider.phoneController.text
                          : "Setup your business profile",
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton.filledTonal(
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRoutes.businessDetails,
                  );
                },
                icon: const Icon(Icons.edit_rounded, size: 20),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
