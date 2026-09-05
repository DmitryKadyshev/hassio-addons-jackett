# Documentation

## Usage

After installing the add-on, open the Web UI from the Home Assistant add-on page. Jackett listens on port `9117`.

## Data

Jackett stores its configuration under `/config`. The add-on maps this directory to Home Assistant's persistent add-on configuration storage.

## Updates

The container downloads the selected Jackett release during the image build. Runtime updates are disabled with `--NoUpdates`; update the add-on image to move to a newer Jackett release.
