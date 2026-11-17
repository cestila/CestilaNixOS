//@ pragma UseQApplication
//@ pragma Env QT_QUICK_CONTROLS_STYLE=Basic

import QtQuick
import Quickshell
import "."

ShellRoot {
    Variants {
        model: Quickshell.screens
        delegate: Component {
            Bar {}
        }
    }
}
