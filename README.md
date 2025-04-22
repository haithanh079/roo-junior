# RooJunior Configuration

## Description

RooJunior is a configuration system designed to enhance the functionality of the Roo AI assistant. It provides custom modes, configuration scripts, and a memory bank to tailor Roo's behavior to specific tasks and projects. This project includes scripts to install custom Roo instructions and modes, overriding the system instructions.

## Quick Install

You can quickly install RooJunior using the following command:

```bash
curl -L -o install_rooflow.sh https://raw.githubusercontent.com/haithanh079/roo-junior/refs/heads/master/config/install_rooflow.sh && chmod +x install_rooflow.sh && ./install_rooflow.sh
```

## Configuration

The RooJunior configuration is managed through the following files:

*   `.roo/`: This directory contains the system prompt files for each custom mode.
*   `.roomodes`: This file defines the custom modes for Roo, including their names, role definitions, groups, and source.
*   `.memory-bank/`: This directory stores the memory bank for the project, which can be used to store and retrieve information.

## Scripts

### `install_rooflow.sh`

This script automates the installation and configuration of RooJunior. It performs the following tasks:

*   Clones the RooJunior repository from GitHub.
*   Copies the necessary configuration files and directories to the project root.
*   Sets permissions for the `insert-variables.sh` script.
*   Runs the `insert-variables.sh` script to insert environment variables into the system prompt files.
*   Removes the temporary clone directory and the `insert-variables.sh` script.
*   Schedules self-deletion of `install_rooflow.sh`.

### `insert-variables.sh`

This script inserts environment variables into the system prompt files located in the `.roo` directory. It performs the following tasks:

*   Detects the operating system (macOS or Linux).
*   Sets the `OS`, `SHELL`, `HOME`, and `WORKSPACE` variables.
*   Loops through each system prompt file in the `.roo` directory.
*   Uses `sed` to replace placeholders in the system prompt files with the corresponding environment variables.

## Custom Modes

The `.roomodes` file defines the custom modes for Roo. Each mode has the following properties:

*   `slug`: A unique identifier for the mode.
*   `name`: The display name of the mode.
*   `roleDefinition`: A description of the mode's role and responsibilities.
*   `groups`: A list of groups that the mode belongs to.
*   `source`: The source of the mode (e.g., "global" or "project").
*   `file_pattern`: (Optional) A glob pattern to filter files that the mode can edit.

The following custom modes are defined in this project:

*   `default`: A custom, global mode in Roo Code, using the Roo Code default rules and instructions, along with the custom instruction set for memory bank functionality.
*   `architect`: Focuses on system design, documentation structure, and project organization.
*   `code`: An expert Unity Developer who excels in building high-performance, clean, and low-level optimized C# solutions for complex game systems.
*   `debug`: An expert software debugger specializing in systematic problem diagnosis and resolution for complex software systems.
*   `ask`: A knowledgeable technical assistant focused on answering questions and providing information about software development, technology, and related topics.
*   `test`: Responsible for test-driven development, test execution, and quality assurance.
*   `boomerang`: A strategic workflow orchestrator who coordinates complex tasks by delegating them to appropriate specialized modes.
*   `configurator`: A Roo AI expert who understands how Roo configuration works and helps users to update and adapt Roo configuration to their needs.

## Memory Bank

The `.memory-bank` directory stores the memory bank for the project. This directory can be used to store and retrieve information that is relevant to the project.

## Contribution Guidelines

We welcome contributions to RooJunior! To contribute, please follow these steps:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Make your changes and commit them with clear, concise commit messages.
4.  Submit a pull request.

## Issue Reporting

If you encounter any issues with RooJunior, please report them on the [GitHub issue tracker](https://github.com/haithanh079/roo-junior/issues).
