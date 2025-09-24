import sys
import numpy as np
from PyQt5.QtWidgets import QApplication, QMainWindow, QVBoxLayout, QWidget, QPushButton, QHBoxLayout
from PyQt5.QtCore import QTimer
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
from matplotlib.figure import Figure
from mpl_toolkits.mplot3d.art3d import Line3DCollection

class CubeViewer(FigureCanvas):
    def __init__(self, parent=None):
        fig = Figure()
        self.ax = fig.add_subplot(111, projection='3d')
        super().__init__(fig)
        self.setParent(parent)

        # Cube vertices
        self.base_vertices = np.array([
            [-1, -1, -1],
            [ 1, -1, -1],
            [ 1,  1, -1],
            [-1,  1, -1],
            [-1, -1,  1],
            [ 1, -1,  1],
            [ 1,  1,  1],
            [-1,  1,  1]
        ])
        self.vertices = self.base_vertices.copy()

        self.edges = [(0,1),(1,2),(2,3),(3,0),
                      (4,5),(5,6),(6,7),(7,4),
                      (0,4),(1,5),(2,6),(3,7)]

        # Camera angles
        self.elev = 20
        self.azim = 30
        self.prev_x, self.prev_y = None, None

        # Animation parameters
        self.duration = 5000
        self.timer_interval = 50
        self.t = 0
        self.forward = True

        # Zoom factor
        self.zoom = 1.0

        self.draw_cube()

        # Timer for movement
        self.timer = QTimer()
        self.timer.timeout.connect(self.update_animation)
        self.timer.start(self.timer_interval)

        # Mouse control
        self.mpl_connect("button_press_event", self.on_press)
        self.mpl_connect("button_release_event", self.on_release)
        self.mpl_connect("motion_notify_event", self.on_drag)

    def draw_cube(self):
        self.ax.cla()
        lines = [[self.vertices[start], self.vertices[end]] for start, end in self.edges]
        lc = Line3DCollection(lines, colors='blue')
        self.ax.add_collection3d(lc)

        lim = 5 / self.zoom
        self.ax.set_xlim([-lim, lim])
        self.ax.set_ylim([-lim, lim])
        self.ax.set_zlim([-lim, lim])
        self.ax.set_xticks([-4, -2, 0, 2, 4])
        self.ax.set_yticks([-4, -2, 0, 2, 4])
        self.ax.set_zticks([-4, -2, 0, 2, 4])

        # Remove tick labels (units)
        self.ax.set_xticklabels([])
        self.ax.set_yticklabels([])
        self.ax.set_zticklabels([])

        self.ax.set_xlabel('X')
        self.ax.set_ylabel('Y')
        self.ax.set_zlabel('Z')
        self.ax.view_init(elev=self.elev, azim=self.azim)
        self.draw()

    # Mouse handlers
    def on_press(self, event):
        self.prev_x, self.prev_y = event.x, event.y

    def on_release(self, event):
        self.prev_x, self.prev_y = None, None

    def on_drag(self, event):
        if self.prev_x is None or self.prev_y is None:
            return
        dx = event.x - self.prev_x
        dy = event.y - self.prev_y
        self.azim += dx * 0.5
        self.elev -= dy * 0.5
        self.prev_x, self.prev_y = event.x, event.y
        self.draw_cube()

    # Zoom buttons
    def zoom_in(self):
        self.zoom *= 1.2
        self.draw_cube()

    def zoom_out(self):
        self.zoom /= 1.2
        self.draw_cube()

    # Animation update
    def update_animation(self):
        self.t += self.timer_interval
        if self.t >= self.duration:
            self.t = 0
            self.forward = not self.forward

        alpha = self.t / self.duration
        if not self.forward:
            alpha = 1 - alpha

        offset = np.array([0, 0, 4*(1-alpha) - 2])
        self.vertices = self.base_vertices + offset
        self.draw_cube()

class MainWindow(QMainWindow):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("3D Moving Cube with Zoom Buttons on Top")
        widget = QWidget()
        layout = QVBoxLayout(widget)

        # Buttons for zoom at the top
        btn_layout = QHBoxLayout()
        zoom_in_btn = QPushButton("Zoom In")
        zoom_in_btn.clicked.connect(self.zoom_in)
        zoom_out_btn = QPushButton("Zoom Out")
        zoom_out_btn.clicked.connect(self.zoom_out)
        btn_layout.addWidget(zoom_in_btn)
        btn_layout.addWidget(zoom_out_btn)
        layout.addLayout(btn_layout)

        # Cube viewer below buttons
        self.viewer = CubeViewer()
        layout.addWidget(self.viewer)

        self.setCentralWidget(widget)
        self.showMaximized()

    # Redirect buttons to cube viewer
    def zoom_in(self):
        self.viewer.zoom_in()

    def zoom_out(self):
        self.viewer.zoom_out()

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = MainWindow()
    sys.exit(app.exec_())
