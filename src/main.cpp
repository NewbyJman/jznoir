#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QIcon>
#include <QtQuickControls2>

int main(int argc, char *argv[])
{
    QGuiApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QGuiApplication app(argc, argv);

    // Set a nice default style (optional, but looks better)
    QtQuickControls2::QQuickStyle::setStyle("Material");

    // Set application details
    app.setOrganizationName("JZApps");
    app.setApplicationName("JZNoir");

    QQmlApplicationEngine engine;

    // Load the main QML file
    const QUrl url(QStringLiteral("qrc:/qml/Main.qml"));
    QObject::connect(
        &engine, &QQmlApplicationEngine::objectCreated,
        &app, [url](QObject *obj, const QUrl &objUrl) {
            if (!obj && url == objUrl)
                QCoreApplication::exit(-1);
        },
        Qt::QueuedConnection
    );
    engine.load(url);

    return app.exec();
}
