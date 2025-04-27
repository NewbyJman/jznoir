#include "../include/HistoryManager.h"

HistoryManager::HistoryManager(QObject *parent)
    : QObject(parent)
{}

void HistoryManager::visit(const QString &view)
{
    m_backStack.push(view);
    m_forwardStack.clear();
    emit historyChanged();
}

void HistoryManager::goBack()
{
    if (canGoBack()) {
        QString view = m_backStack.pop();
        m_forwardStack.push(view);
        emit navigateTo(m_backStack.top());
        emit historyChanged();
    }
}

void HistoryManager::goForward()
{
    if (canGoForward()) {
        QString view = m_forwardStack.pop();
        m_backStack.push(view);
        emit navigateTo(view);
        emit historyChanged();
    }
}

bool HistoryManager::canGoBack() const
{
    return m_backStack.size() > 1;
}

bool HistoryManager::canGoForward() const
{
    return !m_forwardStack.isEmpty();
}
