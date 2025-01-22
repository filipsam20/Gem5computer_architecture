# Function to read the .ini file and extract values from the [Tests] section
read_ini() {
    local ini_file=$1
    local test_section_started=false

    # Read through the ini file and process lines
    while IFS= read -r line; do
        # Skip empty lines or comments
        [[ -z "$line" || "$line" =~ ^# ]] && continue

        # Detect the [Tests] section
        if [[ "$line" == "[Tests]" ]]; then
            test_section_started=true
            continue
        fi

        # If inside the [Tests] section, process each test case
        if $test_section_started; then
            # Split the line into an array of indices
            read -r l1i_index l1d_index l2_index cacheline_index <<< "$line"

            # Call get_elements function with the extracted indices
            get_elements "$l1i_index" "$l1d_index" "$l2_index" "$cacheline_index"
        fi
    done < "$ini_file"
}
