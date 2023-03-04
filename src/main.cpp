#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtQuickControls2/QQuickStyle>

int main(int argc, char **argv)
{
    setenv("HOME", "/home/root", 0);

    QApplication app(argc, argv);
    QQuickStyle::setStyle("QtQuick.Controls.LuneOS");
    QQuickView view;

    view.setResizeMode(QQuickView::SizeRootObjectToView);

    // setup an initial size
    QSize screenSize = QGuiApplication::primaryScreen()->size();
    view.setWidth(screenSize.width());
    view.setHeight(screenSize.height());

    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/qml/Main.qml"));
    view.show();

    return app.exec();
}
