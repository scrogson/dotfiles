import QtQuick
import Quickshell
import Quickshell.Io
import qs.Ui
import qs.Commons

// CPU, memory, and root-disk usage, e.g. "󰍛 12  󰘚 43  󰋊 54".
// Hover for details; click to open btop. A value at or above `warnAt`
// percent turns the bar's urgent color.
BarWidget {
  id: root
  moduleName: "sysstats"

  readonly property int warnAt: settings && settings.warnAt ? settings.warnAt : 90
  readonly property string diskPath: settings && settings.disk ? settings.disk : "/"

  property int cpu: 0
  property int mem: 0
  property int disk: 0
  property real memUsedGiB: 0
  property real memTotalGiB: 0
  property real swapUsedGiB: 0
  property real swapTotalGiB: 0
  property real diskUsedGiB: 0
  property real diskTotalGiB: 0
  property string loadAvg: ""

  property var lastCpu: null

  readonly property var stats: [
    { icon: String.fromCodePoint(0xF035B), value: cpu },
    { icon: String.fromCodePoint(0xF061A), value: mem },
    { icon: String.fromCodePoint(0xF02CA), value: disk }
  ]

  function gib(kib) { return kib / 1048576 }
  function fmt(v) { return v.toFixed(1) }

  function parseCpu(text) {
    var f = text.split("\n")[0].trim().split(/\s+/).slice(1).map(Number)
    // idle + iowait count as idle time.
    var idle = f[3] + (f[4] || 0)
    var total = 0
    for (var i = 0; i < Math.min(f.length, 8); i++) total += f[i]
    if (lastCpu) {
      var dt = total - lastCpu.total
      var di = idle - lastCpu.idle
      if (dt > 0) cpu = Math.round(100 * (dt - di) / dt)
    }
    lastCpu = { total: total, idle: idle }
  }

  function parseMem(text) {
    var m = {}
    text.split("\n").forEach(function (line) {
      var parts = line.split(/:\s+/)
      if (parts.length === 2) m[parts[0]] = parseInt(parts[1])
    })
    if (!m.MemTotal) return
    var used = m.MemTotal - (m.MemAvailable || 0)
    mem = Math.round(100 * used / m.MemTotal)
    memUsedGiB = gib(used)
    memTotalGiB = gib(m.MemTotal)
    swapTotalGiB = gib(m.SwapTotal || 0)
    swapUsedGiB = gib((m.SwapTotal || 0) - (m.SwapFree || 0))
  }

  function parseDisk(text) {
    var lines = text.trim().split("\n")
    if (lines.length < 2) return
    var f = lines[lines.length - 1].trim().split(/\s+/).map(Number)
    var used = f[0], size = f[1], avail = f[2]
    if (!(size > 0)) return
    // Match df's Use%: used / (used + available), which accounts for reserved space.
    disk = Math.round(100 * used / (used + avail))
    diskUsedGiB = used / 1073741824
    diskTotalGiB = size / 1073741824
  }

  readonly property string details:
    "CPU      " + cpu + "%   load " + loadAvg + "\n"
    + "Memory   " + mem + "%   " + fmt(memUsedGiB) + " / " + fmt(memTotalGiB) + " GiB\n"
    + (swapTotalGiB > 0 ? "Swap          " + fmt(swapUsedGiB) + " / " + fmt(swapTotalGiB) + " GiB\n" : "")
    + "Disk " + diskPath + "   " + disk + "%   " + fmt(diskUsedGiB) + " / " + fmt(diskTotalGiB) + " GiB\n"
    + "\nClick to open btop"

  FileView { id: statFile; path: "/proc/stat"; onLoaded: root.parseCpu(text()) }
  FileView { id: memFile; path: "/proc/meminfo"; onLoaded: root.parseMem(text()) }
  FileView {
    id: loadFile
    path: "/proc/loadavg"
    onLoaded: root.loadAvg = text().split(" ").slice(0, 3).join(" ")
  }

  Process {
    id: dfProc
    command: ["df", "-B1", "--output=used,size,avail", root.diskPath]
    stdout: StdioCollector { onStreamFinished: root.parseDisk(text) }
  }

  Timer {
    interval: 2000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: {
      statFile.reload()
      memFile.reload()
      loadFile.reload()
    }
  }

  Timer {
    interval: 30000
    running: true
    repeat: true
    triggeredOnStart: true
    onTriggered: if (!dfProc.running) dfProc.running = true
  }

  implicitWidth: button.implicitWidth
  implicitHeight: button.implicitHeight

  WidgetButton {
    id: button
    anchors.fill: parent
    bar: root.bar
    labelVisible: false
    hasVisualContent: true
    tooltipText: root.details
    fixedWidth: root.vertical ? -1 : row.implicitWidth + 2 * scaledHorizontalMargin
    fixedHeight: root.vertical ? (root.stats.length + 1) * Style.bar.iconSlot : -1
    onPressed: function (b) {
      if (root.bar) root.bar.run("omarchy-launch-or-focus-tui btop")
    }

    Row {
      id: row
      visible: !root.vertical
      anchors.centerIn: parent
      spacing: button.scaledHorizontalMargin

      Repeater {
        model: root.stats

        Row {
          required property var modelData
          spacing: 4
          anchors.verticalCenter: parent.verticalCenter
          readonly property color tint: modelData.value >= root.warnAt ? button.activeColor : button.foreground

          Text {
            textFormat: Text.PlainText
            text: modelData.icon
            opacity: 0.6
            color: parent.tint
            font.family: button.fontFamily
            font.pixelSize: button.fontSize
            renderType: Text.NativeRendering
            anchors.verticalCenter: parent.verticalCenter
          }

          Text {
            textFormat: Text.PlainText
            // Two-digit pad keeps the widget from jittering as values change.
            text: (modelData.value < 10 ? " " : "") + modelData.value + "%"
            color: parent.tint
            font.family: button.fontFamily
            font.pixelSize: button.fontSize
            font.features: { "tnum": 1 }
            renderType: Text.NativeRendering
            anchors.verticalCenter: parent.verticalCenter
          }
        }
      }
    }

    Column {
      visible: root.vertical
      anchors.fill: parent

      Repeater {
        model: root.stats

        OpticalGlyph {
          required property var modelData
          width: button.width
          height: Style.bar.iconSlot
          text: String(modelData.value)
          fontFamily: button.fontFamily
          fontSize: button.fontSize
          color: modelData.value >= root.warnAt ? button.activeColor : button.foreground
        }
      }
    }
  }
}
