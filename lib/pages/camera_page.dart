import 'package:image_picker/image_picker.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/dummy_result_provider.dart';

class CameraPage extends ConsumerStatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  ConsumerState<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends ConsumerState<CameraPage> {
  late List<CameraDescription> _cameras;
  late CameraController _controller;
  bool _ready = false;
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    if (mounted) setState(() => _ready = true);
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;
    _selectedCameraIndex = (_selectedCameraIndex + 1) % _cameras.length;
    await _controller.dispose();
    _controller = CameraController(
      _cameras[_selectedCameraIndex],
      ResolutionPreset.medium,
    );
    await _controller.initialize();
    if (mounted) setState(() {});
  }

  Future<void> _onShutterPressed() async {
    if (!_ready) return;
    final XFile shot = await _controller.takePicture();
    context.push('/home/photo/save', extra: shot.path);
  }

  Future<void> _pickImageFromGallery() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      // GalleryPage로 이동
      context.push('/home/photo/save', extra: pickedFile.path);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color seedColor = const Color(0xFF5B8B4B);

    if (!_ready) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ✅ 상단: 타이틀 + 뒤로가기 (흰 배경 위)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => context.pop(),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    '사진을 촬영합니다.',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            // ✅ 중간: 카메라 화면 (버튼 위까지 확장됨)
            Expanded(
              child: CameraPreview(_controller),
            ),

            // ✅ 하단: 흰색 배경 위에 버튼들
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 24),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.photo_library, size: 36),
                    onPressed: _pickImageFromGallery, // 기존 context.push(...) 제거
                  ),
                  GestureDetector(
                    onTap: _onShutterPressed,
                    child: Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFF5B8B4B),
                      ),
                      child: const Icon(
                          Icons.camera_alt, color: Colors.white, size: 36),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cameraswitch, size: 36),
                    onPressed: _switchCamera,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}