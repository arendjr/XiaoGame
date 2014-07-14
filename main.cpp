#include <QApplication>
#include <VPApplication>

#include <QQmlApplicationEngine>


int main(int argc, char *argv[]) {

    QApplication app(argc, argv);

    VPApplication vplay;

    // QQmlApplicationEngine is the preffered way to start qml projects since Qt 5.2
    // if you have older projects using Qt App wizards from previous QtCreator versions than 3.1, please change them to QQmlApplicationEngine
    QQmlApplicationEngine engine;
    vplay.initialize(&engine);

    vplay.setMainQmlFileName(QStringLiteral("qml/Main.qml"));

    vplay.setContentScaleAndFileSelectors(1);

    // use this instead of the above call to avoid deployment of the qml files and compile them into the binary with qt's resource system qrc
    // this is the preferred deployment option for debug and release builds on mobile, and for publish builds on all platforms
    // to avoid deployment of your qml files and images, also comment the DEPLOYMENTFOLDERS command in the .pro file
    // only use the above non-qrc approach, during development on desktop
    //  vplay.setMainQmlFileName(QStringLiteral("qrc:/qml/main.qml"));

    engine.load(QUrl(vplay.mainQmlFileName()));

    return app.exec();
}

