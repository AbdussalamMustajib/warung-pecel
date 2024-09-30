<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Factories\HasFactory;
use Illuminate\Database\Eloquent\Model;

class Profil extends Model
{
    use HasFactory;
    
    protected $guarded = ['id'];

    public function record(){
        return $this->hasMany(Track::class);
    }

    public function user(){
        return $this->hasOne(Profil::class);
    }
}
