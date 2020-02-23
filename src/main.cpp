#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>

int main(int argc, char **argv)
{
    setenv("HOME", "/home/root", 0);

    QApplication app(argc, argv);

    QQuickView view;
    
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl::fromLocalFile(QCoreApplication::applicationDirPath() + "/qml/Main.qml"));
    view.show();

    return app.exec();
}
