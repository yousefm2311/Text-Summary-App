// ignore_for_file: must_be_immutable

import 'package:blurrycontainer/blurrycontainer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';
import 'package:text_summary_edit/core/view_model/web_view_model.dart';
import 'package:text_summary_edit/model/team_model.dart';
import 'package:text_summary_edit/routes/routes.dart';
import 'package:text_summary_edit/view/widget/MyText.dart';
import 'package:text_summary_edit/view/widget/custom_appBar.dart';

class InfoView extends GetWidget<WebViewModel> {
  const InfoView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: MyText(text: 'Info Team'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 5),
        child: StaggeredGridView.countBuilder(
          physics: const BouncingScrollPhysics(),
          itemCount: controller.data.length,
          itemBuilder: (context, index) {
            return Padding(
                padding: const EdgeInsets.only(bottom: 10, left: 5, right: 5),
                child: _buildGridView(controller.data[index], context));
          },
          crossAxisCount: 2,
          mainAxisSpacing: 1.0,
          staggeredTileBuilder: (int index) {
            return StaggeredTile.count(1, index.isEven ? 1.15 : 1.15);
          },
        ),
      ),
    );
  }

  _buildGridView(InfoModel model, context) => InkWell(
        onTap: () {
          Get.toNamed(AppRoutes.webView, arguments: model.linkGitHub);
        },
        child: BlurryContainer(
            color: Get.isDarkMode
                ? const Color.fromARGB(255, 143, 143, 143).withOpacity(0.1)
                : Colors.grey.withOpacity(0.21),
            blur: 30,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Stack(
                    alignment: AlignmentDirectional.bottomCenter,
                    children: [
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: AssetImage(
                                model.image!,
                              ),
                            )),
                      ),
                      Positioned(
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            border: Border.all(
                                width: 1,
                                color: Get.isDarkMode
                                    ? Colors.grey.withOpacity(0.05)
                                    : Colors.white),
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [
                                Colors.blue,
                                Colors.purple,
                              ],
                            ),
                          ),
                          child: Center(
                              child: MyText(
                            text: model.count!,
                            textStyle: const TextStyle(
                              color: Colors.white,
                            ),
                          )),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                MyText(
                  text: model.name!,
                  textStyle: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 10),
                Expanded(
                  child: MyText(
                    maxLines: model.description!.length,
                    text: model.description!,
                    textStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
                          fontWeight: FontWeight.w300,
                        ),
                  ),
                ),
              ],
            )),
      );
}
