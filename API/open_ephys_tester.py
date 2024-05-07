import os
import json

# Function to create the directory structure and write the structure.oebin file
def create_open_ephys_structure(output_dir, channels_metadata, events_metadata):
    # Create continuous directory
    continuous_dir = os.path.join(output_dir, "continuous")
    os.makedirs(continuous_dir, exist_ok=True)

    # Create events directory
    events_dir = os.path.join(output_dir, "events")
    os.makedirs(events_dir, exist_ok=True)

    # Write continuous metadata to structure.oebin
    continuous_metadata = {
        "GUI version": "0.6.6",
        "continuous": [],
        "events": events_metadata,
        "spikes": []
    }

    for channel_metadata in channels_metadata:
        channel_folder = f"Ephys_Socket-{channel_metadata['source_processor_id']}.EphysSocketStream"
        channel_metadata["folder_name"] = os.path.join(continuous_dir, channel_folder)
        continuous_metadata["continuous"].append(channel_metadata)

    with open(os.path.join(output_dir, "structure.oebin"), "w") as f:
        json.dump(continuous_metadata, f, indent=4)

    # Create sync_message.txt
    with open(os.path.join(output_dir, "sync_message.txt"), "w") as f:
        f.write("")

    print("Open Ephys directory structure created successfully.")

# Example metadata for channels and events
channels_metadata = [
    {
        "channel_name": "CH1",
        "description": "Channel acquired via network stream",
        "identifier": "",
        "history": "Ephys Socket -> Record Node",
        "bit_volts": 0.1949999928474426,
        "units": "",
        "sample_rate": 12000.0,
        "source_processor_id": 108
    },
    # Add metadata for other channels as needed
]

events_metadata = [
    {
        "folder_name": "Ephys_Socket-108.EphysSocketStream/TTL/",
        "channel_name": "Events",
        "description": "Events acquired via network stream",
        "identifier": "ephyssocket.events",
        "sample_rate": 12000.0,
        "type": "int16",
        "source_processor": "Ephys Socket",
        "stream_name": "EphysSocketStream",
        "initial_state": 0
    },
    {
        "folder_name": "MessageCenter/",
        "channel_name": "Messages",
        "description": "Broadcasts messages from the MessageCenter",
        "identifier": "messagecenter.events",
        "sample_rate": 12000.0,
        "type": "string",
        "source_processor": "Message Center",
        "stream_name": "EphysSocketStream"
    }
    # Add metadata for other events as needed
]

# Output directory where the Open Ephys structure will be created
output_dir = ""

# Create Open Ephys directory structure
create_open_ephys_structure(output_dir, channels_metadata, events_metadata)
