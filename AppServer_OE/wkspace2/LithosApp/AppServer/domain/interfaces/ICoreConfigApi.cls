
/*------------------------------------------------------------------------
    File        : domain/interfaces/ICoreConfigApi.cls
    Purpose     : Repository Interface for Core Configuration
    Syntax      : 
    Description : 
    Author(s)   : Pensado
    Created     : Fri Sep 04 09:12:28 PDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface domain.interfaces.ICoreConfigApi:  
  
     // Private members .........................
     {domain/defs/CoreConfigApiDefs.i}
     
     // Mehods .................................
     method public void GetAll 
         (input cfgGrp as character,
         output pgmExec  as character,
         output successMsg as character, 
         output sucess as logical,
         output table coreConfigTable ).
         
  method public void GetGroups
        (output pgmExec  as character,
         output successMsg as character, 
         output sucess as logical,
         output table coreConfigTable ).       
  
  method public void GetOneById
        (input uniqueID as integer,
         output pgmExec  as character,
         output successMsg as character, 
         output sucess as logical,
         output table coreConfigTable).
  
  method public void DeleteOne
        (input uniqueID as integer,
        output pgmExec  as character,
        output successMsg as character, 
        output sucess as logical,
        output table coreConfigTable).
  
   method public void CreateOne
       ( input cfgGrp as character, 
         input cfgSgrp as character,
         input keyName as character,
         input keyValue as character,
         input keyNotes as character,
         output pgmExec  as character,
         output successMsg as character, 
         output sucess as logical,
         output table coreConfigTable ).
  
   method public void UpdateOne
      ( input uniqueID as integer,
        input dataset coreConfigSet,
        output pgmExec  as character,
        output successMsg as character, 
        output sucess as logical,
        output table coreConfigTable  ).
     
     
  
end interface.