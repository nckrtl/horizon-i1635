<?php

use Illuminate\Support\Facades\Route;
use App\Jobs\TestBatchJob;

Route::get('/', function () {
    return view('welcome');
});

// Test batch submission
Route::get('/test/batch', function () {
    $batchCount = request()->query('batches', 8);
    $jobsPerBatch = request()->query('jobs', 100);

    $results = [];

    for ($b = 1; $b <= $batchCount; $b++) {
        $jobs = [];
        for ($j = 1; $j <= $jobsPerBatch; $j++) {
            $jobId = ($b - 1) * $jobsPerBatch + $j;
            $jobs[] = new TestBatchJob($jobId);
        }

        $batch = \Illuminate\Support\Facades\Bus::batch($jobs)
            ->name("batch_{$b}")
            ->dispatch();

        $results[] = [
            'batch_id' => $batch->id,
            'batch_name' => "batch_{$b}",
            'job_count' => count($jobs),
        ];
    }

    return response()->json([
        'message' => "Submitted {$batchCount} batches with {$jobsPerBatch} jobs each",
        'batches' => $results,
    ]);
});

// View batch status
Route::get('/test/status', function () {
    $batches = \DB::table('job_batches')->get()->toArray();

    return response()->json([
        'total_batches' => count($batches),
        'batches' => $batches,
    ]);
});
