import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:raysystem_flutter/api/api.dart';
import 'package:raysystem_flutter/commands/command.dart';
import 'package:raysystem_flutter/component/ocr_card.dart';
import 'package:screen_capturer/screen_capturer.dart';

final textCommands = Command(
  command: 'text-app',
  icon: Icons.text_fields,
  title: '文本处理',
  subCommands: [
    Command(
      command: 'ocr-region',
      title: 'OCR 识别区域',
      icon: Icons.crop,
      callback: (context, cardManager) async {
        CapturedData? captureData =
            await ScreenCapturer.instance.capture(mode: CaptureMode.region);
        if (captureData != null) {
          final result = await api.recognizeTextOcrRecognizePost(
            file: MultipartFile.fromBytes(
              captureData.imageBytes!,
              filename: 'capture.png',
            ),
          );

          cardManager.addCard(OcrCard(
            imageBytes: captureData.imageBytes!,
            ocrText: result.data?.asMap['text'] ?? '',
          ));
        }
      },
    ),
    Command(
      command: 'ocr-full',
      title: 'OCR 识别全屏',
      icon: Icons.fullscreen,
      callback: (context, cardManager) async {
        CapturedData? captureData =
            await ScreenCapturer.instance.capture(mode: CaptureMode.screen);
        if (captureData != null) {
          final result = await api.recognizeTextOcrRecognizePost(
            file: MultipartFile.fromBytes(
              captureData.imageBytes!,
              filename: 'capture.png',
            ),
          );

          cardManager.addCard(OcrCard(
            imageBytes: captureData.imageBytes!,
            ocrText: result.data?.asMap['text'] ?? '',
          ));
        }
      },
    ),
    Command(
      command: 'ocr-window',
      title: 'OCR 识别窗口',
      icon: Icons.desktop_windows,
      callback: (context, cardManager) async {
        CapturedData? captureData =
            await ScreenCapturer.instance.capture(mode: CaptureMode.window);
        if (captureData != null) {
          final result = await api.recognizeTextOcrRecognizePost(
            file: MultipartFile.fromBytes(
              captureData.imageBytes!,
              filename: 'capture.png',
            ),
          );

          cardManager.addCard(OcrCard(
            imageBytes: captureData.imageBytes!,
            ocrText: result.data?.asMap['text'] ?? '',
          ));
        }
      },
    ),
  ],
);
