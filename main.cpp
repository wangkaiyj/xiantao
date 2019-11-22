#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QDateTime>
#include <QIcon>

#include "Framework/appcore.h"
#include "Framework/models.h"
#include "FramelessHelper/WindowFramelessHelper.h"
#include "Framework/imagehelper.h"

int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
    QApplication app(argc, argv);

    if (QDateTime::currentDateTime() >= QDateTime(QDate(2019, 12, 25), QTime(23, 59, 59)))
    {
        return 0;
    }

    qmlRegisterType<WindowFramelessHelper>("QtShark.Window", 1, 0, "FramelessHelper");
    qmlRegisterType<ImageHelper>("org.app.helpers", 1, 0, "ImageHelper");
    qmlRegisterType<CTableModel>("org.app.models", 1, 0, "TableModel");
    qmlRegisterType<CFilterTableModel>("org.app.models", 1, 0, "FilterTableModel");

    QQmlApplicationEngine engine;
    CAppCore* appCore = new CAppCore(&app);
    appCore->init();
    engine.rootContext()->setContextProperty("appCore", appCore);
    const QUrl url(QStringLiteral("qrc:/qmls/Main.qml"));
    QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
                     &app, [url](QObject * obj, const QUrl & objUrl)
    {
        if (!obj && url == objUrl)
            QCoreApplication::exit(-1);
    }, Qt::QueuedConnection);
    engine.load(url);

    appCore->updateInfomation();

    return app.exec();
}
