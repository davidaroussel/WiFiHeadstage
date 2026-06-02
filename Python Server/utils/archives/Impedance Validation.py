import numpy as np
import matplotlib
matplotlib.use('TkAgg')
import matplotlib.pyplot as plt


def generate_impedance_data(num_channels=64, num_nc=32, seed=0):
    np.random.seed(seed)
    impedances = np.random.randint(0, 32769, size=num_channels)
    nc_indices = np.random.choice(num_channels, num_nc, replace=False)
    impedances[nc_indices] = -1

    return impedances, nc_indices


def format_impedance_matrix(impedances):
    print(impedances.shape)
    print(impedances)
    layout_indices = np.concatenate([
        np.arange(48, 64)[::-1],
        np.arange(32, 48),
        np.arange(16, 32)[::-1],
        np.arange(0, 16)
    ])

    matrix = impedances[layout_indices].reshape(4, 16)

    # Insert spacer row (NaNs) between row 1 and 2
    spacer = np.full((1, 16), np.nan)
    matrix_spaced = np.vstack([matrix[0:2], spacer, matrix[2:4]])

    return matrix_spaced


def plot_impedance_matrix(matrix):
    # Masks
    spacer_mask = np.isnan(matrix)
    nc_mask = (matrix == -1)

    # Mask N/C and spacer
    data = np.ma.masked_where(nc_mask | spacer_mask, matrix)

    # Colormap for impedance
    cmap = plt.cm.viridis.copy()
    cmap.set_bad(color='lightgrey')  # N/C default grey

    # Create figure
    plt.figure(figsize=(12, 8))
    ax = plt.gca()
    im = ax.imshow(data, aspect='auto', cmap=cmap, vmin=0, vmax=32768)

    # Draw spacer as white
    for y in range(matrix.shape[0]):
        for x in range(matrix.shape[1]):
            if np.isnan(matrix[y, x]):
                ax.add_patch(
                    plt.Rectangle((x-0.5, y-0.5), 1, 1, color='white')
                )

    # --- Rest of your plotting code (labels, N/C, Facing Up) ---
    label_fontsize = 10
    # CH63–48 above
    for x in range(matrix.shape[1]):
        ax.text(x, 0 - 0.55, str(63 - x), ha='center', va='bottom',
                color='black', fontsize=label_fontsize)
    # CH32–47 below
    for x in range(matrix.shape[1]):
        ax.text(x, 1 + 0.55, str(32 + x), ha='center', va='top',
                color='black', fontsize=label_fontsize)
    # CH31–16 above
    for x in range(matrix.shape[1]):
        ax.text(x, 3 - 0.55, str(31 - x), ha='center', va='bottom',
                color='black', fontsize=label_fontsize)
    # N/C in center
    for y in range(matrix.shape[0]):
        for x in range(matrix.shape[1]):
            if matrix[y, x] == -1:
                ax.text(x, y, "N/C", ha='center', va='center',
                        color='black', fontsize=8, fontweight='bold')
    # Facing Up in spacer
    spacer_row = 2
    ax.text(matrix.shape[1]/2 - 0.5, spacer_row, "Facing Up",
            ha='center', va='center', fontsize=12, fontweight='bold', color='black')

    plt.colorbar(im, label="Impedance (Ω)")
    plt.title("64-Channel Electrode Impedance Map (Dual Connector)", y=1.08)

    plt.yticks([0,1,2,3,4], ["CH63–48", "CH32–47", "", "CH31–16", "CH0–15"])
    plt.xticks(range(16), [str(i) for i in range(16)])
    plt.xlabel("Electrode index in row")
    plt.ylabel("Channel block")

    plt.tight_layout()
    plt.show()





# ---------------------------------------------------
# MAIN CODE
# ---------------------------------------------------
if __name__ == "__main__":
    impedances, nc_idx = generate_impedance_data()
    matrix = format_impedance_matrix(impedances)
    plot_impedance_matrix(matrix)

    # print("N/C channels:", nc_idx)
    # print("Raw impedance array:\n", impedances)
