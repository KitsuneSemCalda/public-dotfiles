#!/usr/bin/env bash

# =============================================================================
# Environment Variables for Samsung 550XDA-KF2BR
# Optimized for: Content Creation, Gaming, Virtualization
# Hardware: Intel i5-1135G7 (TigerLake) + 8GB RAM + Iris Xe Graphics
# 
# SOURCE: Config/enviroment_config (single source of truth)
# =============================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(dirname "$SCRIPT_DIR")"
ENV_CONFIG="$PROJECT_ROOT/Config/enviroment_config"
PROFILE_FILE="$HOME/.profile"

# Verify enviroment_config exists
if [[ ! -f "$ENV_CONFIG" ]]; then
    echo "❌ Error: $ENV_CONFIG not found!"
    exit 1
fi

# Parse enviroment_config and extract variables
parse_env_config() {
    local in_section=""
    while IFS= read -r line; do
        # Skip comments and empty lines
        [[ "$line" =~ ^#.*$ ]] && continue
        [[ -z "$line" ]] && continue
        
        # Detect section headers
        if [[ "$line" =~ ^#\ (.+) ]]; then
            in_section="${BASH_REMATCH[1]}"
            continue
        fi
        
        # Extract variable=VALUE pairs
        if [[ "$line" =~ ^([A-Za-z_][A-Za-z0-9_]*)=(.*)$ ]]; then
            local var="${BASH_REMATCH[1]}"
            local val="${BASH_REMATCH[2]}"
            echo "$in_section|$var|$val"
        fi
    done < "$ENV_CONFIG"
}

# Add variable only if not exists (idempotent)
add_var() {
    local file="$1"
    local section="$2"
    local var="$3"
    local val="$4"
    
    [[ ! -f "$file" ]] && touch "$file"
    
    # Add section header if not exists
    if [[ -n "$section" ]] && ! grep -q "# === $section ===" "$file" 2>/dev/null; then
        echo "" >> "$file"
        echo "# === $section ===" >> "$file"
    fi
    
    # Add variable if not exists
    if ! grep -q "^export $var=" "$file" 2>/dev/null; then
        echo "export $var=$val" >> "$file"
    fi
}

# =============================================================================
# Load variables from enviroment_config (single source of truth)
# =============================================================================

echo "📄 Loading variables from: $ENV_CONFIG"

# Parse and apply all variables from enviroment_config
while IFS='|' read -r section var val; do
    [[ -z "$var" ]] && continue
    add_var "$PROFILE_FILE" "$section" "$var" "$val"
done < <(parse_env_config)

# =============================================================================
# Create system-wide environment file (requires sudo)
# =============================================================================

SYSTEM_ENV_FILE="/etc/environment.d/99-samsung-optimization.conf"

# Copy enviroment_config to system-wide location
if [[ -w "$(dirname "$SYSTEM_ENV_FILE")" ]]; then
    sudo cp "$ENV_CONFIG" "$SYSTEM_ENV_FILE"
    echo "✅ System-wide: $SYSTEM_ENV_FILE"
else
    echo "⚠️  Cannot write to $SYSTEM_ENV_FILE (need sudo)"
fi

echo "✅ Environment variables applied from $ENV_CONFIG"
echo "   Profile: $PROFILE_FILE"
echo "   System: $SYSTEM_ENV_FILE"
