#ifndef TESLASETTINGS_H
#define TESLASETTINGS_H

#include <QObject>
#include <QSettings>
#define IS_DARK "IS_DARK"
class TeslaSettings : public QObject
{
    Q_OBJECT
public:
    explicit TeslaSettings(QObject *parent = nullptr);
    Q_PROPERTY(bool isDark READ isDark WRITE setIsDark NOTIFY isDarkChanged FINAL)

    bool isDark() const;
public slots:
    void setIsDark(bool newIsDark);

signals:

    void isDarkChanged();
private:
    bool m_isDark;
    QSettings _settings;
};

#endif // TESLASETTINGS_H
