import 'package:de_glitch/widgets/shimmer_box.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:shimmer/shimmer.dart';
import '../constants/colors/colors.dart';

class WebDashboardShimmer extends StatelessWidget {
  const WebDashboardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: background.withValues(alpha: 0.9),
      highlightColor: background.withValues(alpha: 0.5),
      child: ListView(
        children: [
          const Gap(10),
          Row(children: [ShimmerBox(height: 10, width: 60)]),
          const Gap(5),
          Row(children: [ShimmerBox(height: 10, width: 80)]),
          const Gap(30),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
            ],
          ),
          const Gap(10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
            ],
          ),
          const Gap(10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
            ],
          ),
          const Gap(10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            alignment: WrapAlignment.center,
            children: [
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
              ShimmerBox(
                height: 30,
                width: MediaQuery.of(context).size.width > 800
                    ? MediaQuery.of(context).size.width / 4
                    : double.infinity,
              ),
            ],
          ),
          const Gap(10),
          ShimmerBox(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.9,
          ),
          const Gap(20),
          ShimmerBox(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.9,
          ),
          const Gap(20),
          ShimmerBox(
            height: 150,
            width: MediaQuery.of(context).size.width * 0.9,
          ),
        ],
      ),
    );
  }
}
