
# ----------------------------------------------------------------------
#  1. Ask for a valid *new* username
# ----------------------------------------------------------------------
while true; do
    read -rp "Enter a username you want to login as: " username
    # Username rules: must start with a lowercase letter, followed by
    # lowercase letters, digits, hyphens or underscores.
    if [[ "$username" =~ ^[a-z][-a-z0-9_]*  $ ]]; then
        break
    else
        echo "⚠️  Invalid username. Use lowercase letters, digits, underscores; must start with a letter."
    fi
done

# ----------------------------------------------------------------------
#  2. Read and confirm the password for the new user
# ----------------------------------------------------------------------
while true; do
    # -s  : silent (no echo)
    read -rsp "Enter a password for that user: " password1; echo
    read -rsp "Confirm password: "               password2; echo
    if [[ "$password1" == "$password2" && -n "$password1" ]]; then
        break
    else
        echo "⚠️  Passwords do not match. Please try again."
    fi
done

read -rp "Enter the domain name you want to use: (you should already own it): " domain; echo

# ---
