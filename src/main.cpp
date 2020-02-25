#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>
#include <QtQuickControls2/QQuickStyle>

int main(int argc, char **argv)
{
    setenv("HOME", "/home/root", 0);

    QApplication app(argc, argv);
    QQuickStyle::setStyle("LuneOS");
    QQuickView view;
    
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/qml/Main.qml"));
    view.show();

    return app.exec();
}
