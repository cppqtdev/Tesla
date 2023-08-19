#include "teslasettings.h"

TeslaSettings::TeslaSettings(QObject *parent)
    : QObject{parent}
{
    m_isDark = _settings.value(IS_DARK,false).toBool();
}

bool TeslaSettings::isDark() const
{
    return m_isDark;
}

void TeslaSettings::setIsDark(bool newIsDark)
{
    if (m_isDark == newIsDark)
        return;
    m_isDark = newIsDark;
    _settings.setValue(IS_DARK, m_isDark);
    emit isDarkChanged();
}
