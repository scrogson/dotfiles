import QtQuick
import Quickshell
import qs.Ui
import qs.Commons

// UTC clock shown as Zulu time, e.g. "14:05Z", after a dimmed slash.
BarWidget {
  id: root
  moduleName: "zulu"

  property date now: clock.date

  // Dimmed separator between the local clock and this one.
  readonly property string icon: "/"
  readonly property real iconOpacity: 0.5

  function pad(n) { return n < 10 ? "0" + n : String(n) }

  readonly property string timeText: pad(now.getUTCHours()) + ":" + pad(now.getUTCMinutes()) + "Z"
  readonly property var verticalLines: [pad(now.getUTCHours()), pad(now.getUTCMinutes()), "Z"]

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  SystemClock {
    id: clock
    precision: SystemClock.Minutes
  }

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    labelVisible: false
    hasVisualContent: true
    // No left margin: the local clock's own right margin already spaces the
    // slash, and the gap after it matches, so the slash sits evenly between.
    fixedWidth: root.vertical ? -1 : row.implicitWidth + scaledHorizontalMargin
    fixedHeight: root.vertical ? (root.verticalLines.length + 1) * Style.bar.iconSlot : -1
    horizontalMargin: 8.75
    verticalPadding: 8.75

    Row {
      id: row
      visible: !root.vertical
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter
      spacing: button.scaledHorizontalMargin

      Text {
        text: root.icon
        opacity: root.iconOpacity
        color: button.foreground
        font.family: button.fontFamily
        font.pixelSize: button.fontSize
        renderType: Text.NativeRendering
        anchors.verticalCenter: parent.verticalCenter
      }

      Text {
        text: root.timeText
        color: button.foreground
        font.family: button.fontFamily
        font.pixelSize: button.fontSize
        renderType: Text.NativeRendering
        anchors.verticalCenter: parent.verticalCenter
      }
    }

    Column {
      visible: root.vertical
      anchors.fill: parent

      OpticalGlyph {
        width: button.width
        height: Style.bar.iconSlot
        text: root.icon
        opacity: root.iconOpacity
        fontFamily: button.fontFamily
        fontSize: button.fontSize
        color: button.foreground
      }

      Repeater {
        model: root.verticalLines

        OpticalGlyph {
          required property string modelData
          width: button.width
          height: Style.bar.iconSlot
          text: modelData
          fontFamily: button.fontFamily
          fontSize: button.fontSize
          color: button.foreground
        }
      }
    }
  }
}
