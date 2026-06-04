import socket
import time
import numpy as np
import matplotlib

matplotlib.use('TkAgg')

import matplotlib.pyplot as plt


# =========================================================
# FORMAT IMPEDANCE MATRIX
# =========================================================
def format_impedance_matrix(impedances):

    layout_indices = np.concatenate([

        np.arange(48, 64)[::-1],
        np.arange(32, 48),

        np.arange(16, 32)[::-1],
        np.arange(0, 16)

    ])

    matrix = impedances[layout_indices].reshape(4, 16)

    # spacer row
    spacer = np.full((1, 16), np.nan)

    matrix_spaced = np.vstack([
        matrix[0:2],
        spacer,
        matrix[2:4]
    ])

    return matrix_spaced


# =========================================================
# MAIN TCP RECEIVE
# =========================================================
def tcp_receive(host="192.168.2.196", port=5000, buffer_size=8192):

    NUM_CHANNELS = 64

    MAX_IMPEDANCE = 100000

    # =====================================================
    # IMPEDANCE STORAGE
    # =====================================================

    # initialize as N/C
    impedance_values = np.full(
        NUM_CHANNELS,
        -1,
        dtype=np.float32
    )

    # =====================================================
    # MATPLOTLIB
    # =====================================================

    plt.ion()

    fig, ax = plt.subplots(figsize=(14, 8))

    matrix = format_impedance_matrix(
        impedance_values
    )

    # masks
    spacer_mask = np.isnan(matrix)
    nc_mask = (matrix == -1)

    # masked display
    data = np.ma.masked_where(
        nc_mask | spacer_mask,
        matrix
    )

    cmap = plt.cm.plasma_r.copy()

    # N/C color
    cmap.set_bad(color='lightgrey')

    im = ax.imshow(
        data,
        aspect='auto',
        cmap=cmap,
        vmin=0,
        vmax=MAX_IMPEDANCE
    )

    # =====================================================
    # DRAW WHITE SPACER
    # =====================================================

    for y in range(matrix.shape[0]):

        for x in range(matrix.shape[1]):

            if np.isnan(matrix[y, x]):

                ax.add_patch(

                    plt.Rectangle(
                        (x - 0.5, y - 0.5),
                        1,
                        1,
                        color='white'
                    )

                )

    # =====================================================
    # CHANNEL LABELS
    # =====================================================

    label_fontsize = 10

    # CH63–48
    for x in range(16):

        ax.text(
            x,
            -0.55,
            str(63 - x),
            ha='center',
            va='bottom',
            color='black',
            fontsize=label_fontsize
        )

    # CH32–47
    for x in range(16):

        ax.text(
            x,
            1 + 0.55,
            str(32 + x),
            ha='center',
            va='top',
            color='black',
            fontsize=label_fontsize
        )

    # CH31–16
    for x in range(16):

        ax.text(
            x,
            3 - 0.55,
            str(31 - x),
            ha='center',
            va='bottom',
            color='black',
            fontsize=label_fontsize
        )

    # =====================================================
    # IMPEDANCE TEXT
    # =====================================================

    text_objects = {}

    for y in range(matrix.shape[0]):

        for x in range(matrix.shape[1]):

            if np.isnan(matrix[y, x]):
                continue

            txt = ax.text(
                x,
                y,
                "N/C",
                ha='center',
                va='center',
                fontsize=8,
                fontweight='bold',
                color='black'
            )

            text_objects[(y, x)] = txt

    # =====================================================
    # FACING UP
    # =====================================================

    ax.text(
        matrix.shape[1] / 2 - 0.5,
        2,
        "Facing Up",
        ha='center',
        va='center',
        fontsize=12,
        fontweight='bold',
        color='black'
    )

    # =====================================================
    # COLORBAR
    # =====================================================

    plt.colorbar(
        im,
        label="Impedance (Ω)"
    )

    plt.title(
        "64-Channel Electrode Impedance Map",
        y=1.08
    )

    plt.yticks(
        [0, 1, 2, 3, 4],
        ["CH63–48", "CH32–47", "", "CH31–16", "CH0–15"]
    )

    plt.xticks(
        range(16),
        [str(i) for i in range(16)]
    )

    plt.xlabel("Electrode index in row")
    plt.ylabel("Channel block")

    plt.tight_layout()

    plt.show(block=False)

    # =====================================================
    # TCP SERVER
    # =====================================================

    print(f"[INFO] TCP server starting on {host}:{port}")

    while True:

        server_socket = None
        conn = None

        try:

            server_socket = socket.socket(
                socket.AF_INET,
                socket.SOCK_STREAM
            )

            server_socket.setsockopt(
                socket.SOL_SOCKET,
                socket.SO_REUSEADDR,
                1
            )

            server_socket.bind((host, port))

            server_socket.listen(1)

            print("[INFO] Waiting for client...")

            conn, addr = server_socket.accept()

            print(f"[INFO] Client connected: {addr}")

            while True:

                data = conn.recv(buffer_size)

                if data[0] == int.from_bytes(b'\xAB') and data[6] == int.from_bytes(b'\xBA'):
                    channel_number = data[1]
                    int_value = int.from_bytes(data[2:6], byteorder="big")
                    # print(f"CHANNEL NUMBER {channel_number}: {int_value} Ohm")

                if not data:

                    print("[INFO] Client disconnected.")
                    break

                # =================================================
                # IMPEDANCE PACKET
                # =================================================

                if (
                        len(data) >= 7 and
                        data[0] == 0xAB and
                        data[6] == 0xBA
                ):

                    channel = data[1]

                    impedance = int.from_bytes(
                        data[2:6],
                        byteorder="big",
                        signed=False
                    )

                    # clamp
                    impedance = min(
                        impedance,
                        MAX_IMPEDANCE
                    )

                    print(
                        f"[IMPEDANCE] "
                        f"CH {channel}: "
                        f"{impedance} Ω"
                    )

                    # =============================================
                    # UPDATE CHANNEL
                    # =============================================

                    if 0 <= channel < NUM_CHANNELS:

                        impedance_values[channel] = impedance

                        matrix = format_impedance_matrix(
                            impedance_values
                        )

                        spacer_mask = np.isnan(matrix)

                        nc_mask = (matrix == -1)

                        data_display = np.ma.masked_where(
                            nc_mask | spacer_mask,
                            matrix
                        )

                        # update image
                        im.set_data(data_display)

                        # =========================================
                        # UPDATE TEXT
                        # =========================================

                        for y in range(matrix.shape[0]):

                            for x in range(matrix.shape[1]):

                                if np.isnan(matrix[y, x]):
                                    continue

                                val = matrix[y, x]

                                txt_obj = text_objects[(y, x)]

                                if val == -1:

                                    txt_obj.set_text("N/C")

                                else:

                                    if val >= 100000:
                                        txt = "100K+"

                                    elif val >= 1000:
                                        txt = f"{val / 1000:.0f}k"

                                    else:
                                        txt = f"{int(val)}"

                                    txt_obj.set_text(txt)

                        fig.canvas.draw_idle()

                        fig.canvas.flush_events()

                    continue

        except KeyboardInterrupt:

            print("\n[INFO] Server stopped manually.")
            break

        except Exception as e:

            print(f"[ERROR] {e}")

            time.sleep(1)

        finally:

            if conn:
                conn.close()

            if server_socket:
                server_socket.close()


# =========================================================
# MAIN
# =========================================================
if __name__ == "__main__":

    tcp_receive(port=10001)