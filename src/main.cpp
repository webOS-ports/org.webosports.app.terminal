#include <QtWidgets/QApplication>
#include <QtQml/QQmlEngine>
#include <QtQml/QQmlComponent>
#include <QtQuick/QQuickView>
#include <QtQuickControls2/QQuickStyle>

int main(int argc, char **argv)
{
    setenv("HOME", "/home/root", 0);
    setenv("QML_XHR_ALLOW_FILE_READ", "1", 0);

    QApplication app(argc, argv);
    QQuickStyle::setStyle("QtQuick.Controls.LuneOS");

    QQmlEngine lEngine;
    QQmlComponent *pComponent = new QQmlComponent(&lEngine, nullptr);

    pComponent->loadUrl(QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/qml/Main.qml"));
    if ( !pComponent->isReady() ) {
        qWarning("%s", qPrintable(pComponent->errorString()));
        return 1;
    }

    QObject *pTopLevelComponent = pComponent->create();
    if (pTopLevelComponent && pComponent->isError()) {
        qWarning("%s", qPrintable(pComponent->errorString()));
        return 1;
    }

    return app.exec();
}
