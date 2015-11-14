import QtQuick 2.0
import QtQuick.Controls 1.0
import '.'

ApplicationWindow {
    id: root
    width: 1024
    height: 768

    property int smallFontSize: 8
    property int largeFontSize: 24

    property var availableFonts: ['Elusive Icons', 'Font Awesome', 'Typicons']
    property string currentFontName: fontSelector.currentText
    property var currentFont: currentFontName === 'Elusive Icons'? ElusiveIcons :
                              currentFontName === 'Font Awesome'? FontAwesome :
                                                                  Typicons

    property alias searchTerm: searchField.text

    title: currentFontName
    color: 'white'

    Rectangle {
        id: header
        color: "black"
        anchors.left: parent.left
        anchors.right: parent.right
        height: Math.max(fontSelector.height, searchField.height)*3

        ComboBox {
            id: fontSelector
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.margins: characterWidthLarge
            model: availableFonts
            currentIndex: 1

            width: (largestItem(availableFonts).length + 3)*characterWidth
        }

        TextField {
            id: searchField
            placeholderText: qsTr("Search...")
            anchors.left: fontSelector.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.margins: characterWidthLarge
        }
    }

    GridView {
        id: grid
        width: parseInt(parent.width/cellWidth)*cellWidth
        anchors.bottom: parent.bottom
        anchors.top: header.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true

        model: filter(currentFont.icons, searchTerm)

        property string longestName: largestItem(model)
        cellHeight: 2*characterHeightLarge + 2*characterHeight
        cellWidth: Math.max(characterWidthLarge*3,
                            characterWidth*longestName.length +4*characterWidth)

        delegate: Rectangle {
            visible: searchTerm === '' || modelData.indexOf(searchTerm) > -1
            width: visible? grid.cellWidth : 0
            height: visible? grid.cellHeight : 0

            border.color: mouseArea.containsMouse? 'black' : 'transparent'
            radius: height*0.125

            Behavior on border.color { ColorAnimation { duration: 200 } }

            Text {
                id: icon
                anchors.centerIn: parent
                font.pointSize: largeFontSize
                font.family: currentFont.fontName
                text: currentFont.icon[modelData]
            }
            Text {
                id: name
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                text: modelData
            }

            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
            }
        }

    }


    Text {
        id: dummyText
        visible: false
        text: 'A'
    }

    Text {
        id: dummyTextLarge
        visible: false
        text: 'A'
        font.pointSize: 20
    }

    property int characterWidth: dummyText.width
    property int characterHeight: dummyText.height
    property int characterWidthLarge: dummyTextLarge.width
    property int characterHeightLarge: dummyTextLarge.height

    function largestItem(model)
    {
        var result = ''
        for(var i in model)
            result = model[i].length > result.length? model[i] : result
        return result
    }

    function filter(model, searchTerm)
    {
        var result = []
        var searchLowercase = searchTerm.toLowerCase()
        for(var i in model)
            if(model[i].toLowerCase().indexOf(searchTerm) > -1)
                result.push(model[i])
        return result
    }
}
