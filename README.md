# Horizon Issue #1635 - Batches Stuck at Pending

## Issue Overview

GitHub Issue: https://github.com/laravel/horizon/issues/1635

**Problem:** When pushing 8-10 batches simultaneously (each with ~100 jobs), batches get stuck in pending state and never progress. Restarting Horizon helps new batches but old ones remain stuck.

**Temporary Workaround:** Restarting Horizon helps new batches, but old stuck batches remain in pending state.

## Environment Details

- **Laravel Version:** 10.x
- **PHP Version:** 8.3+
- **Laravel Horizon Version:** 5.36.0
- **Queue Driver:** Redis
- **Database:** SQLite (development) / MySQL 8 (production config available)

## Project Setup

This is an isolated Laravel 10 environment designed to reproduce the batch queueing issue.

### Configuration

All configuration is already complete:

- Queue driver: `redis`
- Cache store: `redis`
- Database: SQLite for development
- Horizon installed and configured
- Redis connectivity configured

### Key Files

- `.env` - Environment configuration with Redis queue driver
- `app/Jobs/TestBatchJob.php` - Simple test job that simulates work
- `app/Console/Commands/BatchTestCommand.php` - Artisan command to submit batches
- `routes/web.php` - HTTP endpoints for batch testing
- `config/horizon.php` - Horizon configuration
- `config/queue.php` - Queue driver configuration
- `config/database.php` - Database configuration

## Prerequisites

Before running the tests, ensure you have:

1. **Redis Server** running locally on port 6379
2. **PHP 8.3+** installed
3. **Composer** installed
4. **Herd/Valet** for local development (for HTTPS)

## Quick Start

### 1. Install Dependencies

All dependencies are already installed via Composer. If needed, run:

```bash
cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635
composer install
```

### 2. Start Redis

```bash
# Using Homebrew
redis-server

# Or in Docker
docker run -d -p 6379:6379 redis:alpine
```

### 3. Access the Application

The application is available at: **https://horizon-i1635.test**

SSL is already configured via Herd.

### 4. Start Horizon Worker

In a separate terminal, start the Horizon worker:

```bash
cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635
php artisan horizon
```

Horizon dashboard: **https://horizon-i1635.test/horizon**

## Reproducing the Issue

### Method 1: Using Artisan Command (Recommended)

This is the simplest way to reproduce the issue:

```bash
cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635

# Submit 8 batches with 100 jobs each (default)
php artisan batch:test

# Or customize the number of batches and jobs
php artisan batch:test --batches=10 --jobs=100
```

The command will output the batch IDs that were created. You can then monitor their progress in the Horizon dashboard.

### Method 2: Using HTTP Endpoint

Open the following URL in your browser or use curl:

```bash
# Submit 8 batches with 100 jobs each (default)
curl https://horizon-i1635.test/test/batch

# Or customize parameters
curl "https://horizon-i1635.test/test/batch?batches=10&jobs=100"
```

Response will include the batch IDs created.

### Method 3: Using Tinker

```bash
cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635
php artisan tinker

# Inside tinker REPL
use Illuminate\Support\Facades\Bus;
use App\Jobs\TestBatchJob;

for ($b = 1; $b <= 8; $b++) {
    $jobs = [];
    for ($j = 1; $j <= 100; $j++) {
        $jobId = ($b - 1) * 100 + $j;
        $jobs[] = new TestBatchJob($jobId);
    }
    $batch = Bus::batch($jobs)->name("batch_{$b}")->dispatch();
    echo "Batch {$b}: {$batch->id}\n";
}
```

## Monitoring the Issue

### 1. Horizon Dashboard

Visit: **https://horizon-i1635.test/horizon**

Features:
- View all batches and their status
- Monitor batch progress
- See job counts (pending, processing, completed, failed)
- Watch for batches that remain "pending" instead of progressing

### 2. Check Batch Status via API

```bash
curl https://horizon-i1635.test/test/status
```

This endpoint returns all job batches and their current status.

### 3. View Database Records

Access SQLite directly:

```bash
cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635
sqlite3 database/database.sqlite

sqlite> SELECT id, name, total_jobs, processed_jobs, failed_jobs, cancelled_at, finished_at, created_at FROM job_batches;
```

### 4. Check Redis Queue

```bash
# Connect to Redis
redis-cli

# List all keys (jobs in queue)
KEYS *

# Get queue length
LLEN queue:default

# View job data
LRANGE queue:default 0 -1
```

### 5. View Logs

```bash
cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635
tail -f storage/logs/laravel.log
```

## Expected Behavior vs. Actual Behavior

### Expected Behavior
1. Submit 8-10 batches with 100 jobs each
2. Batches should show up in Horizon dashboard with "pending" status
3. As Horizon workers process jobs, batches should progress through "processing" to "completed"
4. All batches should eventually complete successfully

### Actual Behavior (Bug)
1. Submit 8-10 batches with 100 jobs each
2. Batches appear in Horizon dashboard
3. Batches get stuck at "pending" status
4. Batch progress does not update even though jobs are being processed
5. Restarting Horizon may help new batches, but stuck batches remain pending

## Troubleshooting

### Redis Connection Issues

If you see "Connection refused" errors:

```bash
# Check if Redis is running
redis-cli ping
# Should return: PONG

# Start Redis if not running
redis-server
```

### Jobs Not Processing

If jobs aren't being processed:

1. Verify Horizon is running: `php artisan horizon`
2. Check the Horizon dashboard: https://horizon-i1635.test/horizon
3. View logs: `tail -f storage/logs/laravel.log`
4. Ensure Redis is running: `redis-cli ping`

### Database Issues

Reset the database and start fresh:

```bash
cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635
rm -f database/database.sqlite
php artisan migrate --force
```

### Port Conflicts

If port 6379 (Redis) or 8000 (Laravel) is in use:

For Redis on a different port, update `.env`:
```
REDIS_PORT=6380
```

## Development Notes

### Project Structure

```
horizon-i1635/
├── app/
│   ├── Console/Commands/BatchTestCommand.php   # Batch submission command
│   ├── Jobs/TestBatchJob.php                   # Test job class
├── routes/
│   └── web.php                                  # HTTP endpoints for testing
├── config/
│   ├── horizon.php                              # Horizon configuration
│   ├── queue.php                                # Queue driver configuration
│   └── database.php                             # Database configuration
├── database/
│   └── database.sqlite                          # SQLite database
├── .env                                         # Environment configuration
└── project.code-workspace                       # VSCode workspace
```

### Key Configuration Files

#### `.env`
- `QUEUE_CONNECTION=redis` - Uses Redis for queues
- `CACHE_STORE=redis` - Uses Redis for caching
- `APP_URL=https://horizon-i1635.test` - Application URL

#### `config/queue.php`
Redis configuration with default queue settings.

#### `config/horizon.php`
Horizon configuration with worker settings and monitoring.

## Testing Tips

1. **Monitor in Real-Time:**
   - Open Horizon dashboard in one browser tab
   - Submit batches in another
   - Watch for the issue to occur

2. **High Concurrency:**
   - Submit multiple batches rapidly using the Artisan command
   - This increases the chance of reproducing the issue

3. **Large Batches:**
   - Try with larger job counts: `php artisan batch:test --batches=10 --jobs=200`

4. **Collect Debug Information:**
   - Take screenshots of Horizon when issue occurs
   - Note the batch IDs
   - Check logs and database state
   - Use this info when reporting/discussing the issue

## Additional Resources

- Horizon Documentation: https://laravel.com/docs/horizon
- Batch Queuing Documentation: https://laravel.com/docs/queues#batches
- GitHub Issue: https://github.com/laravel/horizon/issues/1635

## Notes

- This environment uses SQLite by default for easier setup
- MySQL configuration is commented in `.env` if you want to use a real database
- All dependencies are locked to the versions specified in `composer.lock`
- The local Horizon package in `/Users/nckrtl/Projects/laravel-issues/packages/horizon` can be used for testing fixes
