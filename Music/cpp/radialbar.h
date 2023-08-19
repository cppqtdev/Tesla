/*************************************************************************************
** The MIT License (MIT)
**
** RadialBar is a free Qt and QML based component.
** Copyright (c) 2017 Arun PK
** Email: mailztopk@gmail.com
**
** Permission is hereby granted, free of charge, to any person obtaining a copy
** of this software and associated documentation files (the "Software"), to deal
** in the Software without restriction, including without limitation the rights
** to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
** copies of the Software, and to permit persons to whom the Software is
** furnished to do so, subject to the following conditions:
**
** The above copyright notice and this permission notice shall be included in all
** copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
** IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
** AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
** OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
** SOFTWARE.
************************************************************************************/

#ifndef RADIALBAR_H
#define RADIALBAR_H

#include <QQuickPaintedItem>

class RadialBar : public QQuickPaintedItem
{
    Q_OBJECT

    Q_PROPERTY(qreal size READ getSize WRITE setSize NOTIFY sizeChanged)
    Q_PROPERTY(qreal startAngle READ getStartAngle WRITE setStartAngle NOTIFY startAngleChanged)
    Q_PROPERTY(qreal spanAngle READ getSpanAngle WRITE setSpanAngle NOTIFY spanAngleChanged)
    Q_PROPERTY(qreal minValue READ getMinValue WRITE setMinValue NOTIFY minValueChanged)
    Q_PROPERTY(qreal maxValue READ getMaxValue WRITE setMaxValue NOTIFY maxValueChanged)
    Q_PROPERTY(qreal value READ getValue WRITE setValue NOTIFY valueChanged)
    Q_PROPERTY(int dialWidth READ getDialWidth WRITE setDialWidth NOTIFY dialWidthChanged)
    Q_PROPERTY(QColor backgroundColor READ getBackgroundColor WRITE setBackgroundColor NOTIFY backgroundColorChanged)
    Q_PROPERTY(QColor foregroundColor READ getForegroundColor WRITE setForegroundColor NOTIFY foregroundColorChanged)
    Q_PROPERTY(QColor progressColor READ getProgressColor WRITE setProgressColor NOTIFY progressColorChanged)
    Q_PROPERTY(QColor textColor READ getTextColor WRITE setTextColor NOTIFY textColorChanged)
    Q_PROPERTY(QString suffixText READ getSuffixText WRITE setSuffixText NOTIFY suffixTextChanged)
    Q_PROPERTY(bool showText READ isShowText WRITE setShowText)
    Q_PROPERTY(Qt::PenCapStyle penStyle READ getPenStyle WRITE setPenStyle NOTIFY penStyleChanged)
    Q_PROPERTY(DialType dialType READ getDialType WRITE setDialType NOTIFY dialTypeChanged)
    Q_PROPERTY(QFont textFont READ getTextFont WRITE setTextFont NOTIFY textFontChanged)

public:
    RadialBar(QQuickItem *parent = 0);
    void paint(QPainter *painter);

    enum DialType {
        FullDial,
        MinToMax,
        NoDial
    };
    Q_ENUM(DialType)

    qreal getSize() {return m_Size;}
    qreal getStartAngle() {return m_StartAngle;}
    qreal getSpanAngle() {return m_SpanAngle;}
    qreal getMinValue() {return m_MinValue;}
    qreal getMaxValue() {return m_MaxValue;}
    qreal getValue() {return m_Value;}
    int getDialWidth() {return m_DialWidth;}
    QColor getBackgroundColor() {return m_BackgroundColor;}
    QColor getForegroundColor() {return m_DialColor;}
    QColor getProgressColor() {return m_ProgressColor;}
    QColor getTextColor() {return m_TextColor;}
    QString getSuffixText() {return m_SuffixText;}
    bool isShowText() {return m_ShowText;}
    Qt::PenCapStyle getPenStyle() {return m_PenStyle;}
    DialType getDialType() {return m_DialType;}
    QFont getTextFont() {return m_TextFont;}

    void setSize(qreal size);
    void setStartAngle(qreal angle);
    void setSpanAngle(qreal angle);
    void setMinValue(qreal value);
    void setMaxValue(qreal value);
    void setValue(qreal value);
    void setDialWidth(qreal width);
    void setBackgroundColor(QColor color);
    void setForegroundColor(QColor color);
    void setProgressColor(QColor color);
    void setTextColor(QColor color);
    void setSuffixText(QString text);
    void setShowText(bool show);
    void setPenStyle(Qt::PenCapStyle style);
    void setDialType(DialType type);
    void setTextFont(QFont font);

signals:
    void sizeChanged();
    void startAngleChanged();
    void spanAngleChanged();
    void minValueChanged();
    void maxValueChanged();
    void valueChanged();
    void dialWidthChanged();
    void backgroundColorChanged();
    void foregroundColorChanged();
    void progressColorChanged();
    void textColorChanged();
    void suffixTextChanged();
    void penStyleChanged();
    void dialTypeChanged();
    void textFontChanged();

private:
    qreal m_Size;
    qreal m_StartAngle;
    qreal m_SpanAngle;
    qreal m_MinValue;
    qreal m_MaxValue;
    qreal m_Value;
    int m_DialWidth;
    QColor m_BackgroundColor;
    QColor m_DialColor;
    QColor m_ProgressColor;
    QColor m_TextColor;
    QString m_SuffixText;
    bool m_ShowText;
    Qt::PenCapStyle m_PenStyle;
    DialType m_DialType;
    QFont m_TextFont;
};

#endif // RADIALBAR_H
