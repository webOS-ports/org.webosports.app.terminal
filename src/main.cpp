#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQuickStyle>
#include <QUrl>

int main(int argc, char **argv)
{
    // The app manager starts us without a login environment, and the shell
    // needs a HOME to start in and to find its rc files.
    if (qEnvironmentVariableIsEmpty("HOME"))
        qputenv("HOME", "/home/root");

    // QApplication rather than QGuiApplication: QMLTermWidget still reaches
    // for QApplication-only API (clipboard helpers, QMessageBox).
    QApplication app(argc, argv);
    QQuickStyle::setStyle(QStringLiteral("QtQuick.Controls.LuneOS"));

    // The engine owns the window it creates and deletes it before itself.
    QQmlApplicationEngine engine;
    // The bus name the app manager gave this instance, under which Main.qml
    // registers with it; empty when not started by the app manager.
    engine.setInitialProperties({
        { QStringLiteral("ls2Name"), qEnvironmentVariable("LS2_NAME") },
    });
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreationFailed,
                     &app, []() { QCoreApplication::exit(1); },
                     Qt::QueuedConnection);
    engine.load(QUrl::fromLocalFile(QCoreApplication::applicationDirPath()
                                    + QStringLiteral("/qml/Main.qml")));
    if (engine.rootObjects().isEmpty())
        return 1;

    return app.exec();
}
