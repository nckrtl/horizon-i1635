# Quick Start Guide - Horizon Issue #1635

## 30-Second Setup

Everything is pre-configured! Just follow these steps:

### 1. Start Redis (if not already running)
```bash
redis-server
```

### 2. Start Horizon Worker (in a new terminal)
```bash
cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635
php artisan horizon
```

### 3. Submit Test Batches (in another terminal)
```bash
cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635
php artisan batch:test
```

### 4. Monitor Progress
Open Horizon Dashboard: **https://horizon-i1635.test/horizon**

Watch for batches getting stuck at "pending"!

## Available Options

### Customize Batch Submission
```bash
# Submit 10 batches with 200 jobs each
php artisan batch:test --batches=10 --jobs=200
```

### Use Interactive Test Script
```bash
./test-batch.sh
```

### Check Batch Status via API
```bash
curl -k https://horizon-i1635.test/test/status
```

### View Logs
```bash
tail -f storage/logs/laravel.log
```

## File Locations

| File | Purpose |
|------|---------|
| `/Users/nckrtl/Projects/laravel-issues/horizon-i1635/app/Jobs/TestBatchJob.php` | Test job class |
| `/Users/nckrtl/Projects/laravel-issues/horizon-i1635/app/Console/Commands/BatchTestCommand.php` | Batch submission command |
| `/Users/nckrtl/Projects/laravel-issues/horizon-i1635/routes/web.php` | HTTP test endpoints |
| `/Users/nckrtl/Projects/laravel-issues/horizon-i1635/.env` | Configuration |
| `/Users/nckrtl/Projects/laravel-issues/horizon-i1635/test-batch.sh` | Interactive test menu |
| `/Users/nckrtl/Projects/laravel-issues/horizon-i1635/README.md` | Full documentation |

## Troubleshooting

**Redis not running?**
```bash
redis-server
```

**Horizon not starting?**
```bash
php artisan horizon --verbose
```

**Jobs not being processed?**
```bash
# Check logs
tail -f storage/logs/laravel.log

# Verify Redis connection
redis-cli ping
```

## Next: Open in Editor

```bash
# Open VSCode with workspace
code /Users/nckrtl/Projects/laravel-issues/horizon-i1635/project.code-workspace
```

This opens both the Laravel app and the local Horizon package for development.

## Full Documentation

See `README.md` for comprehensive setup and troubleshooting guide.
