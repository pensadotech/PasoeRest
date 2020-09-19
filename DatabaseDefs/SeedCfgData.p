/*------------------------------------------------------------------------
    File        : CoreConfig/LoadCfgData.p
    Purpose     : 

    Syntax      :

    Description : 

    Author(s)   : Pensado
    Created     : Sat Aug 29 18:07:31 PDT 2020
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

block-level on error undo, throw.

/* ********************  Preprocessor Definitions  ******************** */


/* ***************************  Main Block  *************************** */
main-block:
do:
    run DeleteSampleData in this-procedure. 
    
    run CreateSampleData in this-procedure.
    
    run DisplaySampleData in this-procedure. 
    
end.

/* **********************  Internal Procedures  *********************** */
procedure createSampleData:
    /*------------------------------------------------------------------------------
     Purpose: create samle records
     Notes:
    ------------------------------------------------------------------------------*/

    define variable tCfgGrp      as character no-undo.
    define variable tCfgSgrp     as character no-undo.
    define variable tKeyName     as character no-undo.
    define variable tSubGrpCount as integer   no-undo.
    define variable tKeyVarCount as integer   no-undo.
    define variable entNum       as integer   no-undo.

    do entNum =  1 to 10:
        
        
        tSubGrpCount = 1.
        tKeyVarCount = 1. 
        
        tCfgGrp  = "TSTGRP" + string(entNum,"99").
        tCfgSgrp = "TST" + string(tSubGrpCount,"99").
        tKeyName = "KEYVAR" + string(tKeyVarCount,"99").
        
        create CORE_CONFIG.
        assign 
            CfgGrp   = tCfgGrp
            CfgSgrp  = tCfgSgrp
            KeyName  = tKeyName
            KeyValue = "abc123".
       
       tKeyVarCount = tKeyVarCount + 1. 
       tKeyName = "KEYVAR" + string(tKeyVarCount,"99").
        
       create CORE_CONFIG.
        assign 
            CfgGrp   = tCfgGrp
            CfgSgrp  = tCfgSgrp
            KeyName  = tKeyName
            KeyValue = "abc123".
            
    
    end.

end procedure.

procedure DeleteSampleData:
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/
    for each CORE_CONFIG:
        delete  CORE_CONFIG.
   
    end.

end procedure.

procedure DisplaySampleData:
    /*------------------------------------------------------------------------------
     Purpose:
     Notes:
    ------------------------------------------------------------------------------*/

    for each CORE_CONFIG:
        display 
            CfgGrp
            CfgSgrp
            KeyName
            substring(KeyValue,1,20).
   
    end.

end procedure.

