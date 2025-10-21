<?php

namespace App\Jobs;

use Illuminate\Bus\Batchable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Queue\Queueable;
use Illuminate\Queue\InteractsWithQueue;

class TestBatchJob implements ShouldQueue
{
    use Batchable, InteractsWithQueue, Queueable;

    /**
     * Create a new job instance.
     */
    public function __construct(public int $jobId)
    {
        //
    }

    /**
     * Execute the job.
     */
    public function handle(): void
    {
        // Simulate some work
        sleep(rand(1, 3));

        \Log::info("Job {$this->jobId} completed successfully");
    }
}
