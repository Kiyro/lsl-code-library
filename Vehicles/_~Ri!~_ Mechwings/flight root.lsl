// Argent Stonecutter's Wing Hide/Show script.

// This Script is distributed under the terms of the modified BSD license, reproduced at the end of
// the script. The license and acknowledgments listed must be included if this script is redistributed
// in a non-readable or non-modifiable form.

integer showing = -1;
integer prims;

show()
{
    if(showing == 1) return;
    showing = 1;
 //   llSetAlpha(1.0, ALL_SIDES);
    llMessageLinked(LINK_SET, 0, "Fly", NULL_KEY);
    
   
}

hide()
{
    if(showing == 0) return;
    showing = 0;
 //   llSetAlpha(0.0, ALL_SIDES);
    llMessageLinked(LINK_SET, 0, "Fold", NULL_KEY);

}

check(integer setup)
{

    if(!llGetAttached())
    {
        show();
        return;
    }
    
    integer act = llGetAgentInfo(llGetOwner());
    if(act & AGENT_FLYING)
        show();
    else if( !(act & AGENT_IN_AIR) ) // If you're falling from flight, leave the wings until you hit ground.
        hide();
}

default
{
    state_entry()
    {
        check(TRUE);
    }
    
    on_rez(integer param)
    {
        check(TRUE);
    }
    
    changed(integer mask)
    {
        if(mask & CHANGED_LINK)
            check(TRUE);
    }
    
    moving_start()
    {
        check(FALSE);
    }

    moving_end()
    {
        check(FALSE);
    }
}

//Copyright (c) 2005, Argent Stonecutter
//All rights reserved.
//
//Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:
//
//    * Redistributions in modifiable form must retain the above copyright notice, this list of conditions and the following disclaimer.
//    * Redistributions in non-modifiable form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
//    * Neither the name of Argent Stonecutter nor his player may be used to endorse or promote products derived from this software without specific prior written permission.
//
//THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
