#include "svgimageprovider.h"

SvgImageProvider::SvgImageProvider()
    : QQuickImageProvider(QQuickImageProvider::Image)
{

}

QImage SvgImageProvider::requestImage(const QString &id, QSize *size, const QSize &requestedSize)
{
    Q_UNUSED(requestedSize);

    QImage image;

    if (id.startsWith("svg_icon_color_change:")) {
        QStringList parts = id.split(':');
        if (parts.size() == 3) {
            QString svgFilePath = parts[1];
            QString color = parts[2];

            QSvgRenderer renderer(svgFilePath);
            QSize imageSize = renderer.defaultSize();

            if (size) {
                *size = imageSize;
            }

            image = QImage(imageSize, QImage::Format_ARGB32);
            image.fill(Qt::transparent);

            QPainter painter(&image);
            painter.setRenderHint(QPainter::Antialiasing);

            QColor iconColor(color);
            painter.setBrush(iconColor);
            renderer.render(&painter);
        }
    }

    return image;
}
