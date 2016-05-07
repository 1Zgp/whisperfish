
import QtQuick 2.0
import Sailfish.Silica 1.0

Page {
	id: settingsPage
    property QtObject countryCodeCombo : countryCode

    RemorsePopup { id: remorse }

	SilicaFlickable {
		anchors.fill: parent
		contentWidth: parent.width
		contentHeight: col.height + Theme.paddingLarge

        PullDownMenu {
            MenuItem {
                text: qsTr("Refresh Contacts")
                onClicked: {
                    whisperfish.refreshContacts()
                    whisperfish.refreshSessions()
                }
            }
        }

		VerticalScrollDecorator {}

		Column {
			id: col
			spacing: Theme.paddingLarge
			width: parent.width
			PageHeader {
				title: qsTr("Whisperfish Settings")
			}
            SectionHeader {
                text: qsTr("My Identity")
            }
            TextField {
                id: phone
                anchors.horizontalCenter: parent.horizontalCenter
                readOnly: true
                width: parent.width
                label: "Phone"
                text: whisperfish.phoneNumber()
            }
            TextArea {
                id: identity
                anchors.horizontalCenter: parent.horizontalCenter
                readOnly: true
                font.pixelSize: Theme.fontSizeSmall
                width: parent.width
                label: "Identity"
                text: whisperfish.identity()
            }
            SectionHeader {
                text: qsTr("Notifications")
            }
            TextSwitch {
                id: enableNotify
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Enable")
                checked: whisperfish.settings().enableNotify
                onCheckedChanged: {
                    if(checked != whisperfish.settings().enableNotify) {
                        whisperfish.settings().enableNotify = checked
                        whisperfish.saveSettings()
                    }
                }
            }
            TextSwitch {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Show Message Body")
                checked: whisperfish.settings().showNotifyMessage
                onCheckedChanged: {
                    if(checked != whisperfish.settings().showNotifyMessage) {
                        whisperfish.settings().showNotifyMessage = checked
                        whisperfish.saveSettings()
                    }
                }
            }
            SectionHeader {
                text: qsTr("General")
            }
            ValueButton {
                id: countryCode
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Country Code")
                value: whisperfish.settings().countryCode
                onClicked: {
                    var cd = pageStack.push(Qt.resolvedUrl("CountryCodeDialog.qml"))
                    cd.setCountryCode.connect(function(code) {
                        value = code
                        whisperfish.settings().countryCode = code
                        whisperfish.saveSettings()
                    })
                }
            }
            ComboBox {
                anchors.horizontalCenter: parent.horizontalCenter
                label: qsTr("Show Max Messages")
                currentIndex: {
                    if (whisperfish.settings().showMaxMessages == 5) return 0
                    else if (whisperfish.settings().showMaxMessages == 10) return 1
                    else if (whisperfish.settings().showMaxMessages == 15) return 2
                    else if (whisperfish.settings().showMaxMessages == 20) return 3
                    else if (whisperfish.settings().showMaxMessages == 50) return 4
                    else if (whisperfish.settings().showMaxMessages == 100) return 5
                    else if (whisperfish.settings().showMaxMessages == 500) return 6
                    else if (whisperfish.settings().showMaxMessages == 1000) return 7
                }
                onValueChanged: {
                    whisperfish.settings().showMaxMessages = parseInt(value)
                    whisperfish.saveSettings()
                }
                menu: ContextMenu {
                    MenuItem { text: "5"}
                    MenuItem { text: "10"}
                    MenuItem { text: "15"}
                    MenuItem { text: "20"}
                    MenuItem { text: "50"}
                    MenuItem { text: "100"}
                    MenuItem { text: "500"}
                    MenuItem { text: "1000"}
                }
            }
            TextSwitch {
                id: saveAttachments
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Save Attachments")
                checked: whisperfish.settings().saveAttachments
                onCheckedChanged: {
                    if(checked != whisperfish.settings().saveAttachments) {
                        whisperfish.settings().saveAttachments = checked
                        whisperfish.saveSettings()
                    }
                }
            }
            SectionHeader {
                text: qsTr("Advanced")
            }
            TextSwitch {
                anchors.horizontalCenter: parent.horizontalCenter
                text: qsTr("Incognito Mode")
                checked: whisperfish.settings().incognito
                onCheckedChanged: {
                    if(checked != whisperfish.settings().incognito) {
                        whisperfish.settings().incognito = checked
                        whisperfish.saveSettings()
                        remorse.execute("Restarting whisperfish...", function() { whisperfish.restart() })
                    }
                }
            }
            SectionHeader {
                text: qsTr("Statistics")
            }
            DetailItem {
                label: qsTr("Unsent Messages")
                value: whisperfish.sentQueueSize()
            }
            DetailItem {
                label: qsTr("Total Sessions")
                value: sessionModel.length
            }
            DetailItem {
                label: qsTr("Total Messages")
                value: whisperfish.totalMessages()
            }
            DetailItem {
                label: qsTr("Signal Contacts")
                value: contactsModel.len
            }
            DetailItem {
                label: qsTr("Encrypted Key Store")
                value: whisperfish.hasEncryptedKeystore() ? qsTr("Enabled") : qsTr("Disabled")
            }
            DetailItem {
                label: qsTr("Encrypted Database")
                value: whisperfish.settings().encryptDatabase ? qsTr("Enabled") : qsTr("Disabled")
            }
		}
	}
}
