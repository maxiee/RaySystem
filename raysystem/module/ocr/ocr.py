from ocrmac import ocrmac


def ocr_text_from_image_path(image_path) -> str:
    ocr_ret = ocrmac.OCR(
        image_path,
        recognition_level="accurate",
        language_preference=["zh-Hans", "en-US"],
    ).recognize()
    return "\n".join([annotation[0] for annotation in ocr_ret])
