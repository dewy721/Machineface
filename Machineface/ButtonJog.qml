import QtQuick 2.0
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.0
import Machinekit.Application 1.0
import Machinekit.Application.Controls 1.0

ApplicationItem {
    property var numberModel: [0.1, 1, 10, "∞"]
    property var numberModelReverse: {
        var tmp = numberModel.slice()
        tmp.reverse()
        return tmp
    }
    property var axisColors: ["#F5A9A9", "#A9F5F2", "#81F781", "#D2B48C"]
    property color allColor: "#DDD"
    property var axisNames: ["X", "Y", "Z", "A"]

    id: root

    width: height * 1.46

    Item {
        id: mainItem
        anchors.top: parent.top
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        width: height

        Label {
            anchors.centerIn: parent
            text: axisNames[0] + axisNames[1]
            font.bold: true
        }

        Button {
            anchors.left: parent.left
            anchors.top: parent.top
            action: HomeAxisAction {axis: 0}
            text: "X"
            width: parent.height * 0.2
            height: width
            style: CustomStyle { baseColor: axisColors[0] }
            iconSource: "icons/ic_home_black_48dp.png"
        }

        Button {
            anchors.right: parent.right
            anchors.top: parent.top
            action: HomeAxisAction {axis: 1}
            text: "Y"
            width: parent.height * 0.2
            height: width
            style: CustomStyle { baseColor: axisColors[1] }
            iconSource: "icons/ic_home_black_48dp.png"
        }

        Button {
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            action: HomeAxisAction {axis: 2}
            text: "Z"
            width: parent.height * 0.2
            height: width
            style: CustomStyle { baseColor: axisColors[2] }
            iconSource: "icons/ic_home_black_48dp.png"
        }

        Button {
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            action: HomeAxisAction {axis: -1}
            text: "All"
            width: parent.height * 0.2
            height: width
            style: CustomStyle { baseColor: allColor }
            iconSource: "icons/ic_home_black_48dp.png"
        }

        RowLayout {
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            width: parent.height / (numberModel.length*2+1) * numberModel.length
            height: width
            spacing: 0
            Repeater {
                model: numberModel
                JogButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.height / numberModel.length * (index+1)
                    text: numberModel[index]
                    axis: 0
                    distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                    direction: 1
                    style: CustomStyle { baseColor: axisColors[0]; darkness: index*0.06 }
                }
            }
        }

        RowLayout {
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            width: parent.height / (numberModel.length*2+1) * numberModel.length
            height: width
            spacing: 0
            Repeater {
                model: numberModelReverse
                JogButton {
                    Layout.fillWidth: true
                    Layout.preferredHeight: parent.width / numberModel.length * (numberModel.length-index)
                    text: "-" + numberModelReverse[index]
                    axis: 0
                    distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                    direction: -1
                    style: CustomStyle { baseColor: axisColors[0]; darkness: (numberModel.length-index-1)*0.06 }
                }
            }
        }

        ColumnLayout {
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height / (numberModel.length*2+1) * numberModel.length
            width: height
            spacing: 0
            Repeater {
                model: numberModelReverse
                JogButton {
                    Layout.preferredWidth: parent.width / numberModel.length * (numberModel.length-index)
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter
                    text: numberModelReverse[index]
                    axis: 1
                    distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                    direction: 1
                    style: CustomStyle { baseColor: axisColors[1]; darkness: (numberModel.length-index-1)*0.06 }
                }
            }
        }

        ColumnLayout {
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height / (numberModel.length*2+1) * numberModel.length
            width: height
            spacing: 0
            Repeater {
                model: numberModel
                JogButton {
                    Layout.preferredWidth: parent.width / numberModel.length * (index+1)
                    Layout.fillHeight: true
                    Layout.alignment: Qt.AlignHCenter
                    text: "-" + numberModel[index]
                    axis: 1
                    distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                    direction: -1
                    style: CustomStyle { baseColor: axisColors[1]; darkness: index*0.06 }
                }
            }
        }
    }

    RowLayout {
        anchors.left: mainItem.right
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: parent.top
        anchors.leftMargin: parent.height * 0.03

        Repeater {
            model: status.synced ? status.config.axes - 2 : 2

            Item {
                property int axisIndex: index
                Layout.fillWidth: true
                Layout.fillHeight: true

                Label {
                    anchors.centerIn: parent
                    text: axisNames[2+axisIndex]
                    font.bold: true
                }

                ColumnLayout {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: parent.width
                    spacing: 0
                    Repeater {
                        model: numberModelReverse
                        JogButton {
                            Layout.preferredWidth: parent.height / numberModel.length * ((numberModel.length - index - 1) * 0.2 + 1)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            text: numberModelReverse[index]
                            axis: 2 + axisIndex
                            distance: numberModelReverse[index] === "∞" ? 0 : numberModelReverse[index]
                            direction: 1
                            style: CustomStyle { baseColor: axisColors[2+axisIndex]; darkness: (numberModel.length-index-1)*0.06 }
                        }
                    }
                }

                ColumnLayout {
                    anchors.bottom: parent.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    height: parent.height / (numberModel.length*2+1) * numberModel.length
                    width: parent.width
                    spacing: 0
                    Repeater {
                        model: numberModel
                        JogButton {
                            Layout.preferredWidth: parent.height / numberModel.length * (index*0.2+1)
                            Layout.fillHeight: true
                            Layout.alignment: Qt.AlignHCenter
                            text: "-" + numberModel[index]
                            axis: 2 + axisIndex
                            distance: numberModel[index] === "∞" ? 0 : numberModel[index]
                            direction: -1
                            style: CustomStyle { baseColor: axisColors[2+axisIndex]; darkness: index*0.06 }
                        }
                    }
                }
            }
        }
    }
}
