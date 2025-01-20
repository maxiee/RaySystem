from fastapi import File, UploadFile
from PIL import Image
from io import BytesIO
from module.http.http import APP
from module.ocr.ocr import ocr_text_from_image_path

@APP.post("/ocr/recognize")
async def recognize_text(file: UploadFile = File(...)):
    """
    接收图片文件并进行 OCR 文字识别
    
    :param file: 上传的图片文件
    :return: 识别出的文字内容
    """
    try:
        # 读取上传的文件内容
        contents = await file.read()
        
        # 使用 PIL 创建图片对象
        image = Image.open(BytesIO(contents))
        
        # 调用 OCR 识别函数
        text = ocr_text_from_image_path(image)
        
        return {"text": text}
    except Exception as e:
        return {"error": str(e)}

def init_ocr_api():
    print("OCR API initialized")