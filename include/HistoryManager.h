#pragma once

#include <QObject>
#include <QStack>
#include <QString>

class HistoryManager : public QObject
{
    Q_OBJECT
public:
    explicit HistoryManager(QObject *parent = nullptr);

    void visit(const QString &view);
    
    Q_INVOKABLE void goBack();
    Q_INVOKABLE void goForward();
    Q_PROPERTY(bool canGoBack READ canGoBack NOTIFY historyChanged)
    Q_PROPERTY(bool canGoForward READ canGoForward NOTIFY historyChanged)

signals:
    void navigateTo(const QString &view);
    void historyChanged();

private:
    bool canGoBack() const;
    bool canGoForward() const;

    QStack<QString> m_backStack;
    QStack<QString> m_forwardStack;
};