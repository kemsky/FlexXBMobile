package com.googlecode.flexxb.util
{
    public function isNaNFast(target:*, type:Class):Boolean
    {
        return type == Number && (!(target <= 0) && !(target > 0));
    }
}
