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

#include <QPainter>

#include "radialbar.h"

RadialBar::RadialBar(QQuickItem *parent)
    : QQuickPaintedItem(parent),
      m_Size(200),
      m_StartAngle(40),
      m_SpanAngle(280),
      m_MinValue(0),
      m_MaxValue(100),
      m_Value(50),
      m_DialWidth(15),
      m_BackgroundColor(Qt::transparent),
      m_DialColor(QColor(80,80,80)),
      m_ProgressColor(QColor(135,26,5)),
      m_TextColor(QColor(0, 0, 0)),
      m_SuffixText(""),
      m_ShowText(true),
      m_PenStyle(Qt::FlatCap),
      m_DialType(DialType::MinToMax)
{
    setWidth(200);
    setHeight(200);
    setSmooth(true);
    setAntialiasing(true);
}

void RadialBar::paint(QPainter *painter)
{
    double startAngle;
    double spanAngle;
    qreal size = qMin(this->width(), this->height());
    setWidth(size);
    setHeight(size);
    QRectF rect = this->boundingRect();
    painter->setRenderHint(QPainter::Antialiasing);
    QPen pen = painter->pen();
    pen.setCapStyle(m_PenStyle);

    startAngle = -90 - m_StartAngle;
    if(FullDial != m_DialType)
    {
        spanAngle = 0 - m_SpanAngle;
    }
    else
    {
        spanAngle = -360;
    }

    //Draw outer dial
    painter->save();
    pen.setWidth(m_DialWidth);
    pen.setColor(m_DialColor);
    painter->setPen(pen);
    qreal offset = m_DialWidth / 2;
    if(m_DialType == MinToMax)
    {
        painter->drawArc(rect.adjusted(offset, offset, -offset, -offset), startAngle * 16, spanAngle * 16);
    }
    else if(m_DialType == FullDial)
    {
        painter->drawArc(rect.adjusted(offset, offset, -offset, -offset), -90 * 16, -360 * 16);
    }
    else
    {
        //do not draw dial
    }
    painter->restore();

    //Draw background
    painter->save();
    painter->setBrush(m_BackgroundColor);
    painter->setPen(m_BackgroundColor);
    qreal inner = offset * 2;
    painter->drawEllipse(rect.adjusted(inner, inner, -inner, -inner));
    painter->restore();

    //Draw progress text with suffix
    painter->save();
    painter->setFont(m_TextFont);
    pen.setColor(m_TextColor);
    painter->setPen(pen);
    if(m_ShowText)
    {
        painter->drawText(rect.adjusted(offset, offset, -offset, -offset), Qt::AlignCenter,QString::number(m_Value) + m_SuffixText);
    }
    else
    {
        painter->drawText(rect.adjusted(offset, offset, -offset, -offset), Qt::AlignCenter, m_SuffixText);
    }
    painter->restore();

    //Draw progress bar
    painter->save();
    pen.setWidth(m_DialWidth);
    pen.setColor(m_ProgressColor);
    qreal valueAngle = ((m_Value - m_MinValue)/(m_MaxValue - m_MinValue)) * spanAngle;  //Map value to angle range
    painter->setPen(pen);
    painter->drawArc(rect.adjusted(offset, offset, -offset, -offset), startAngle * 16, valueAngle * 16);
    painter->restore();
}

void RadialBar::setSize(qreal size)
{
    if(m_Size == size)
        return;
    m_Size = size;
    emit sizeChanged();
}

void RadialBar::setStartAngle(qreal angle)
{
    if(m_StartAngle == angle)
        return;
    m_StartAngle = angle;
    emit startAngleChanged();
}

void RadialBar::setSpanAngle(qreal angle)
{
    if(m_SpanAngle == angle)
        return;
    m_SpanAngle = angle;
    emit spanAngleChanged();
}

void RadialBar::setMinValue(qreal value)
{
    if(m_MinValue == value)
        return;
    m_MinValue = value;
    emit minValueChanged();
}

void RadialBar::setMaxValue(qreal value)
{
    if(m_MaxValue == value)
        return;
    m_MaxValue = value;
    emit maxValueChanged();
}

void RadialBar::setValue(qreal value)
{
    if(m_Value == value)
        return;
    m_Value = value;
    update();   //update the radialbar
    emit valueChanged();
}

void RadialBar::setDialWidth(qreal width)
{
    if(m_DialWidth == width)
        return;
    m_DialWidth = width;
    emit dialWidthChanged();
}

void RadialBar::setBackgroundColor(QColor color)
{
    if(m_BackgroundColor == color)
        return;
    m_BackgroundColor = color;
    emit backgroundColorChanged();
}

void RadialBar::setForegroundColor(QColor color)
{
    if(m_DialColor == color)
        return;
    m_DialColor = color;
    emit foregroundColorChanged();
}

void RadialBar::setProgressColor(QColor color)
{
    if(m_ProgressColor == color)
        return;
    m_ProgressColor = color;
    emit progressColorChanged();
}

void RadialBar::setTextColor(QColor color)
{
    if(m_TextColor == color)
        return;
    m_TextColor = color;
    emit textColorChanged();
}

void RadialBar::setSuffixText(QString text)
{
    if(m_SuffixText == text)
        return;
    m_SuffixText = text;
    emit suffixTextChanged();
}

void RadialBar::setShowText(bool show)
{
    if(m_ShowText == show)
        return;
    m_ShowText = show;
}

void RadialBar::setPenStyle(Qt::PenCapStyle style)
{
    if(m_PenStyle == style)
        return;
    m_PenStyle = style;
    emit penStyleChanged();
}

void RadialBar::setDialType(RadialBar::DialType type)
{
    if(m_DialType == type)
        return;
    m_DialType = type;
    emit dialTypeChanged();
}

void RadialBar::setTextFont(QFont font)
{
    if(m_TextFont == font)
        return;
    m_TextFont = font;
    emit textFontChanged();
}
