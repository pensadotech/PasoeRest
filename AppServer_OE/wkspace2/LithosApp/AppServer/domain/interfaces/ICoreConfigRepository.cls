
/*------------------------------------------------------------------------
    File        : domain/interfaces/ICoreConfigRepository.cls
    Purpose     : API Interface for Core Configuration
    Syntax      : 
    Description : 
    Author(s)   : Pensado
    Created     : Fri Sep 04 09:17:28 PDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.

interface domain.interfaces.ICoreConfigRepository:  
  
    // Private mmebers .....................
    {domain/defs/CoreConfigRepositoryDefs.i}
  
    // Methods ............................
    method public void GetAll 
        (input cfgGrp as character,
         output table coreConfigInfo).
  
    method public void GeGroups
        (output table coreConfigInfo).  
  
    method public void GetFirst 
        (input cfgGrp as character,
         output table coreConfigInfo).
   
    method public void GetOneById
        (input uniqueID as integer,
         output table coreConfigInfo).

    method public logical DeleteOne
        (input uniqueID as integer,
         output executeStatus as character,
         output table coreConfigInfo).

    method public void CreateOne
        ( input cfgGrp as character, 
          input cfgSgrp as character,
          input keyName as character,
          input keyValue as character,
          input keyNotes as character,
          output executeStatus as character,
          output table coreConfigInfo ). 
 
    method public logical UpdateOne
        (input uniqueID as integer,
         input-output table coreConfigInfo,
         output executeStatus as character).
        
  
end interface.