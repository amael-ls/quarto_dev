# Siunitx-quarto - Lua filter For Quarto

## Overview
This is a Quarto extension that handles the commands from the package [siunitx](https://ctan.org/pkg/siunitx?lang=en) developed by [Joseph Wright](https://github.com/josephwright). It has been written with two outputs in mind: `html` and `latex/pdf`.

## Install

To install this extension in your current directory (or into the Quarto project that you're currently working in), use the following command:
```bash
quarto add amael-ls/quarto_dev/siunitx-quarto
```
This will install the extension under the `_extensions` subdirectory.

## Usage
Just type the siunitx commands in Quarto as you would do in Latex (check the [MWE](example.qmd)). Nothing else to do except having a proper YAML header, such as:
```yaml
---
filters:
  - siunitx-quarto
format:
  html:
    toc: true
  pdf:
    include-in-header:
      - text: |
          \usepackage{siunitx}
---
```

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

## Issues and contributing

Issues, forking, and pull requests are all welcome!

