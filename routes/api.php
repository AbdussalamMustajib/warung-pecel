<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

Route::middleware('auth:sanctum')->get('/user', function (Request $request) {
    return $request->user();
});

Route::get('/profile', [App\Http\Controllers\RecordController::class, 'index']);

Route::post('/register', [App\Http\Controllers\AuthController::class, 'register'])->name('register');
Route::post('/login', [App\Http\Controllers\AuthController::class, 'login'])->name('login');
Route::post('/forgotPassword',[App\Http\Controllers\AuthController::class, 'forgotPassword'])->name('forgotPassword');

Route::apiResource('/reports', App\Http\Controllers\ReportController::class);
Route::get('/monthlyReport', [App\Http\Controllers\ReportController::class, 'monthlyReport']);
Route::apiResource('/barang', App\Http\Controllers\BarangController::class);
Route::apiResource('/profile', App\Http\Controllers\ProfilController::class);

Route::get('/displayImage', [App\Http\Controllers\GetImageController::class, 'displayImage']);
 