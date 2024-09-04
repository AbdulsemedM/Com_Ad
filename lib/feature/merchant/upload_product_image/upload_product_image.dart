import 'dart:io';

import 'package:commercepal_admin_flutter/app/di/injector.dart';
import 'package:commercepal_admin_flutter/core/extensions/context_ext.dart';
import 'package:commercepal_admin_flutter/core/products/domain/models/image_types.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_cubit.dart';
import 'package:commercepal_admin_flutter/core/products/presentation/bloc/products_state.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_button.dart';
import 'package:commercepal_admin_flutter/core/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'widgets/image_chooser_widget.dart';

class UploadProductImage extends StatefulWidget {
  static const routeName = "/upload_image";

  const UploadProductImage({super.key});

  @override
  State<UploadProductImage> createState() => _UploadProductImageState();
}

class _UploadProductImageState extends State<UploadProductImage> {
  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)?.settings.arguments as Map;
    final ImageTypes imageTypes = args['image_type'];
    final String prodName = args['name'];
    final num prodId = args['prod_id'];

    return BlocProvider(
      create: (context) => getIt<ProductsCubit>(),
      child: BlocConsumer<ProductsCubit, ProductsState>(
        listener: (ctx, state) {
          if (state is ProductsStateError) {
            ctx.displaySnack(state.messages);
          }

          if (state is ProductsStateProductImages) {
            context.displaySnack("Images uploaded successfully");

            Navigator.pop(ctx, state.productImages);
          }
        },
        builder: (ctx, state) {
          return AppScaffold(
            appBarTitle: 'Upload Images',
            subTitle: "Upload 4 images for $prodName",
            child: SingleChildScrollView(
              child: Column(
                children: [
                  GridView.count(
                    shrinkWrap: true,
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    children: [
                      ImageChooserWidget(
                        onImagePicked: (File file) {
                          ctx.read<ProductsCubit>().addProductImage(file);
                        },
                      ),
                      ImageChooserWidget(
                        onImagePicked: (File file) {
                          ctx.read<ProductsCubit>().addProductImage(file);
                        },
                      ),
                      if (imageTypes == ImageTypes.productImages)
                        ImageChooserWidget(
                          onImagePicked: (File file) {
                            ctx.read<ProductsCubit>().addProductImage(file);
                          },
                        ),
                      if (imageTypes == ImageTypes.productImages)
                        ImageChooserWidget(
                          onImagePicked: (File file) {
                            ctx.read<ProductsCubit>().addProductImage(file);
                          },
                        ),
                    ],
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  AppButtonWidget(
                    isLoading: state is ProductsStateLoading,
                    onClick: () {
                      context.displaySnack(
                          "Uploading images, this may take some time");
                      ctx.read<ProductsCubit>().uploadImages(prodId, imageTypes);
                    },
                    text: "Upload images",
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
