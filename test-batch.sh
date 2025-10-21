#!/bin/bash

# Color codes for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

PROJECT_DIR="/Users/nckrtl/Projects/laravel-issues/horizon-i1635"

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Horizon Issue #1635 - Batch Test Script${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Check if Redis is running
echo -e "${YELLOW}Checking Redis connection...${NC}"
if redis-cli ping > /dev/null 2>&1; then
    echo -e "${GREEN}✓ Redis is running${NC}"
else
    echo -e "${RED}✗ Redis is NOT running${NC}"
    echo -e "${YELLOW}Please start Redis: redis-server${NC}"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "$PROJECT_DIR/.env" ]; then
    echo -e "${RED}Error: Not in the horizon-i1635 project directory${NC}"
    exit 1
fi

echo ""
echo -e "${YELLOW}Project directory: $PROJECT_DIR${NC}"
echo ""

# Display menu
echo -e "${BLUE}What would you like to do?${NC}"
echo "1. Submit 8 batches with 100 jobs each (default scenario)"
echo "2. Submit custom number of batches"
echo "3. Check batch status"
echo "4. View database records"
echo "5. Clear all batches and jobs"
echo "6. Start Horizon worker"
echo "7. Open Horizon dashboard"
echo "8. View recent logs"
echo "9. Exit"
echo ""
read -p "Enter your choice (1-9): " choice

cd "$PROJECT_DIR"

case $choice in
    1)
        echo -e "${YELLOW}Submitting 8 batches with 100 jobs each...${NC}"
        php artisan batch:test --batches=8 --jobs=100
        echo ""
        echo -e "${GREEN}Batches submitted! Check Horizon dashboard at: https://horizon-i1635.test/horizon${NC}"
        ;;
    2)
        read -p "Number of batches: " batches
        read -p "Jobs per batch: " jobs
        echo -e "${YELLOW}Submitting $batches batches with $jobs jobs each...${NC}"
        php artisan batch:test --batches=$batches --jobs=$jobs
        echo ""
        echo -e "${GREEN}Batches submitted! Check Horizon dashboard at: https://horizon-i1635.test/horizon${NC}"
        ;;
    3)
        echo -e "${YELLOW}Checking batch status...${NC}"
        curl -s https://horizon-i1635.test/test/status | jq '.' 2>/dev/null || \
        curl -s https://horizon-i1635.test/test/status
        echo ""
        ;;
    4)
        echo -e "${YELLOW}Database records:${NC}"
        sqlite3 database/database.sqlite << SQL
.headers on
.mode column
SELECT id, name, total_jobs, processed_jobs, failed_jobs, cancelled_at, finished_at, created_at FROM job_batches;
SQL
        echo ""
        ;;
    5)
        echo -e "${RED}WARNING: This will clear all batches and jobs${NC}"
        read -p "Are you sure? (yes/no): " confirm
        if [ "$confirm" = "yes" ]; then
            echo -e "${YELLOW}Clearing database...${NC}"
            rm -f database/database.sqlite
            php artisan migrate --force > /dev/null 2>&1
            echo -e "${GREEN}Database cleared${NC}"
        else
            echo -e "${YELLOW}Cancelled${NC}"
        fi
        echo ""
        ;;
    6)
        echo -e "${YELLOW}Starting Horizon worker...${NC}"
        echo -e "${GREEN}Press Ctrl+C to stop${NC}"
        echo ""
        php artisan horizon
        ;;
    7)
        echo -e "${YELLOW}Opening Horizon dashboard...${NC}"
        open https://horizon-i1635.test/horizon
        ;;
    8)
        echo -e "${YELLOW}Recent logs (last 20 lines):${NC}"
        echo ""
        tail -20 storage/logs/laravel.log
        echo ""
        ;;
    9)
        echo -e "${YELLOW}Exiting${NC}"
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice${NC}"
        exit 1
        ;;
esac
