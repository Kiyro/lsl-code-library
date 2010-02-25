string text = "
5 FREE HUDS !
-12/05-";

vector red = <1.0,0.0,0.0>;
vector green = <0.0,1.0,0.0>;
vector blue = <0.0,0.0,1.0>;

vector yellow = <1.0,1.0,0.0>;
vector cyan = <0.0,1.0,1.0>;
vector purple = <1.0,0.0,1.0>;


default
{
    state_entry()
    {        
        llSetText(text, cyan, 1);
        
    }
    
        
    
                   
    on_rez(integer startparam)
    {
        llResetScript();
    }
    
    
}

