import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sample/app/patient/profile_details/views/patient_review_screen.dart';
import 'package:sample/app/service/api/api_client/api_constants.dart';
import 'package:sample/app/service/api/api_client/api_response.dart';
import '../controllers/profile_details_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class ProfileDetailsView extends GetView<ProfileDetailsController> {
  const ProfileDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF3F4F6),
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        centerTitle: true,
        title: Text(
          "patient_prof_title".tr,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Colors.black,
          ),
        ),
        actions: const [
          // Padding(
          //   padding: EdgeInsets.only(right: 16),
          //   child: Icon(Icons.share_outlined, color: Colors.black),
          // )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Padding(
        padding:
            const EdgeInsets.symmetric(horizontal: 16), // left & right margin
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Color(0xFF00897B), Color(0xFF1565C0)],
            ),
          ),
          child: ElevatedButton(
            onPressed: controller.goToPatientDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "next_button".tr,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                SizedBox(width: 8),
                Icon(Icons.arrow_forward, color: Colors.white, size: 18),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return _ShimmerWrapper(
            child: _buildSkeleton(),
          );
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _doctorCard(),
              const SizedBox(height: 16),
              _appointmentCard(),
              const SizedBox(height: 16),
              _recommendedCard(context),
              const SizedBox(height: 16),
              _clinicPhotosCard(),
              const SizedBox(height: 16),
              _servicesCard(),
              const SizedBox(height: 16),
              _specializationsCard(),
              const SizedBox(height: 24),
              const SizedBox(height: 50),
            ],
          ),
        );
      }),
    );
  }

  // ================= DOCTOR CARD =================
  Widget _doctorCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Obx(() => Column(
            children: [
              Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: controller.doctorImage.value.isNotEmpty
                        ? Image.network(
                            ApiConstants.baseUrl + controller.doctorImage.value,
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _doctorImageFallback(),
                          )
                        : _doctorImageFallback(),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.doctorName.value,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          controller.doctorSpecialty.value,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          controller.doctorDegree.value,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 12,
                            color: Color(0xFF6B7280),
                          ),
                        ),
                      ],
                    ),
                  ),
                  //const Icon(Icons.favorite_border, color: Colors.black54),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _InfoItem(Icons.work_outline,
                      "${controller.doctorExperience.value} ${'patient_prof_exp'.tr}"),
                  const _VerticalDivider(),
                  _InfoItem(Icons.star,
                      "${controller.doctorRating.value.toStringAsFixed(1)}"),
                  const _VerticalDivider(),
                  _InfoItem(Icons.chat_bubble_outline,
                      "${controller.reviewCount.value} ${'patient_prof_review'.tr}"),
                ],
              ),
            ],
          )),
    );
  }

  Widget _doctorImageFallback() {
    return Container(
      height: 80,
      width: 80,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E7FF),
        borderRadius: BorderRadius.circular(14),
      ),
      alignment: Alignment.center,
      child: const Icon(Icons.person, size: 40, color: Color(0xFF3730A3)),
    );
  }

  // ================= APPOINTMENT CARD =================
  Widget _appointmentCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // TABS
          Obx(() => Row(
                children: [
                  _tab("patient_prof_tab_clinic".tr,
                      Icons.local_hospital_outlined, 0),
                  const SizedBox(width: 10),
                  _tab("patient_prof_tab_video".tr, Icons.videocam_outlined, 1),
                ],
              )),

          const SizedBox(height: 20),

          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "patient_prof_appointment".tr,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "₹${controller.fees.value}",
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              )),

          const SizedBox(height: 14),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 12),

          Obx(() => _detailRow(
              Icons.medical_services_outlined, controller.clinicName.value)),
          const SizedBox(height: 15),

          Obx(() => _detailRow(
              Icons.location_on_outlined,
              controller.address.value.isNotEmpty
                  ? controller.address.value
                  : "patient_prof_address_na".tr)),
          const SizedBox(height: 12),

          Obx(() => Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.hourglass_bottom_outlined,
                        size: 16, color: Colors.black54),
                    const SizedBox(width: 8),
                    Text("patient_prof_wait".tr,
                        style: TextStyle(fontFamily: 'Mulish', fontSize: 13)),
                    Text(
                      "${controller.waitTime.value} ${'patient_prof_wait_mins'.tr}",
                      style: const TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 13,
                          fontWeight: FontWeight.w700),
                    ),
                    Text("patient_prof_wait_suffix".tr,
                        style: TextStyle(fontFamily: 'Mulish', fontSize: 13)),
                  ],
                ),
              )),

          const SizedBox(height: 22),

          // MONTH ROW
          Obx(() => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: controller.prevMonth,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.arrow_back_ios,
                          size: 14, color: Colors.black54),
                    ),
                  ),
                  Text(
                    controller.currentMonthLabel.value,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.nextMonth,
                    child: const Padding(
                      padding: EdgeInsets.all(4),
                      child: Icon(Icons.arrow_forward_ios,
                          size: 14, color: Colors.black54),
                    ),
                  ),
                ],
              )),

          const SizedBox(height: 16),

          // DATE SLIDER
          Obx(() {
            if (controller.dates.isEmpty) {
              return Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Center(
                  child: Text(
                    "patient_prof_no_dates".tr,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Color(0xFF6B7280),
                      fontSize: 13,
                    ),
                  ),
                ),
              );
            }

            final selectedIdx = controller.selectedDateIndex.value;
            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: controller.dates.length,
                itemBuilder: (context, index) {
                  final item = controller.dates[index];
                  final bool selected = selectedIdx == index;
                  final int slots = item["slots"] as int;

                  return GestureDetector(
                    onTap: () => controller.selectDate(index),
                    child: SizedBox(
                      width: 66,
                      child: Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: Colors.white,
                                border:
                                    Border.all(color: const Color(0xFFE5E7EB)),
                              ),
                            ),
                            AnimatedOpacity(
                              opacity: selected ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 220),
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFF00897B),
                                      Color(0xFF1565C0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Center(
                                    child: Text(
                                      item["date"].toString(),
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 20,
                                        fontWeight: FontWeight.w800,
                                        color: selected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Center(
                                    child: Text(
                                      item["day"].toString(),
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 12,
                                        color: selected
                                            ? Colors.white70
                                            : Colors.black54,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Center(
                                    child: Text(
                                      slots == 0 ? "Full" : "$slots Slots",
                                      style: TextStyle(
                                        fontFamily: 'Mulish',
                                        fontSize: 11,
                                        fontWeight: FontWeight.w600,
                                        color: selected
                                            ? Colors.white
                                            : slots == 0
                                                ? Colors.redAccent
                                                : const Color(0xFF0D9488),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            );
          }),

          const SizedBox(height: 16),

          // TIME SLOTS
          Obx(() => controller.timeSlots.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 10),
                  child: Center(
                    child: Text(
                      "patient_prof_no_slots".tr,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        color: Color(0xFF6B7280),
                        fontSize: 13,
                      ),
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: controller.timeSlots
                      .map((time) => _timeChip(time))
                      .toList(),
                )),

          //const SizedBox(height: 16),

          // Center(
          //   child: GestureDetector(
          //     onTap: controller.viewAllSlots,
          //     child: const Text(
          //       "View all slots >",
          //       style: TextStyle(
          //         fontFamily: 'Mulish',
          //         color: Color(0xFF0D9488),
          //         fontWeight: FontWeight.w600,
          //         fontSize: 13,
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  // ================= HIGHLY RECOMMENDED CARD =================
  Widget _recommendedCard(context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 16,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "patient_prof_recommended".tr,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "patient_prof_friendliness".tr,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "patient_prof_friendliness_sub".tr,
                      style: TextStyle(
                        fontFamily: 'Mulish',
                        fontSize: 12,
                        color: Color(0xFF6B7280),
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              // const Icon(Icons.favorite_border,
              //     color: Colors.black54, size: 20),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(color: Color(0xFFE5E7EB)),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "patient_prof_stories".tr,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
              ),
              controller.reviews.length == 3
                  ? InkWell(
                      onTap: () {
                        Get.toNamed('/all-reviews');
                      },
                      child: Text(
                        "patient_prof_view_all".tr,
                        style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 14,
                          color: Color(0xFF0D9488),
                          fontWeight: FontWeight.w700,
                        ),
                      ))
                  : Container(),
            ],
          ),

          const SizedBox(height: 4),
          Text(
            "patient_prof_friendliness_sub".tr,
            style: TextStyle(
              fontFamily: 'Mulish',
              fontSize: 12,
              color: Color(0xFF6B7280),
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),

          // ---- Dynamic reviews from API ----
          Obx(() {
            if (controller.reviews.isEmpty) {
              return Text(
                "patient_prof_no_reviews".tr,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 13,
                  color: Color(0xFF9CA3AF),
                ),
              );
            }
            return Column(
              children: controller.reviews.take(2).map((r) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _reviewTile(
                    name: r['reviewer_name'] ?? '',
                    initials: r['initials'] ?? '',
                    rating: (r['rating'] as double?) ?? 0.0,
                    time: r['relative_date'] ?? '',
                    review: r['review_text'] ?? '',
                  ),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: controller.reviewStatus.value == 1
                      ? null
                      : () => showReviewDialog(
                            context,
                            doctorName: controller.doctorName.value,
                            onSubmit: (int rating, String reviewText) {
                              controller.submitReview(
                                rating: rating,
                                reviewText: reviewText,
                              );
                            },
                          ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: controller.reviewStatus.value == 1
                          ? Colors.grey
                          : const Color(0xFF0D9488),
                    ),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    controller.reviewStatus.value == 1
                        ? "patient_prof_reviewed".tr
                        : "patient_prof_share_story".tr,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: controller.reviewStatus.value == 1
                          ? Colors.grey
                          : const Color(0xFF0D9488),
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              // Expanded(
              //   child: Obx(() => OutlinedButton(
              //         onPressed: () {},
              //         style: OutlinedButton.styleFrom(
              //           side: const BorderSide(color: Color(0xFF0D9488)),
              //           shape: RoundedRectangleBorder(
              //               borderRadius: BorderRadius.circular(30)),
              //           padding: const EdgeInsets.symmetric(vertical: 12),
              //         ),
              //         child: Text(
              //           "Read ${controller.reviewCount.value} Stories",
              //           style: const TextStyle(
              //             fontFamily: 'Mulish',
              //             color: Color(0xFF0D9488),
              //             fontWeight: FontWeight.w600,
              //             fontSize: 13,
              //           ),
              //         ),
              //       )),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reviewTile({
    required String name,
    required String initials,
    required double rating,
    required String time,
    required String review,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFE0E7FF),
            borderRadius: BorderRadius.circular(10),
          ),
          alignment: Alignment.center,
          child: Text(
            initials.isNotEmpty
                ? initials.toUpperCase()
                : (name.isNotEmpty ? name[0].toUpperCase() : '?'),
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontWeight: FontWeight.w700,
              color: Color(0xFF3730A3),
              fontSize: 13,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                  const Spacer(),
                  // const Icon(Icons.thumb_up_alt_outlined,
                  //     size: 16, color: Colors.black45),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  _starRating(rating),
                  const SizedBox(width: 8),
                  Text(
                    time,
                    style: const TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 11,
                      color: Color(0xFF9CA3AF),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                review,
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _starRating(double rating) {
    return Row(
      children: List.generate(5, (i) {
        if (i < rating.floor()) {
          return const Icon(Icons.star, size: 13, color: Color(0xFFFBBF24));
        } else if (i < rating && rating - i >= 0.5) {
          return const Icon(Icons.star_half,
              size: 13, color: Color(0xFFFBBF24));
        } else {
          return const Icon(Icons.star_border,
              size: 13, color: Color(0xFFFBBF24));
        }
      }),
    );
  }

  Future<void> openMap(double lat, double lng) async {
    final Uri appUrl =
        Uri.parse("geo:22.705341513515222,75.87801492730993?q=$lat,$lng");
    final Uri webUrl = Uri.parse(
      "https://www.google.com/maps/search/?api=1&query=22.70534151351522,75.87801492730993",
    );

    if (await canLaunchUrl(appUrl)) {
      await launchUrl(appUrl);
    } else {
      await launchUrl(webUrl, mode: LaunchMode.externalApplication);
    }
  }

  String getStaticMap(double lat, double lng) {
    return "https://maps.googleapis.com/maps/api/staticmap"
        "?center=$lat,$lng"
        "&zoom=15"
        "&size=600x300"
        "&markers=color:red%7C$lat,$lng";
  }

  String getMapPreview(double lat, double lng) {
    return "https://maps.google.com/maps?q=$lat,$lng&z=15&output=embed";
  }

  Widget _clinicPhotosCard() {
    return Obx(() {
      final photos = controller.clinicPhotos;
      final lat = controller.latitude.value;
      final lng = controller.longitude.value;

      if (lat == 0.0 || lng == 0.0) {
        return const SizedBox();
      }

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "patient_prof_clinic_details".tr,
              style: TextStyle(
                fontFamily: 'Mulish',
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 14),

            // ===== HORIZONTAL IMAGE LIST =====
            photos.isEmpty
                ? Text(
                    "patient_prof_no_photos".tr,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  )
                : SizedBox(
                    height: 90,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: photos.length,
                      separatorBuilder: (_, __) => const SizedBox(width: 10),
                      itemBuilder: (context, i) {
                        return GestureDetector(
                          onTap: () => _openImagePreview(i),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.network(
                              ApiConstants.baseUrl + photos[i],
                              height: 90,
                              width: 110,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Container(
                                height: 90,
                                width: 110,
                                color: const Color(0xFFE5E7EB),
                                alignment: Alignment.center,
                                child: const Icon(
                                  Icons.broken_image,
                                  color: Color(0xFF9CA3AF),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

            const SizedBox(height: 16),

            // ===== GET DIRECTION BUTTON =====
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      openMap(lat, lng);
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF0D9488)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "patient_prof_get_direction".tr,
                          style: TextStyle(
                            fontFamily: 'Mulish',
                            color: Color(0xFF0D9488),
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Image.asset(
                          "assets/assistant_navigation.png",
                          height: 20,
                          width: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    });
  }

  void _openImagePreview(int index) {
    final photos = controller.clinicPhotos;

    Get.to(
      () => Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          backgroundColor: Colors.black,
          iconTheme: const IconThemeData(color: Colors.white),
        ),
        body: PageView.builder(
          itemCount: photos.length,
          controller: PageController(initialPage: index),
          itemBuilder: (_, i) {
            return InteractiveViewer(
              child: Center(
                child: Image.network(
                  ApiConstants.baseUrl + photos[i],
                  fit: BoxFit.contain,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ================= SERVICES CARD =================
  Widget _servicesCard() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              )
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "patient_prof_services".tr,
                style: TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "${controller.doctorName.value} ${'patient_prof_services_sub'.tr}",
                style: const TextStyle(
                  fontFamily: 'Mulish',
                  fontSize: 12,
                  color: Color(0xFF6B7280),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 14),
              if (controller.services.isEmpty)
                Text(
                  "patient_prof_no_services".tr,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 13,
                    color: Color(0xFF9CA3AF),
                  ),
                )
              else
                ...controller.services.map(
                  (s) => Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: Color(0xFF0D9488),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.check,
                              size: 12, color: Colors.white),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          s,
                          style: const TextStyle(
                            fontFamily: 'Mulish',
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              //const SizedBox(height: 4),
              // GestureDetector(
              //   onTap: () {},
              //   child: const Text(
              //     "View all Services & Procedures >",
              //     style: TextStyle(
              //       fontFamily: 'Mulish',
              //       color: Color(0xFF0D9488),
              //       fontWeight: FontWeight.w600,
              //       fontSize: 13,
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }

  // ================= SPECIALIZATIONS CARD =================
  Widget _specializationsCard() {
    return Obx(() => Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 4),
            )
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "patient_prof_specializations".tr,
                  style: TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  "${controller.doctorName.value} ${'patient_prof_specializations_sub'.tr}",
                  style: const TextStyle(
                    fontFamily: 'Mulish',
                    fontSize: 12,
                    color: Color(0xFF6B7280),
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 14),
                if (controller.specializations.isEmpty)
                  Text(
                    "patient_prof_no_specializations".tr,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontSize: 13,
                      color: Color(0xFF9CA3AF),
                    ),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 12,
                    children: controller.specializations.map((s) {
                      return SizedBox(
                        width:
                            (MediaQuery.of(Get.context!).size.width - 80) / 2,
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: const BoxDecoration(
                                color: Color(0xFF0D9488),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.check,
                                  size: 12, color: Colors.white),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                s,
                                style: const TextStyle(
                                  fontFamily: 'Mulish',
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                // GestureDetector(
                //   onTap: () {},
                //   child: const Text(
                //     "View all Specializations >",
                //     style: TextStyle(
                //       fontFamily: 'Mulish',
                //       color: Color(0xFF0D9488),
                //       fontWeight: FontWeight.w600,
                //       fontSize: 13,
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        )));
  }

  // ===== TAB WIDGET =====
  Widget _tab(String text, IconData icon, int index) {
    final selected = controller.selectedTab.value == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => controller.changeTab(index),
        child: Stack(
          children: [
            Container(
              height: 46,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color(0xFFE5E7EB),
              ),
            ),
            AnimatedOpacity(
              opacity: selected ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 220),
              child: Container(
                height: 46,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  gradient: const LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [Color(0xFF00897B), Color(0xFF1565C0)],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 46,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 17,
                    color: selected ? Colors.white : Colors.black54,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    text,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: selected ? Colors.white : Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== TIME CHIP =====
  Widget _timeChip(String time) {
    final selected = controller.selectedSlot.value == time;
    return GestureDetector(
      onTap: () => controller.selectSlot(time),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          color: selected
              ? const Color.fromARGB(255, 91, 101, 100).withOpacity(0.08)
              : Colors.white,
          border: Border.all(
            color: selected ? const Color(0xFF0D9488) : const Color(0xFFE5E7EB),
          ),
        ),
        child: Text(
          time,
          style: TextStyle(
            fontFamily: 'Mulish',
            fontWeight: FontWeight.w600,
            fontSize: 13,
            color: selected ? const Color(0xFF0D9488) : Colors.black87,
          ),
        ),
      ),
    );
  }

  // ===== DETAIL ROW =====
  Widget _detailRow(IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 17, color: Colors.black54),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontFamily: 'Mulish',
              fontSize: 13,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }
}

// ===== REUSABLE SMALL WIDGETS =====

class _InfoItem extends StatelessWidget {
  final IconData icon;
  final String text;
  const _InfoItem(this.icon, this.text);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 17, color: Colors.black54),
        const SizedBox(width: 6),
        Text(
          text,
          style: const TextStyle(fontFamily: 'Mulish', fontSize: 12),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  const _VerticalDivider();

  @override
  Widget build(BuildContext context) {
    return Container(height: 22, width: 1, color: const Color(0xFFE5E7EB));
  }
}

// ================= SKELETON =================

Widget _buildSkeleton() {
  return SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        // --- Doctor Card Skeleton ---
        _skeletonCard(
          child: Column(
            children: [
              Row(
                children: [
                  _skeletonBox(width: 80, height: 80, radius: 14),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _skeletonBox(width: 140, height: 16),
                        const SizedBox(height: 8),
                        _skeletonBox(width: 100, height: 13),
                        const SizedBox(height: 6),
                        _skeletonBox(width: 80, height: 12),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _skeletonBox(width: 70, height: 14),
                  _skeletonBox(width: 1, height: 22),
                  _skeletonBox(width: 50, height: 14),
                  _skeletonBox(width: 1, height: 22),
                  _skeletonBox(width: 70, height: 14),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // --- Appointment Card Skeleton ---
        _skeletonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Tabs
              Row(
                children: [
                  Expanded(
                      child: _skeletonBox(
                          width: double.infinity, height: 46, radius: 30)),
                  const SizedBox(width: 10),
                  Expanded(
                      child: _skeletonBox(
                          width: double.infinity, height: 46, radius: 30)),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _skeletonBox(width: 140, height: 15),
                  _skeletonBox(width: 50, height: 18),
                ],
              ),
              const SizedBox(height: 14),
              const Divider(color: Color(0xFFE5E7EB)),
              const SizedBox(height: 12),
              _skeletonBox(width: 180, height: 13),
              const SizedBox(height: 15),
              _skeletonBox(width: double.infinity, height: 13),
              const SizedBox(height: 12),
              _skeletonBox(width: double.infinity, height: 40, radius: 10),
              const SizedBox(height: 22),
              // Month row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _skeletonBox(width: 20, height: 14),
                  _skeletonBox(width: 80, height: 14),
                  _skeletonBox(width: 20, height: 14),
                ],
              ),
              const SizedBox(height: 16),
              // Date chips
              SizedBox(
                height: 100,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 5,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, __) =>
                      _skeletonBox(width: 66, height: 100, radius: 16),
                ),
              ),
              const SizedBox(height: 16),
              // Time chips
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  6,
                  (_) => _skeletonBox(width: 72, height: 38, radius: 30),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // --- Recommended Card Skeleton ---
        _skeletonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeletonBox(width: 180, height: 15),
              const SizedBox(height: 14),
              _skeletonBox(width: double.infinity, height: 13),
              const SizedBox(height: 6),
              _skeletonBox(width: 220, height: 13),
              const SizedBox(height: 16),
              const Divider(color: Color(0xFFE5E7EB)),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _skeletonBox(width: 110, height: 14),
                  _skeletonBox(width: 60, height: 14),
                ],
              ),
              const SizedBox(height: 16),
              // Review tile 1
              _skeletonReviewTile(),
              const SizedBox(height: 12),
              // Review tile 2
              _skeletonReviewTile(),
              const SizedBox(height: 16),
              _skeletonBox(width: double.infinity, height: 46, radius: 30),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // --- Clinic Details Card Skeleton ---
        _skeletonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeletonBox(width: 110, height: 15),
              const SizedBox(height: 14),
              SizedBox(
                height: 90,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  separatorBuilder: (_, __) => const SizedBox(width: 10),
                  itemBuilder: (_, __) =>
                      _skeletonBox(width: 110, height: 90, radius: 12),
                ),
              ),
              const SizedBox(height: 16),
              _skeletonBox(width: double.infinity, height: 46, radius: 30),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // --- Services Card Skeleton ---
        _skeletonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeletonBox(width: 170, height: 15),
              const SizedBox(height: 6),
              _skeletonBox(width: 220, height: 12),
              const SizedBox(height: 14),
              ...List.generate(
                4,
                (_) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    children: [
                      _skeletonBox(width: 20, height: 20, radius: 10),
                      const SizedBox(width: 10),
                      _skeletonBox(width: 150, height: 13),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // --- Specializations Card Skeleton ---
        _skeletonCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _skeletonBox(width: 130, height: 15),
              const SizedBox(height: 6),
              _skeletonBox(width: 200, height: 12),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 12,
                children: List.generate(
                  6,
                  (_) => SizedBox(
                    width: (MediaQuery.of(Get.context!).size.width - 80) / 2,
                    child: Row(
                      children: [
                        _skeletonBox(width: 20, height: 20, radius: 10),
                        const SizedBox(width: 8),
                        _skeletonBox(width: 100, height: 13),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 74), // space for FAB
      ],
    ),
  );
}

Widget _skeletonReviewTile() {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _skeletonBox(width: 42, height: 42, radius: 10),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _skeletonBox(width: 100, height: 13),
            const SizedBox(height: 6),
            _skeletonBox(width: 80, height: 11),
            const SizedBox(height: 6),
            _skeletonBox(width: double.infinity, height: 12),
            const SizedBox(height: 4),
            _skeletonBox(width: 180, height: 12),
          ],
        ),
      ),
    ],
  );
}

Widget _skeletonCard({required Widget child}) {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.04),
          blurRadius: 16,
          offset: const Offset(0, 4),
        ),
      ],
    ),
    child: child,
  );
}

Widget _skeletonBox({
  required double width,
  required double height,
  double radius = 6,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(radius),
    ),
  );
}

class _ShimmerWrapper extends StatefulWidget {
  final Widget child;
  const _ShimmerWrapper({required this.child});

  @override
  State<_ShimmerWrapper> createState() => _ShimmerWrapperState();
}

class _ShimmerWrapperState extends State<_ShimmerWrapper>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
    _animation = Tween<double>(begin: -1.5, end: 1.5).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                Color(0xFFEEEEEE),
                Color(0xFFFFFFFF),
                Color(0xFFEEEEEE),
              ],
              stops: [
                (_animation.value - 0.3).clamp(0.0, 1.0),
                _animation.value.clamp(0.0, 1.0),
                (_animation.value + 0.3).clamp(0.0, 1.0),
              ],
              transform: GradientRotation(_animation.value),
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
    );
  }
}
