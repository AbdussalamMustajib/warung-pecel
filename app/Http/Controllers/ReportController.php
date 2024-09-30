<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Resources\APIResource;
use App\Models\Report;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File;
use DB;

class ReportController extends Controller
{
    public function index(Request $request)
    {
        if (Auth::guard('api')->check()) {
            $reports = Report::orderBy('updated_at', 'desc')->get();
            return response()->json($reports, 200);
        } else {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
    }

    public function monthlyReport(Request $request)
    {
        if (Auth::guard('api')->check()) {
            $user = Auth::guard('api')->user();
            $currentDate = now()->endOfDay();
            $startDate = now()->subDays(29)->startOfDay();

            $reportsDailyIn = Report::selectRaw('DATE(created_at) as date, SUM(harga) as total_harga')
                                    ->where('tipe', 'M')
                                    ->whereBetween('created_at', [$startDate, $currentDate])
                                    ->groupBy('date')
                                    ->orderByDesc('date')
                                    ->get()
                                    ->keyBy('date');

            $reportsDailyOut = Report::selectRaw('DATE(created_at) as date, SUM(harga) as total_harga')
                                    ->where('tipe', 'K')
                                    ->whereBetween('created_at', [$startDate, $currentDate])
                                    ->groupBy('date')
                                    ->orderByDesc('date')
                                    ->get()
                                    ->keyBy('date');

            $dailyDataIn = collect();
            for ($date = $currentDate->copy(); $date->gte($startDate); $date->subDay()) {
                $dailyDataIn->push([
                    'date' => $date->toDateString(),
                    'total_harga' => $reportsDailyIn->get($date->toDateString())->total_harga ?? 0,
                ]);
            }

            $dailyDataOut = collect();
            for ($date = $currentDate->copy(); $date->gte($startDate); $date->subDay()) {
                $dailyDataOut->push([
                    'date' => $date->toDateString(),
                    'total_harga' => $reportsDailyOut->get($date->toDateString())->total_harga ?? 0,
                ]);
            }

            $highestReportIn = $dailyDataIn->max('total_harga');
            $highestReportOut = $dailyDataOut->min('total_harga');
    
            return response()->json([
                'reports_in' => $dailyDataIn,
                'reports_out' => $dailyDataOut,
                'highest_report_in' => $highestReportIn,
                'highest_report_out' => $highestReportOut,
            ]);
        } else {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
    }

    public function store(Request $request)
    {
        if (Auth::guard('api')->check()){
            $validator = Validator::make($request->all(), [
                'method'     => 'required',
            ]);
            
            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            if ($request->method == 'add'){
                $validator = Validator::make($request->all(), [
                    'nama_barang'     => 'required',
                    'nama_orang'   => 'required',
                    'harga'   => 'required',
                    'keterangan'   => 'required',
                    'tanggal'   => 'required',
                ]);
                
                if ($validator->fails()) {
                    return response()->json($validator->errors(), 422);
                }
    
                $report = new Report;
                $report->nama_barang = $request->nama_barang;
                $report->nama_orang = $request->nama_orang;
                $report->harga = $request->harga;
                $report->keterangan = $request->keterangan;
                $report->tanggal = $request->tanggal;
                $report->tipe = $request->harga > 0 ? "M" : "K";
                $report->save();
    
                $report= Report::find($report->id);
    
                return new APIResource(true, 'Add Sell Price Successfully!', $report);
            } if ($request->method == 'edit'){
                $validator = Validator::make($request->all(), [
                    'id'     => 'required',
                    'nama_barang'     => 'required',
                    'nama_orang'   => 'required',
                    'harga'   => 'required',
                    'keterangan'   => 'required',
                    'tanggal'   => 'required',
                ]);
                
                if ($validator->fails()) {
                    return response()->json($validator->errors(), 422);
                }
                
                $report = Reports::find($request->id);
                if (!$report) {
                    return response()->json(['message' => 'Data Report Not Found'], 404);
                }
    
                $report->nama_barang = $request->nama_barang ?? $report->nama_barang;
                $report->nama_orang = $request->nama_orang ?? $report->nama_orang;
                $report->harga = $request->harga ?? $report->harga;
                $report->keterangan = $request->keterangan ?? $report->keterangan;
                $report->tanggal = $request->tanggal ?? $report->tanggal;
                $report->save();
    
                $report= Report::find($report->id);
    
                return new APIResource(true, 'Edit Sell Price Successfully!', $report);
            } 
        } else {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
    }

    public function destroy($id)
    {
        if (Auth::guard('api')->check()) {
            $report = Report::find($id);
            if (!$report) {
                return response()->json(['message' => 'Data Order Not Found'], 404);
            }
            $report->delete();
            return new APIResource(true, 'Delete Order Successfully!', $report);
        }
        else {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
    }
}
