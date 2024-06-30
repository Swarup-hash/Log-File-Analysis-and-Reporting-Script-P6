#!/bin/bash

# Log File Analysis and Reporting Script

# Function to analyze log files
analyze_logs() {
    read -p "Enter the path to the log file (e.g., /var/log/apache2/access.log): " log_file

    if [ ! -f "$log_file" ]; then
        echo "Log file not found!"
        exit 1
    fi

    echo "Analyzing log file: $log_file"

    # Summary report
    total_requests=$(wc -l < "$log_file")
    unique_ips=$(awk '{print $1}' "$log_file" | sort | uniq | wc -l)
    top_ip=$(awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | head -n 1)
    top_request=$(awk '{print $7}' "$log_file" | sort | uniq -c | sort -nr | head -n 1)
    top_error=$(grep ' 404 ' "$log_file" | awk '{print $7}' | sort | uniq -c | sort -nr | head -n 1)

    echo "Summary Report"
    echo "=============="
    echo "Total requests: $total_requests"
    echo "Unique IPs: $unique_ips"
    echo "Top IP: $top_ip"
    echo "Top requested resource: $top_request"
    echo "Top 404 error resource: $top_error"
    echo ""

    # Detect anomalies (e.g., spike in requests from a single IP)
    echo "Anomaly Detection"
    echo "================="
    awk '{print $1}' "$log_file" | sort | uniq -c | sort -nr | awk '$1 > 100 {print "Potential DDoS attack from IP: " $2 ", Requests: " $1}'
    echo ""

    # Pattern detection (e.g., most requested resources)
    echo "Pattern Detection"
    echo "================="
    echo "Most requested resources:"
    awk '{print $7}' "$log_file" | sort | uniq -c | sort -nr | head -n 10
    echo ""
}

# Main menu
while true; do
    echo "Log File Analysis and Reporting Script"
    echo "1. Analyze Logs"
    echo "2. Exit"
    read -p "Choose an option (1-2): " choice

    case $choice in
        1) analyze_logs ;;
        2) echo "Exiting..."; exit 0 ;;
        *) echo "Invalid option, please try again." ;;
    esac
done
