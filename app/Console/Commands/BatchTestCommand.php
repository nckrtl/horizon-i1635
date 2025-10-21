<?php

namespace App\Console\Commands;

use Illuminate\Console\Command;
use Illuminate\Support\Facades\Bus;
use App\Jobs\TestBatchJob;

class BatchTestCommand extends Command
{
    /**
     * The name and signature of the console command.
     *
     * @var string
     */
    protected $signature = 'batch:test {--batches=20} {--jobs=200}';

    /**
     * The console command description.
     *
     * @var string
     */
    protected $description = 'Submit multiple batches with jobs to reproduce the pending batch issue';

    /**
     * Execute the console command.
     */
    public function handle()
    {
        $batchCount = $this->option('batches');
        $jobsPerBatch = $this->option('jobs');

        $this->info("Submitting {$batchCount} batches with {$jobsPerBatch} jobs each...");

        for ($b = 1; $b <= $batchCount; $b++) {
            $jobs = [];
            for ($j = 1; $j <= $jobsPerBatch; $j++) {
                $jobId = ($b - 1) * $jobsPerBatch + $j;
                $jobs[] = new TestBatchJob($jobId);
            }

            $batch = Bus::batch($jobs)
                ->name("batch_{$b}")
                ->dispatch();

            $this->line("Batch {$b} created: {$batch->id} with {$jobsPerBatch} jobs");
        }

        $this->info("Successfully submitted {$batchCount} batches!");
        $this->info("Check Horizon dashboard at https://horizon-i1635.test/horizon for batch status");
    }
}
