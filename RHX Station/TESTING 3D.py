import sys
import os
import importlib.util
import matplotlib.cm as cm
import pandas as pd
from PyQt5.QtWidgets import (
    QApplication, QMainWindow, QVBoxLayout, QHBoxLayout, QWidget,
    QPushButton, QLabel, QSizePolicy, QCheckBox, QScrollArea
)
from PyQt5.QtCore import Qt, QTimer
from PyQt5.QtGui import QImage, QPixmap, QPainter, QColor
from matplotlib.backends.backend_qt5agg import FigureCanvasQTAgg as FigureCanvas
import matplotlib.pyplot as plt
import cv2


def load_dataset_info(py_path):
    spec = importlib.util.spec_from_file_location("dataset_module", py_path)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    return module.dataset_info


class SkeletonViewer(FigureCanvas):
    def __init__(self, csv_file, dataset_info, colors, elev=30, azim=30):
        self.df = pd.read_csv(csv_file)
        self.dataset_info = dataset_info
        self.keypoints = self.dataset_info["keypoint_info"]
        self.skeleton = self.dataset_info["skeleton_info"]
        self.current_frame = 0
        self.elev = elev
        self.azim = azim
        self.prev_x = None
        self.prev_y = None
        self.lock_mode = "XY"     # DEFAULT MODE SINCE ONLY 2D DATA
        self.instance_visibility = {}
        self.colors = colors
        self.instance_colors = {}  # map instance_id -> color

        self.fig = plt.figure()
        self.ax = self.fig.add_subplot(111, projection="3d")
        super().__init__(self.fig)

        self.draw_frame()
        self.mpl_connect("button_press_event", self.on_press)
        self.mpl_connect("button_release_event", self.on_release)
        self.mpl_connect("motion_notify_event", self.on_drag)

    def get_instances_in_current_frame(self):
        if "frame_id" in self.df.columns and "instance_id" in self.df.columns:
            frame_rows = self.df[self.df["frame_id"] == self.current_frame]
            instances = sorted(frame_rows["instance_id"].unique())
            return instances
        return [0]

    def get_max_frame(self):
        if "frame_id" in self.df.columns:
            return self.df["frame_id"].max()
        return len(self.df) - 1

    def get_instance_color(self, instance_id):
        if instance_id not in self.instance_colors:
            color = self.colors[len(self.instance_colors) % len(self.colors)]
            self.instance_colors[instance_id] = (color[0]/255, color[1]/255, color[2]/255)
        return self.instance_colors[instance_id]

    def draw_frame(self):
        self.ax.clear()
        if "frame_id" in self.df.columns:
            frame_rows = self.df[self.df["frame_id"] == self.current_frame]
            if "instance_id" in frame_rows.columns:
                frame_rows = frame_rows[frame_rows["instance_id"].apply(
                    lambda i: self.instance_visibility.get(i, True))]
        else:
            frame_rows = self.df.iloc[[self.current_frame]]

        for idx, row in frame_rows.iterrows():
            instance_id = row.get("instance_id", idx)
            points = []
            for i in range(len(self.keypoints)):
                x = row.get(f"x{i}", None)
                y = row.get(f"y{i}", None)
                if pd.notna(x) and pd.notna(y):
                    points.append((x, y, 0))
            if points:
                xs, ys, zs = zip(*points)
                rgb_color = self.get_instance_color(instance_id)
                self.ax.scatter(xs, ys, zs, c=[rgb_color], s=50)

                name_to_index = {self.keypoints[i]["name"]: i for i in range(len(self.keypoints))}
                for link_id, link_info in self.skeleton.items():
                    start_name, end_name = link_info["link"]
                    if start_name in name_to_index and end_name in name_to_index:
                        start_idx = name_to_index[start_name]
                        end_idx = name_to_index[end_name]
                        if start_idx < len(points) and end_idx < len(points):
                            xline = [points[start_idx][0], points[end_idx][0]]
                            yline = [points[start_idx][1], points[end_idx][1]]
                            zline = [points[start_idx][2], points[end_idx][2]]
                            self.ax.plot(xline, yline, zline, color=rgb_color)

        self.ax.set_xlim(self.df.filter(like="x").max().max(), self.df.filter(like="x").min().min())
        self.ax.set_ylim(self.df.filter(like="y").min().min(), self.df.filter(like="y").max().max())
        self.ax.set_zlim(1, 0)

        self.ax.grid(True)
        self.ax.set_xlabel("X")
        self.ax.set_ylabel("Y")
        self.ax.set_zlabel("Z")
        if self.lock_mode == "XY":
            self.ax.view_init(elev=90, azim=90)
        elif self.lock_mode == "XZ":
            self.ax.view_init(elev=0, azim=-90)
        elif self.lock_mode == "YZ":
            self.ax.view_init(elev=0, azim=0)
        else:
            self.ax.view_init(elev=self.elev, azim=self.azim)
        self.draw()

    def next_frame(self):
        self.current_frame = min(self.current_frame + 1, self.get_max_frame())
        self.draw_frame()

    def prev_frame(self):
        self.current_frame = max(self.current_frame - 1, 0)
        self.draw_frame()

    # Mouse handlers
    def on_press(self, event):
        self.prev_x, self.prev_y = event.x, event.y

    def on_release(self, event):
        self.prev_x, self.prev_y = None, None

    def on_drag(self, event):
        if self.lock_mode is not None or self.prev_x is None or self.prev_y is None:
            return
        dx = event.x - self.prev_x
        dy = event.y - self.prev_y
        self.azim += dx * 0.5
        self.elev -= dy * 0.5
        self.prev_x, self.prev_y = event.x, event.y
        self.draw_frame()

    def zoom_in(self):
        self.draw_frame()

    def zoom_out(self):
        self.draw_frame()

    def set_lock_mode(self, mode):
        self.lock_mode = mode
        self.draw_frame()


class MainWindow(QMainWindow):
    def __init__(self, csv_file, metadata_file, video_file=None):
        super().__init__()
        self.setWindowTitle("3D Skeleton Viewer with Video")
        self.dataset_info = load_dataset_info(metadata_file)

        self.colors = [
            (255, 0, 0),
            (0, 255, 0),
            (0, 0, 255),
            (255, 165, 0),
            (128, 0, 128)
        ]

        # Skeleton viewer
        self.skeleton_viewer = SkeletonViewer(csv_file, self.dataset_info, self.colors)

        # Video viewer
        self.video_file = video_file
        self.cap = cv2.VideoCapture(video_file) if video_file else None
        self.video_label = QLabel()
        self.video_label.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Expanding)
        self.video_label.setScaledContents(False)

        # Frame label
        self.frame_label = QLabel(f"Frame: {self.skeleton_viewer.current_frame}")
        self.frame_label.setAlignment(Qt.AlignCenter)
        self.frame_label.setStyleSheet("font-size: 48px;")

        # Buttons
        self.next_button = QPushButton("Next Frame")
        self.prev_button = QPushButton("Previous Frame")
        self.play_stop_button = QPushButton("Play")
        self.play_stop_button.setCheckable(True)
        self.fps_minus = QPushButton("-")
        self.fps_plus = QPushButton("+")
        self.fps_minus.setFixedWidth(30)
        self.fps_plus.setFixedWidth(30)
        self.fps_label = QLabel("FPS: 1")
        self.fps_label.setFixedWidth(50)
        self.fps_label.setAlignment(Qt.AlignCenter)
        self.fps = 1

        self.lock_xy = QPushButton("Lock XY")
        self.lock_xz = QPushButton("Lock XZ")
        self.lock_yz = QPushButton("Lock YZ")
        self.lock_free = QPushButton("Free 3D")

        # Scroll area for instance checkboxes (horizontal)
        self.checkbox_container = QWidget()
        self.checkbox_layout = QHBoxLayout(self.checkbox_container)
        self.checkbox_layout.setAlignment(Qt.AlignLeft | Qt.AlignTop)
        self.checkbox_scroll = QScrollArea()
        self.checkbox_scroll.setWidgetResizable(True)
        self.checkbox_scroll.setWidget(self.checkbox_container)
        self.checkbox_scroll.setHorizontalScrollBarPolicy(Qt.ScrollBarAsNeeded)
        self.checkbox_scroll.setVerticalScrollBarPolicy(Qt.ScrollBarAlwaysOff)

        # Layout
        central_widget = QWidget()
        main_layout = QVBoxLayout(central_widget)

        # Top row
        top_row = QHBoxLayout()
        left_buttons = QHBoxLayout()
        for btn in [self.lock_xy, self.lock_xz, self.lock_yz, self.lock_free]:
            left_buttons.addWidget(btn)
        right_buttons = QHBoxLayout()
        for btn in [self.prev_button, self.next_button, self.play_stop_button]:
            right_buttons.addWidget(btn)
        spacer = QWidget()
        spacer.setFixedWidth(200)
        right_buttons.addWidget(spacer)
        for btn in [self.fps_minus, self.fps_label, self.fps_plus]:
            right_buttons.addWidget(btn)
        top_row.addLayout(left_buttons)
        top_row.addWidget(spacer)
        top_row.addLayout(right_buttons)
        main_layout.addLayout(top_row)
        main_layout.addWidget(self.frame_label)

        # Third row
        third_row = QHBoxLayout()
        left_col = QVBoxLayout()
        left_col.addWidget(self.checkbox_scroll, 1)
        left_col.addWidget(self.skeleton_viewer, 9)
        third_row.addLayout(left_col, 1)
        third_row.addWidget(self.video_label, 1)
        main_layout.addLayout(third_row)
        self.setCentralWidget(central_widget)

        # Connections
        self.next_button.clicked.connect(self.next_frame)
        self.prev_button.clicked.connect(self.prev_frame)
        self.play_stop_button.clicked.connect(self.toggle_play_stop)
        self.fps_plus.clicked.connect(self.increase_fps)
        self.fps_minus.clicked.connect(self.decrease_fps)
        self.lock_xy.clicked.connect(lambda: self.skeleton_viewer.set_lock_mode("XY"))
        self.lock_xz.clicked.connect(lambda: self.skeleton_viewer.set_lock_mode("XZ"))
        self.lock_yz.clicked.connect(lambda: self.skeleton_viewer.set_lock_mode("YZ"))
        self.lock_free.clicked.connect(lambda: self.skeleton_viewer.set_lock_mode(None))

        self.timer = QTimer()
        self.timer.timeout.connect(self.next_frame)

        # Initialize checkboxes
        self.update_instance_checkboxes()
        self.update_video_frame()

    def update_instance_checkboxes(self):
        # Clear all widgets first
        for i in reversed(range(self.checkbox_layout.count())):
            widget = self.checkbox_layout.itemAt(i).widget()
            if widget:
                widget.deleteLater()

        current_instances = self.skeleton_viewer.get_instances_in_current_frame()
        for inst_id in current_instances:
            if inst_id not in self.skeleton_viewer.instance_visibility:
                self.skeleton_viewer.instance_visibility[inst_id] = True

            checkbox = QCheckBox(f"Instance {inst_id}")
            checkbox.setChecked(self.skeleton_viewer.instance_visibility[inst_id])
            checkbox.stateChanged.connect(
                lambda state, inst=inst_id: self.toggle_instance(inst, state)
            )
            self.checkbox_layout.addWidget(checkbox)

    def toggle_instance(self, instance_id, state):
        self.skeleton_viewer.instance_visibility[instance_id] = state == Qt.Checked
        self.skeleton_viewer.draw_frame()

    def resizeEvent(self, event):
        super().resizeEvent(event)
        self.update_video_frame()

    def next_frame(self):
        self.skeleton_viewer.next_frame()
        self.update_instance_checkboxes()
        self.update_video_frame()
        self.frame_label.setText(f"Frame: {self.skeleton_viewer.current_frame}")

    def prev_frame(self):
        self.skeleton_viewer.prev_frame()
        self.update_instance_checkboxes()
        self.update_video_frame()
        self.frame_label.setText(f"Frame: {self.skeleton_viewer.current_frame}")

    def toggle_play_stop(self):
        if self.play_stop_button.isChecked():
            self.play_stop_button.setText("Stop")
            self.timer.start(1000 // self.fps)
        else:
            self.play_stop_button.setText("Play")
            self.timer.stop()

    def increase_fps(self):
        self.fps = min(30, self.fps + 1)
        self.fps_label.setText(f"FPS: {self.fps}")
        if self.timer.isActive():
            self.timer.start(1000 // self.fps)

    def decrease_fps(self):
        self.fps = max(1, self.fps - 1)
        self.fps_label.setText(f"FPS: {self.fps}")
        if self.timer.isActive():
            self.timer.start(1000 // self.fps)

    def update_video_frame(self):
        if not self.cap or not self.cap.isOpened():
            return
        self.cap.set(cv2.CAP_PROP_POS_FRAMES, self.skeleton_viewer.current_frame)
        ret, frame = self.cap.read()
        if not ret or frame is None:
            if self.timer.isActive():
                self.timer.stop()
                self.play_stop_button.setText("Play")
                self.play_stop_button.setChecked(False)
            return

        overlay_frame = frame.copy()
        if "frame_id" in self.skeleton_viewer.df.columns:
            frame_rows = self.skeleton_viewer.df[
                self.skeleton_viewer.df["frame_id"] == self.skeleton_viewer.current_frame
            ]
        else:
            frame_rows = self.skeleton_viewer.df.iloc[[self.skeleton_viewer.current_frame]]

        for row in frame_rows.to_dict("records"):
            instance_id = row.get("instance_id", 0)
            if not self.skeleton_viewer.instance_visibility.get(instance_id, True):
                continue
            color = tuple(int(c * 255) for c in self.skeleton_viewer.get_instance_color(instance_id))
            color_bgr = (color[2], color[1], color[0])
            for i in range(len(self.skeleton_viewer.keypoints)):
                x = row.get(f"x{i}", None)
                y = row.get(f"y{i}", None)
                if pd.notna(x) and pd.notna(y):
                    cv2.circle(overlay_frame, (int(x), int(y)), 5, color_bgr, -1)

        overlay_frame = cv2.cvtColor(overlay_frame, cv2.COLOR_BGR2RGB)
        height, width, channel = overlay_frame.shape
        bytes_per_line = 3 * width
        qimg = QImage(overlay_frame.data, width, height, bytes_per_line, QImage.Format_RGB888)
        pixmap = QPixmap.fromImage(qimg).scaled(
            int(self.width() / 2),
            self.video_label.height(),
            Qt.KeepAspectRatio,
            Qt.SmoothTransformation
        )
        self.video_label.setPixmap(pixmap)


if __name__ == "__main__":
    primate_sequence = "1001084"
    app = QApplication(sys.argv)
    csv_file = os.path.join("Dataset", "primates", f"{primate_sequence}.csv")
    metadata_file = os.path.join("Dataset", "primates", "primate_metadata.py")
    video_file = os.path.join("Dataset", "primates", f"{primate_sequence}.mp4")
    window = MainWindow(csv_file, metadata_file, video_file)
    window.showMaximized()
    sys.exit(app.exec_())
