<?php

namespace App\Http\Controllers;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use App\Http\Resources\APIResource;
use App\Models\Profil;
use Illuminate\Support\Facades\Auth;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\File;

class ProfilController extends Controller
{
    /**
     * index
     *
     * @return void
     */
    public function index(Request $request)
    {
        if (Auth::guard('api')->check()) {
            $user = Auth::guard('api')->user();
            $profilId = $user->profil_id;

            $profil = Profil::where('id', $profilId)->get();
            return new APIResource(true, 'Profil!', $profil);
        }
        else {
            return response()->json(['message' => $user], 401);
        }
    }

    public function store(Request $request)
    {
        if (Auth::guard('api')->check()) {
            $user = Auth::guard('api')->user();
            $profilId = $user->profil_id;
            $image_path = $user->profil->image; //hosting upgrade
            // $image = $user->profil->image; //free hosting
            // $image_path = storage_path('app/public/images/'.$image); //free hosting

            if ($request->hasFile('image') && $request->file('image')->isValid()) {
                if ($image_path && File::exists($image_path)) {
                    File::delete($image_path);
                }

                $validator = Validator::make($request->all(), [
                    'image' => 'mimes:jpeg,jpg,png,gif|max:2048',
                    'front_name' => 'required',
                ]);
    
                if ($validator->fails()) {
                    return response()->json($validator->errors(), 422);
                }
    
                // Proses penyimpanan gambar seperti sebelumnya
                $path = $request->file('image')->store('public/images'); //hosting upgrade
                // $path = $request->file('image')->store('public/images');//free hosting
                $path = str_replace("public", "storage", $path); //hosting upgrade
                // $path = str_replace("public/images/", "", $path); //free hosting
    
                // Lanjutkan dengan menyimpan data lainnya
                $profil = Profil::find($profilId);
                $profil->image = $path; 
                $profil->front_name = $request->front_name;
                $profil->back_name = $request->back_name;
                $profil->date_of_birth = $request->date_of_birth;
                $profil->save();
    
                return new APIResource(true, 'Profil!', $profil);
            } else {
                // Lanjutkan dengan menyimpan data lainnya (tanpa menyimpan gambar baru)
                $validator = Validator::make($request->all(), [
                    'front_name' => 'required',
                ]);
    
                if ($validator->fails()) {
                    return response()->json($validator->errors(), 422);
                }
    
                $profil = Profil::find($profilId);
                $profil->front_name = $request->front_name;
                $profil->back_name = $request->back_name;
                $profil->date_of_birth = $request->date_of_birth;
                $profil->save();
    
                return new APIResource(true, 'Profil!', $profil);
            }
        }
        else {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
    }
}

//  bkev15ifjbIIE0sYLEjpVXf8ZgBbbXENXfoOUnmX.jpg 