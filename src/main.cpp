#include <QtWidgets/QApplication>
#include <QtQuick/QQuickView>

int main(int argc, char **argv)
{
    QApplication app(argc, argv);

    QQuickView view;
    
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.setSource(QUrl::fromLocalFile("qml/Main.qml"));
    view.show();

    return app.exec();
}
