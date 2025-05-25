// lib/router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/* ─── pages ───────────────────────────────────────────────────── */
import 'pages/login_page.dart';
import 'pages/report_detail_page.dart';
import 'pages/report_list_page.dart';
import 'pages/user_info_page.dart';
import 'pages/splash_page.dart';

import 'pages/main_menu_page.dart';
import 'pages/camera_page.dart';
import 'pages/gallery_page.dart';
import 'pages/chat_page.dart';

import 'pages/favorites_page.dart';
import 'pages/profile_page.dart';
import 'pages/report_page.dart';

/* ─── providers ───────────────────────────────────────────────── */
import 'providers/guide_provider.dart';   // GuideState 타입 전달용

/* ─── GoRouter 인스턴스 ──────────────────────────────────────── */
final router = GoRouter(
  debugLogDiagnostics: true,        // 콘솔에 라우팅 로그
  initialLocation: '/login',        // 앱 최초 화면: 로그인
  routes: [
    /* 0) 스플래시 (필요 시 /splash 로 시작) */
    GoRoute(
      path: '/splash',
      builder: (_, __) => const SplashPage(),
    ),

    /* 1) 로그인 */
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
    ),

    /* 2) 사용자 기본 정보 입력 */
    GoRoute(
      path: '/signup',
      builder: (_, __) => const UserInfoPage(),
    ),

    // 새로운 메인 메뉴 (탭 없이 단독 화면)
    GoRoute(
      path: '/main',
      builder: (_, __) => const MainMenuPage(),
    ),

    // 독립형 카메라 촬영 페이지 (탭 없이 사용)
    GoRoute(
      path: '/camera',
      builder: (_, __) => const CameraPage(),
    ),

    GoRoute(
      path: '/home/photo',
      builder: (_, __) => const CameraPage(),
      routes: [
        GoRoute(
          path: 'save',
          name: 'gallery',
          builder: (_, state) => GalleryPage(
            imagePath: state.extra as String,
          ),
        ),
      ],
    ),

    GoRoute(
      path: '/chat',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;

        if (extra == null ||
            extra['imagePath'] == null ||
            extra['label'] == null) {
          return const Scaffold(
            body: Center(child: Text('잘못된 경로입니다')),
          );
        }

        return ChatPage(
          imagePath: extra['imagePath'],
          label: extra['label'],
          rule: extra['rule'] ?? '',
        );
      },
    ),

    GoRoute(
      path: '/favorites',
      name: 'favorites',
      builder: (context, state) => const FavoritesPage(),
    ),

    GoRoute(
      path: '/report-error',
      builder: (context, state) {
        final extras = state.extra as Map<String, dynamic>;
        return ReportErrorPage(
          imagePath: extras['imagePath'] ?? '',
          imageId: extras['imageId'] is int ? extras['imageId'] : null,
          label: extras['label'] ?? '',
          rule: extras['rule'] ?? '',
        );
      },
    ),

    GoRoute(
      path: '/report-list',
      builder: (_, __) => const ReportListPage(),
    ),

    GoRoute(
      path: '/report-detail',
      builder: (context, state) {
        final report = state.extra as Map<String, dynamic>;
        return ReportDetailPage(report: report);
      },
    ),

    GoRoute(
      path: '/profile',
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),


  ],
);
