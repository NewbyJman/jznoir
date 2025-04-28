#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtQuickControls2/QQuickStyle>
#include "../include/AudioEngine.h"
#include "../include/LibraryScanner.h"
#include "../include/MetadataReader.h"
#include "../include/TracksModel.h"
#include "../include/QueueManager.h"
#include "../include/HistoryManager.h"
#include "../include/SortProxyModel.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
    
    QtQuickControls2::QQuickStyle::setStyle("Material");
    app.setApplicationName("JZNoir");

    // Register backend components
    qmlRegisterType<TracksModel>("JZNoir", 1, 0, "TracksModel");
    qmlRegisterType<SortProxyModel>("JZNoir", 1, 0, "SortProxyModel");

    // Create and expose instances
    AudioEngine audioEngine;
    LibraryScanner libraryScanner;
    MetadataReader metadataReader;
    QueueManager queueManager;
    HistoryManager historyManager;

    QQmlApplicationEngine engine;
    engine.rootContext()->setContextProperty("audioEngine", &audioEngine);
    engine.rootContext()->setContextProperty("libraryScanner", &libraryScanner);
    engine.rootContext()->setContextProperty("metadataReader", &metadataReader);
    engine.rootContext()->setContextProperty("queueManager", &queueManager);
    engine.rootContext()->setContextProperty("historyManager", &historyManager);

    const QUrl url(QStringLiteral("qrc:../qml/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject *obj, const QUrl &objUrl) {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    return app.exec();
}