#!/bin/bash

# --- Get Environment Variables Correctly ---
if [[ "$(uname)" == "Darwin" ]]; then
    # macOS specific
    OS="macOS $(sw_vers -productVersion)"
    SED_IN_PLACE=(-i "")
else
    # Linux specific
    OS=$(uname -s -r)
    SED_IN_PLACE=(-i)
fi

SHELL="bash"  # Hardcode to bash since we're explicitly using it
HOME=$(echo "$HOME")  # Use existing $HOME, but quote it
WORKSPACE=$(pwd)

# --- Directory Setup ---
ROO_DIR="$WORKSPACE/.roo"

# Check if the .roo directory exists
if [ ! -d "$ROO_DIR" ]; then
  echo "Error: .roo directory not found in $WORKSPACE"
  exit 1
fi

# --- Function to escape strings for sed ---
escape_for_sed() {
    echo "$1" | sed 's/[\/&]/\\&/g'
}

# --- Perform Replacements using sed ---
find "$ROO_DIR" -type f -name "system-prompt-*" -print0 | while IFS= read -r -d $'\0' file; do
  echo "Processing: $file"
  
  # Basic variables - using sed with escaped strings
  sed "${SED_IN_PLACE[@]}" "s/OS_PLACEHOLDER/$(escape_for_sed "$OS")/g" "$file"
  sed "${SED_IN_PLACE[@]}" "s/SHELL_PLACEHOLDER/$(escape_for_sed "$SHELL")/g" "$file"
  sed "${SED_IN_PLACE[@]}" "s|HOME_PLACEHOLDER|$(escape_for_sed "$HOME")|g" "$file"
  sed "${SED_IN_PLACE[@]}" "s|WORKSPACE_PLACEHOLDER|$(escape_for_sed "$WORKSPACE")|g" "$file"

  echo "Completed: $file"
done

# --- Load and process roomodes ---
if ! command -v jq &> /dev/null
then
  echo "jq is not installed. Installing..."
  if [[ "$(uname)" == "Darwin" ]]; then
    brew install jq
  else
    apt-get update && apt-get install -y jq
  fi
fi

ROOMODES_FILE="config/.roomodes"
if [ -f "$ROOMODES_FILE" ]; then
  echo "Processing roomodes from $ROOMODES_FILE"
  
  # Loop through each mode in the JSON
  jq -r '.customModes[] | @base64' "$ROOMODES_FILE" | while read -r mode_base64; do
    mode_json=$(echo "$mode_base64" | base64 --decode)
    
    # Extract mode details
    mode_slug=$(echo "$mode_json" | jq -r '.slug')
    mode_name=$(echo "$mode_json" | jq -r '.name')
    mode_role_definition=$(echo "$mode_json" | jq -r '.roleDefinition' | sed 's/"/\\"/g')
    mode_role_instruction=$(echo "$mode_json" | jq -r '.roleCustomInstruction' | sed 's/"/\\"/g')
    
    # Create the system prompt file
    SYSTEM_PROMPT_FILE="$ROO_DIR/system-prompt-$mode_slug"
    echo "Creating system prompt file: $SYSTEM_PROMPT_FILE"
    
    # Read the content of the sample system prompt file
    SAMPLE_PROMPT_FILE="config/.roo/.system-prompt-sample"
    if [ -f "$SAMPLE_PROMPT_FILE" ]; then
      SAMPLE_PROMPT_CONTENT=$(cat "$SAMPLE_PROMPT_FILE")
      
      # Write the content to the new system prompt file
      echo "$SAMPLE_PROMPT_CONTENT" > "$SYSTEM_PROMPT_FILE"
      
      # Perform replacements
      sed -i "" "s/ROLE_DEFINITION_PLACEHOLDER/$mode_role_definition/g" "$SYSTEM_PROMPT_FILE"
      sed -i "" "s/ROLE_CUSTOM_INSTRUCTION_PLACEHOLDER/$mode_role_instruction/g" "$SYSTEM_PROMPT_FILE"
      
      echo "Replacements completed for: $SYSTEM_PROMPT_FILE"
    else
      echo "Error: Sample prompt file not found: $SAMPLE_PROMPT_FILE"
    fi
    
    echo "Completed processing mode: $mode_name"
  done
  
  echo "Completed processing all roomodes."
else
  echo "Error: Roomodes file not found: $ROOMODES_FILE"
fi

echo "Done."