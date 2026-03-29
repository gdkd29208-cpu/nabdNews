<?php

use App\Http\Controllers\AuthController;
use App\Http\Controllers\HomeController;
use App\Http\Controllers\JournalistGroupController;
use App\Http\Controllers\NewsController;
use Illuminate\Support\Facades\Route;

Route::get('/', [HomeController::class, 'index'])->name('home');

Route::get('/register', [AuthController::class, 'showRegister'])->name('register');
Route::post('/register', [AuthController::class, 'register'])->middleware('throttle:5,1');
Route::get('/login', [AuthController::class, 'showLogin'])->name('login');
Route::post('/login', [AuthController::class, 'login'])->middleware('throttle:8,1');
Route::post('/logout', [AuthController::class, 'logout'])->name('logout');

Route::middleware('auth')->group(function () {
    Route::get('/profile', [AuthController::class, 'showProfile'])->name('profile');
    Route::patch('/profile', [AuthController::class, 'updateProfile'])->name('profile.update');
    Route::post('/journalist-groups', [JournalistGroupController::class, 'store'])->middleware('throttle:10,1')->name('journalist-groups.store');
    Route::post('/journalist-groups/join', [JournalistGroupController::class, 'join'])->middleware('throttle:10,1')->name('journalist-groups.join');

    Route::get('/news-create', [NewsController::class, 'create'])->name('news.create');
    Route::post('/news', [NewsController::class, 'store'])->name('news.store');
    Route::get('/news/{news}/edit', [NewsController::class, 'edit'])->name('news.edit');
    Route::put('/news/{news}', [NewsController::class, 'update'])->name('news.update');
    Route::delete('/news/{news}', [NewsController::class, 'destroy'])->name('news.destroy');

    Route::get('/news-fetch', function () {
        return view('news-fetch');
    })->name('news.fetch');

    Route::post('/news/scrape', [NewsController::class, 'scrape'])
        ->middleware('throttle:15,1')
        ->name('news.scrape');
});

Route::get('/news-list', [NewsController::class, 'index'])->name('news.index');
Route::get('/news/{news}', [NewsController::class, 'show'])->name('news.show');

Route::get('/social', function () {
    return view('social');
})->name('social');
