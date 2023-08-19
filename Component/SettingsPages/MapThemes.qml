import QtQuick 2.15
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import GeneralMagic 2.0
import "../"

import Theme 1.0
Item {
    id:root
    property var contentItem
    signal applyTheme(var mapInfo)

    Connections {
        target: updater
        function onFinished(result) {
            if (result === GeneralMagic.Result.Ok || result === GeneralMagic.Result.UpToDate)
                contentStore.update();
            else
                console.error("Content update failed");
        }
    }

    ContentStore {
        id: contentStore
        type: ContentItem.Type.ViewStyleHighDPI
        onStatusChanged: {
            console.log("Status = " +status)
        }
    }

    ListView {
        id: list
        clip: true
        visible: true
        anchors.fill: parent
        model: contentStore
        spacing: 10
        delegate:
            ItemDelegate {
            id: control
            width: list.width
            contentItem: RowLayout {
                id: row
                spacing: 10

                IconView {
                    iconSource: modelData.imagePreview
                    Layout.maximumHeight: row.height
                    Layout.maximumWidth: row.height
                    width: height
                    height: row.height
                }

                ColumnLayout {
                    Layout.fillHeight: true
                    Layout.fillWidth: true

                    Label {
                        text: modelData.name
                        Layout.fillWidth: true
                        font.pixelSize: 20
                        font.family: "Montserrat"
                        verticalAlignment: Image.AlignVCenter
                        Layout.alignment: Qt.AlignVCenter
                        color: Theme.fontColor
                    }

                    Label {
                        text:modelData.totalSize
                        Layout.fillWidth: true
                        font.pixelSize: 20
                        font.family: "Montserrat"
                        verticalAlignment: Image.AlignVCenter
                        Layout.alignment: Qt.AlignVCenter
                        color: Theme.fontColor
                    }
                }
            }
            onClicked:{
                list.visible = false
                root.contentItem = modelData
                content.visible = true
            }
        }
    }

    BusyIndicator {
        id: busyIndicator
        z: 1
        width: 100
        height: 100
        anchors.centerIn: parent
        visible: !ServicesManager.settings.connected || contentStore.updating || updater.status !== ContentUpdater.Status.Complete
        running: visible
    }


    ColumnLayout {
        id: content
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 40
        anchors.topMargin: 40
        spacing: 20
        visible: false

        RowLayout{
            IconView {
                visible: root.contentItem.imagePreviewAvailable
                iconSource: root.contentItem.imagePreview
                Layout.maximumHeight: 55
                Layout.maximumWidth: 55
                width: 55
                height: 55
            }

            TSlider{
                width: 680
                height: 60
                checkedColor: Theme.isDarkMode ? "grey" : "#FFFFFF"
                from:0
                to:100
                stepSize: 1
                value: contentItem.completed ? 100 : contentItem.downloadProgress
            }
        }

        RowLayout {
            TButton {
                visible: root.contentItem.status !== ContentItem.Status.Completed
                text: switch (root.contentItem.status) {
                      case ContentItem.Status.Unavailable:
                          return "Download";
                      case ContentItem.Status.Completed:
                          return "Completed";
                      case ContentItem.Status.Paused:
                          return "Paused";
                      case ContentItem.Status.DownloadQueued:
                          return "Queued";
                      case ContentItem.Status.DownloadWaiting:
                      case ContentItem.Status.DownloadWaitingFreeNetwork:
                          return "Waiting";
                      case ContentItem.Status.DownloadRunning:
                          return "Downloading";
                      case ContentItem.Status.UpdateWaiting:
                          return "Update Waiting";
                      default:
                          return "Unknown status = " + root.contentItem.status
                      }
                enabled: root.contentItem.status === ContentItem.Status.Unavailable
                onClicked: root.contentItem.asyncDownload();
            }
            TButton {
                visible:enabled
                text: "Cancel"
                enabled: root.contentItem.status >= ContentItem.Status.DownloadQueued
                onClicked: root.contentItem.cancelDownload();
            }
            TButton {
                visible:enabled
                text: "Pause"
                enabled: root.contentItem.status >= ContentItem.Status.DownloadQueued
                onClicked: root.contentItem.pauseDownload();
            }
            TButton {
                visible:enabled
                text: "Resume"
                enabled: root.contentItem.status === ContentItem.Status.Paused
                onClicked: root.contentItem.asyncDownload();
            }
            TButton {
                visible:enabled
                text: "Delete"
                enabled: root.contentItem.canDeleteContent
                onClicked: {
                    stackView.pop();
                    root.contentItem.deleteContent();
                }
            }
            TButton {
                visible: enabled
                implicitWidth: 200
                text: "Apply Map Style"
                enabled: (root.contentItem.type === ContentItem.Type.ViewStyleHighDPI || root.contentItem.type === ContentItem.Type.ViewStyleNormalDPI) &&  root.contentItem.status === ContentItem.Status.Completed
                onClicked: {
                    applyTheme(root.contentItem)
                    close()
                }
            }
        }
    }
}
