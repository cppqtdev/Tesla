#ifndef SVGIMAGEPROVIDER_H
#define SVGIMAGEPROVIDER_H
#include <QQuickImageProvider>
#include <QImage>
#include <QSvgRenderer>
#include<QPainter>

class SvgImageProvider : public QQuickImageProvider
{
public:
    SvgImageProvider();
    QImage requestImage(const QString &id, QSize *size, const QSize &requestedSize) override;

};

#endif // SVGIMAGEPROVIDER_H
