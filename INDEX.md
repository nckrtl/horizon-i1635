# Index - Horizon Issue #1635 Reproducible Environment

## Project Overview

This is a complete, isolated Laravel 10 environment for reproducing and testing the fix for GitHub issue #1635 where batches get stuck in a pending state when submitted simultaneously.

**Project Location:** `/Users/nckrtl/Projects/laravel-issues/horizon-i1635`

**GitHub Issue:** https://github.com/laravel/horizon/issues/1635

## File Structure Overview

```
horizon-i1635/
│
├── Documentation (Start here!)
│   ├── README.md                    [8.2 KB] Main documentation
│   ├── QUICK-START.md              [2.1 KB] 30-second setup
│   ├── SETUP-VERIFICATION.md       [9.2 KB] Verification checklist
│   ├── PROJECT-FILES.md            [9.0 KB] File reference
│   └── INDEX.md                          This file
│
├── Configuration
│   ├── .env                        [1.1 KB] Environment variables
│   ├── config/horizon.php                 Horizon configuration
│   ├── config/queue.php                   Queue driver settings
│   └── config/database.php                Database settings
│
├── Application Code
│   ├── app/Jobs/TestBatchJob.php              Test job (30 lines)
│   ├── app/Console/Commands/BatchTestCommand.php   Batch command (52 lines)
│   └── routes/web.php                        HTTP endpoints (49 lines)
│
├── Utilities
│   ├── test-batch.sh               [3.6 KB] Interactive test menu
│   └── project.code-workspace      [305 B] VSCode workspace
│
├── Database
│   └── database/database.sqlite             SQLite database (auto-created)
│
├── Application Directories
│   ├── app/                         Laravel application code
│   ├── config/                      Configuration files
│   ├── routes/                      Route definitions
│   ├── storage/                     Logs and runtime files
│   ├── bootstrap/                   Framework bootstrap
│   ├── public/                      Web server root
│   ├── resources/                   Views and assets
│   ├── tests/                       Test files
│   └── vendor/                      Composer packages
│
└── Package Files
    ├── composer.json               PHP dependencies
    ├── composer.lock               Locked versions
    └── artisan                     Artisan CLI
```

## File Sizes & Content

### Documentation Files

| File | Size | Purpose |
|------|------|---------|
| README.md | 8.2 KB | Comprehensive guide with all details |
| QUICK-START.md | 2.1 KB | Quick reference for rapid setup |
| SETUP-VERIFICATION.md | 9.2 KB | Verification checklist and component status |
| PROJECT-FILES.md | 9.0 KB | Detailed file reference guide |
| INDEX.md | This file | Quick navigation guide |

### Application Files

| File | Lines | Purpose |
|------|-------|---------|
| app/Jobs/TestBatchJob.php | 30 | Test job for batch processing |
| app/Console/Commands/BatchTestCommand.php | 52 | Artisan command to submit batches |
| routes/web.php | 49 | HTTP endpoints for testing |

### Configuration Files

| File | Purpose |
|------|---------|
| .env | Environment configuration (Redis, SQLite, etc.) |
| config/horizon.php | Horizon worker configuration |
| config/queue.php | Queue driver settings |
| config/database.php | Database connection settings |

## How to Use This Environment

### Quick Setup (3 steps)

1. **Start Redis:**
   ```bash
   redis-server
   ```

2. **Start Horizon:**
   ```bash
   cd /Users/nckrtl/Projects/laravel-issues/horizon-i1635
   php artisan horizon
   ```

3. **Submit Batches (new terminal):**
   ```bash
   php artisan batch:test
   ```

4. **Monitor:**
   Open https://horizon-i1635.test/horizon

### Available Commands

```bash
# Submit 8 batches with 100 jobs each
php artisan batch:test

# Submit custom number of batches
php artisan batch:test --batches=10 --jobs=150

# Interactive test menu
./test-batch.sh

# Check batch status
curl -k https://horizon-i1635.test/test/status
```

## Key Information

### Versions

- Laravel: 10.x (12.34.0 installed)
- PHP: 8.3+
- Horizon: 5.36.0
- Queue Driver: Redis

### Endpoints

- **Application:** https://horizon-i1635.test
- **Horizon Dashboard:** https://horizon-i1635.test/horizon
- **Test Batch Endpoint:** https://horizon-i1635.test/test/batch
- **Status Endpoint:** https://horizon-i1635.test/test/status

### Database

- Type: SQLite (development)
- Location: `database/database.sqlite`
- Tables: job_batches, failed_jobs, jobs, users, etc.

### Queue

- Driver: Redis
- Host: 127.0.0.1
- Port: 6379
- Used for: Job queuing and batch processing

## When to Reference Each File

| Goal | File | Time |
|------|------|------|
| Get started quickly | QUICK-START.md | 2 min |
| Understand setup | README.md | 10 min |
| Verify everything works | SETUP-VERIFICATION.md | 5 min |
| Find specific file | PROJECT-FILES.md | 1 min |
| Navigate project | INDEX.md | 1 min |

## Reproduction Workflow

1. **Prepare:** Start Redis and Horizon
2. **Submit:** Run `php artisan batch:test`
3. **Observe:** Watch Horizon dashboard for stuck batches
4. **Investigate:** Check logs and database
5. **Fix:** Modify Horizon code in `../packages/horizon`
6. **Test:** Restart Horizon and retry

## Development Setup

### Open in VSCode

```bash
code /Users/nckrtl/Projects/laravel-issues/horizon-i1635/project.code-workspace
```

This opens:
- The Laravel project
- The local Horizon package (for testing fixes)

### Edit Test Scenario

Modify `app/Console/Commands/BatchTestCommand.php` to customize batch submission.

### Change Job Behavior

Edit `app/Jobs/TestBatchJob.php` to modify job execution behavior.

## Troubleshooting Quick Links

- **Redis issues:** See "Troubleshooting" section in README.md
- **Job not processing:** See "Jobs Not Processing" in README.md
- **Database locked:** See "Database Issues" in README.md
- **Certificate errors:** See "Port Conflicts" in README.md

## Important Notes

- All configuration is pre-set and ready to use
- Uses SQLite for ease of setup (no external DB needed)
- Local Horizon package available for testing fixes
- All dependencies are locked in composer.lock
- SSL/HTTPS is enabled via Herd
- Production MySQL config available if needed

## What Was Customized

- TestBatchJob: Job implementation with logging
- BatchTestCommand: Artisan command for batch submission
- routes/web.php: Added test endpoints
- .env: Configured for Redis and SQLite
- Added test-batch.sh interactive menu
- Added comprehensive documentation

## Resources

- **GitHub Issue:** https://github.com/laravel/horizon/issues/1635
- **Horizon Docs:** https://laravel.com/docs/horizon
- **Batch Queuing:** https://laravel.com/docs/queues#batches
- **Queue Documentation:** https://laravel.com/docs/queues

## Getting Help

1. Check QUICK-START.md for common tasks
2. Consult README.md for detailed information
3. Review SETUP-VERIFICATION.md to verify setup
4. Use PROJECT-FILES.md to find specific files
5. Check storage/logs/laravel.log for errors

## Next Steps

1. Start the environment using QUICK-START.md
2. Submit test batches
3. Monitor in Horizon dashboard
4. Investigate the issue
5. Test potential fixes in local Horizon package
6. Document findings for the issue

---

**Environment Ready for Testing!**

All components are installed and configured. You're ready to start reproducing and testing the issue.
