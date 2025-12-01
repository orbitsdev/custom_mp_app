
import 'package:custom_mp_app/app/core/theme/app_colors.dart';
import 'package:custom_mp_app/app/core/utils/path_helpers.dart';
import 'package:custom_mp_app/app/global/widgets/image/local_image.dart';
import 'package:custom_mp_app/app/global/widgets/image/local_image_full_screen_display.dart';

import 'package:custom_mp_app/app/global/widgets/spacing/to_sliver.dart';
import 'package:custom_mp_app/app/modules/about/widgets/about_us_card.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';


class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        title: Text('About Us'),
       
       
      ),
      backgroundColor: AppColors.brandBackground,
      body: CustomScrollView(
        slivers: [
          
          ToSliver(
            child: Container(
              color: Colors.white,
              margin: EdgeInsets.only(top: 8, right: 8, left: 8),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Gap(Get.size.height * 0.04),
                    RichText(
                      text: TextSpan(text: '', children: [
                        TextSpan(
                            text: 'ABOUT',
                            style: GoogleFonts.rubik(
                              textStyle: textTheme.titleLarge!.copyWith(
                                  letterSpacing: 8,
                                     fontWeight: FontWeight.bold,
                                  
                                  ),
                            )),
                        TextSpan(
                            text: 'AVANTE',
                            style: GoogleFonts.rubik(
                              textStyle: textTheme.titleLarge!.copyWith(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.brandDark),
                            )),
                        TextSpan(
                            text: 'AGRI',
                            style: GoogleFonts.rubik(
                              textStyle: textTheme.titleLarge!.copyWith(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textDark),
                            )),
                      ]),
                    ),
                    Gap(16),
                    Container(
                      color: Colors.white,
                      child: Text(
                        'AVANTE AGRI-PRODUCTS PHILIPPINES, INC. or “Avante” for short, emanated from a Latin word which means to say To Progress, To Go Forward or To be Infront.  Incorporated on April 14th, 2011 with assigned SEC Registration No. CS201128986 to develop and deliver banana supply from the Philippines to both international and domestic markets the core value of business in the most professional and honest way as possible. The organization is ambitioning to consistently implement and deliver the core-etiquette value of the trade on the table that would later command a lasting business together with goodwill and satisfaction between the company and business associates and partners in the industry.',
                        style: textTheme.bodyMedium!.copyWith(),
                      ),
                    ),
                    Gap(16),
                    Container(
                      color: Colors.white,
                      child: Text(
                        'At the initiative of the board of directors, the corporation was organized and created to consolidate the farm land holdings of our family’s, relatives’ and friends’ as an immediate and main source of banana supply to certainly realize not only volume of supply but as well as assuring  quality of fruits at its earliest state of operation. For an effective bargaining position of their banana product to be sold to the multinational banana buyers, the consolidation of the farm landholdings come to accept the norms of banana farm development, consolidation and trading in their nearby farms and provinces.',
                        style: textTheme.bodyMedium!.copyWith(),
                      ),
                    ),
                    Gap(16),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => LocalImageFullScreenDisplay( imagePath: PathHelpers.imagePath('AVANTE-AGRI.jpg')),
                            ),
                          );
                        },
                        child: LocalImage(
                            imageUrl: PathHelpers.imagePath('AVANTE-AGRI.jpg'))),
                    Gap(16),
                    Container(
                      color: Colors.white,
                      child: Text(
                        'The rest of the board of directors are equally equipped with enormous and diverse experiences and expertise in the field of banana farm production operation, quality assurance, banana consolidation & trading, and commercial shipping & accounting, along with total quality management practices that made the organization far-reaching at its simple beginnings',
                        style: textTheme.bodyMedium!.copyWith(),
                      ),
                    ),
                    Gap(16),
                    Container(
                      color: Colors.white,
                      child: Text(
                        'The corporate roadmap and professional diversities were the intrinsic reasons why we safeguard our business framework with professionalism from the farm plantation to processing packing houses to port of loading - for us to ensure our business dealings are with QUALITY, TRUST, and LASTING CONFIDENCE.',
                        style: textTheme.bodyMedium!.copyWith(),
                      ),
                    ),
                    Gap(16),
                  ],
                ),
              ),
            ),
          ),
          ToSliver(child: Gap(16)),

          ToSliver(
              child: Container(
            color: Colors.white,
            margin: EdgeInsets.only(top: 8, right: 8, left: 8),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                    text: TextSpan(text: '', children: [
                      TextSpan(
                          text: 'OUR ',
                          style: textTheme.titleLarge!
                                .copyWith(fontWeight: FontWeight.normal),
                          ),
                      TextSpan(
                          text: 'MISSION, VISION AND GOAL ',
                          style:Get.textTheme.titleLarge!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: AppColors.brandDark),
                          ),
                    ]),
                  ),
                  Gap(16),
                  AboutUsCard(
                      title: 'Corporate Spirituality',
                      content:
                          'We derive our strength as company from God or Allah who gives us the kind of HEART that we ought to have, Humble, Ernest, Appreciative, Responsible & Tender.'),
                  Gap(16),
                  AboutUsCard(
                      title: 'Customer Care',
                      content:
                          'We care to contribute value to our customers by providing best quality products in relation to price.'),
                  Gap(16),
                  AboutUsCard(
                    title: 'People Welfare',
                    content:
                        'We regard our people as the best asset to upkeep giving due respect for professional and personal growth & development.',
                  ),
                  Gap(16),
                  AboutUsCard(
                    title: 'Accountability & Integrity',
                    content: 'We walk the talk and do what we say.',
                  ),
                  Gap(16),
                  AboutUsCard(
                    title: 'Drive to Arrive',
                    content:
                        'We find ways to be efficient and effective in doing the right things done the right way to be ahead on time.',
                  ),
                  Gap(16),
                  AboutUsCard(
                    title: 'Sustainable Development',
                    content:
                        'We take full responsibility for the impact of our operation on the environment and society.',
                  ),
                ],
              ),
            ),
          )),

          ToSliver(child: Gap(16)),

          

          ToSliver(child: Gap(24)),
          // OverflowContainer(child: Container(child: Text('lorem'),),),
        ],
      ),
    );
  }
}
