<?php

namespace App\Http\Controllers;

use Illuminate\Http\Request;
use App\Models\User;
use App\Models\Profil;
use Illuminate\Support\Facades\Validator;
use Illuminate\Support\Facades\Auth;
use App\Http\Resources\APIResource;

use Illuminate\Support\Facades\Hash;

//using for forgot password
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Str;
use Illuminate\Support\Facades\Crypt;

class AuthController extends Controller
{
    public function register(Request $request)
    {   
        //define validation rules
        $validator = Validator::make($request->all(), [
            'name'     => 'required',
            'email'     => 'required|email',
            'password'   => 'required|min:8',
        ]);

        //check if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }

        $email = $request->input('email');
        $user = User::where('email', $email)->first();

        if ($user) {
            return response()->json(['message' => 'Email has been used'], 409);
        } else {
            // create new profil
            $profil = new Profil;
            $profil->front_name = $request->input('name');
            $profil->save();

            //create new user
            $user = new User;
            $user->profil_id = $profil->id;
            $user->email = $request->input('email');
            $user->password = Hash::make($request->input('password'));
            $user->save();

            //return response
            return new APIResource(true, 'registered account successfully!', $user);
        }
    }

    public function login(Request $request)
    {
        $validator = Validator::make($request->all(), [
            'email'     => 'required|email',
        ]);

        //check if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }
        
        $credentials = $request->validate([
            'email' => 'required|email',
            'password' => 'required',
        ]);

        $email = $request->input('email');
        $user = User::where('email', $email)->first();
        if (!$user) {
            return response()->json(['message' => 'Email has not been registered.'], 404);
        }

        if (!Auth::attempt($request->only('email', 'password')))
        {
            return response()
                ->json(['message' => 'Unauthorized'], 401);
        }

        $user = User::where('email', $request['email'])->firstOrFail();

        $token = $user->createToken('auth_token')->plainTextToken;

        //if auth success
        return response()->json([
            'success' => true,
            'user'    => $user,
            'token'   => $token   
        ], 200);
    }

    public function forgotPassword(Request $request)
    {
        $validator = Validator::make($request->all(), [
        'email'     => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }
        
        $email = $request->input('email');
        $user = User::where('email', $email)->first();
        if (!$user) {
            return response()->json(['message' => 'Email has not been registered.'], 404);
        }

        DB::table('password_resets')->where('email', $email)->delete();

        // Generate and save password reset token with expired time
        $characters = '0123456789';
        $token_length = 6;
        $token = '';
        for ($i = 0; $i < $token_length; $i++) {
            $token .= $characters[mt_rand(0, strlen($characters) - 1)];
        }
        $token_after = Hash::make($token);
        $expired = now()->addMinutes(30);
        DB::table('password_resets')->insert([
            'email' => $user->email,
            'token' => $token_after,
            'created_at' => now(),
            'expired_at' => $expired
        ]);


        // Send reset password email
        Mail::send('emails.reset_password', ['token' => $token, 'user' => $user], function ($message) use ($user) {
            $message->to($user->email);
            $message->subject('Reset Your Password');
        });

        return response()->json(['message' => 'Reset password email sent'], 200);
    }

    public function resetPasswordByEmail(Request $request)
    {
        $validator = Validator::make($request->all(), [
        'email'     => 'required|email',
        ]);

        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }
        $email = $request->input('email');
            
        $user = User::where('email', $email)->first();
        $validator = Validator::make($request->all(), [
            'token' => 'required',
            'new_password' => 'required'
        ]);

        //check if validation fails
        if ($validator->fails()) {
            return response()->json($validator->errors(), 422);
        }
        //check whether the user has made a forgot password request
        $token = DB::table('password_resets')->where('email', $user->email)->first();
        if (!$token) {
            return response()->json(['message' => 'You have not submitted forgot password'], 404);
        }
        else
        {
            $check_token = Hash::check($request->token, $token->token);
            $check_token_expired = $token->expired_at > now();
            if (!$check_token)
            {
                return response()->json(['message' => 'The token you entered is invalid'], 400);
            } 
            else {
                if (!$check_token_expired)
                {
                    return response()->json(['message' => 'Your token has expired'], 404);
                }
                $user->update(['password' => Hash::make($request->password)]);

                DB::table('password_resets')->where('email', $email)->delete();

                return response()->json(['message' => 'Password reset successfully'], 200);
            }
        }
    }

    public function resetPassword(Request $request)
    {
        if (Auth::guard('api')->check()) {
            $user = Auth::guard('api')->user();
            $email = $user->email;

            $validator = Validator::make($request->all(), [
                'old_password' => 'required',
                'new_password' => 'required|min:8',
            ]);

            //check if validation fails
            if ($validator->fails()) {
                return response()->json($validator->errors(), 422);
            }

            $check_pass = Hash::check($request->old_password, $user->password);

            if ($check_pass)
            {
                $check_req_pass = Hash::check($request->old_password, $request->new_password);
                if (!$check_req_pass);
                {
                    return response()->json(['message' => 'insert valid old password'], 409);
                }
                if ($check_pass);
                {
                    return response()->json(['message' => 'the password must be different from the old password'], 409);
                }
                $user->password = Hash::make($request->password_baru);
                $user->save();
                return response()->json(['message' => 'Password reset successfully'], 200);
            }

            return response()->json(['message' => $user->password]);
        }
        else {
            return response()->json(['message' => 'Unauthorized'], 401);
        }
        
    }
}
