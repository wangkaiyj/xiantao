import QtQuick 2.13

Canvas {
    id: canvas

    enum Direction {
        Up,
        Down,
        Left,
        Right
    }

    property int direction: Arrow.Up
    property color themeColor: "#626262"

    onDirectionChanged: requestPaint()
    onThemeColorChanged: requestPaint()
    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var context = canvas.getContext("2d");
        context.clearRect(0,0,width,height);
        var point1 = Qt.point(0,0);
        var point2 = Qt.point(0,0);
        var point3 = Qt.point(0,0);
        switch(canvas.direction) {
        case Arrow.Up:
            point1 = Qt.point(0,height);
            point2 = Qt.point(width/2,0);
            point3 = Qt.point(width,height);
            break;
        case Arrow.Down:
            point1 = Qt.point(0,0);
            point2 = Qt.point(width/2,height);
            point3 = Qt.point(width,0);
            break;
        case Arrow.Left:
            point1 = Qt.point(width,0);
            point2 = Qt.point(width,height);
            point3 = Qt.point(0,height/2);
            break;
        case Arrow.Right:
            point1 = Qt.point(0,0);
            point2 = Qt.point(width,height/2);
            point3 = Qt.point(0,height);
            break;
        }
        context.beginPath();
        context.moveTo(point1.x,point1.y);
        context.lineTo(point2.x, point2.y);
        context.lineTo(point3.x, point3.y);
        context.fillStyle = canvas.themeColor;
        context.closePath();
        context.fill();
    }
}
