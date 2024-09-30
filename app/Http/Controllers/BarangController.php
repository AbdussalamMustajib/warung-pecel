<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Http\Resources\APIResource;
use App\Models\Barang;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File;

class BarangController extends Controller
{
    /**
     * index
     *
     * @return void
     */
    public function index(Request $request)
    {
        if (Auth::guard('api')->check()) {
            $barang = Barang::all();
            return response()->json($barang, 200);
        }
        else {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
    }

    public function store(Request $request)
    {
        if (Auth::guard('api')->check()) {
            $barang = Barang::where('id', $request->id)->exists();
            if ($request->method == 'add') {
                if ($request->hasFile('image') && $request->file('image')->isValid()) {
                    if ($image_path && File::exists($image_path)) {
                        File::delete($image_path);
                    }
    
                    $validator = Validator::make($request->all(), [
                        'image' => 'mimes:jpeg,jpg,png,gif|max:2048',
                        'nama' => 'required',
                    ]);
        
                    if ($validator->fails()) {
                        return response()->json($validator->errors(), 422);
                    }
        
                    // Proses penyimpanan gambar seperti sebelumnya
                    // $path = $request->file('image')->store('public/images'); //hosting upgrade
                    $path = $request->file('image')->store('public/images');//free hosting
                    // $path = str_replace("public", "storage", $path); //hosting upgrade
                    $path = str_replace("public/images/", "", $path); //free hosting
        
                    // Lanjutkan dengan menyimpan data lainnya
                    $barang = new Barang;
                    $barang->image = $path; 
                    $barang->nama_barang = $request->nama;
                    $barang->save();
                    
                    $barang = Barang::find($request);
        
                    return new APIResource(true, 'Profil!', $barang);
                } else {
                    $validator = Validator::make($request->all(), [
                        'nama'   => 'required',
                    ]);
                    
                    if ($validator->fails()) {
                        return response()->json($validator->errors(), 422);
                    }
    
                    $barang = new Barang;
                    $barang->nama_barang = $request->nama;
                    $barang->save();
                    return new APIResource(true, 'Berhasil Melakukan Update Pain Level terbaru!', $barang);
                }
            }
            if ($request->method == 'edit') {
                if ($request->hasFile('image') && $request->file('image')->isValid()) {
                    if ($image_path && File::exists($image_path)) {
                        File::delete($image_path);
                    }
    
                    $validator = Validator::make($request->all(), [
                        'id' => 'required',
                        'image' => 'mimes:jpeg,jpg,png,gif|max:2048',
                        'nama' => 'required',
                    ]);
        
                    if ($validator->fails()) {
                        return response()->json($validator->errors(), 422);
                    }
        
                    // Proses penyimpanan gambar seperti sebelumnya
                    // $path = $request->file('image')->store('public/images'); //hosting upgrade
                    $path = $request->file('image')->store('public/images');//free hosting
                    // $path = str_replace("public", "storage", $path); //hosting upgrade
                    $path = str_replace("public/images/", "", $path); //free hosting
        
                    // Lanjutkan dengan menyimpan data lainnya
                    $barang = Barang::find($request->id);
                    $barang->image = $path; 
                    $barang->nama_barang = $request->nama;
                    $barang->save();
                    
                    $barang = Barang::find($request);
        
                    return new APIResource(true, 'Profil!', $barang);
                } else {
                    $validator = Validator::make($request->all(), [
                        'id' => 'required',
                        'nama'   => 'required',
                    ]);
                    
                    if ($validator->fails()) {
                        return response()->json($validator->errors(), 422);
                    }
    
                    $barang = Barang::find($request->id);
                    $barang->nama_barang = $request->nama;
                    $barang->save();
    
                    return new APIResource(true, 'Berhasil Melakukan Update Pain Level terbaru!', $barang);
                }
            }
        }
        else 
        {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
    }
}
