#ifndef IMAGEHELPER_H
#define IMAGEHELPER_H
#include <QObject>
#include <QImage>

class ImageHelper : public QObject
{
    Q_OBJECT
public:
    explicit ImageHelper(QObject* parent = Q_NULLPTR)
        : QObject(parent) {

    }

    Q_INVOKABLE void loadImage(const QString& fileUrl);
    Q_INVOKABLE bool saveImage(const QString& fileUrl);

private:
    QImage m_imageBuffer;
};

#endif
