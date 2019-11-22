#include "imagehelper.h"
#include <QImageReader>
#include <QUrl>
#include <QDebug>

void ImageHelper::loadImage(const QString &fileUrl)
{
    QImageReader reader(QUrl(fileUrl).toLocalFile());
    m_imageBuffer = reader.read();
}

bool ImageHelper::saveImage(const QString &fileUrl)
{
    m_imageBuffer.save(fileUrl);
    return true;
}
