@openapi.openedge.export FILE(type="REST", executionMode="singleton", useReturnValue="false", writeDataSetBeforeImage="false").

/*------------------------------------------------------------------------
   File        : api/CoreConfigApi
   Purpose     : API for Core Configuration
   Syntax      : 
   Description : 
   Author(s)   : Pensado
   Created     : Fri Sep 04 10:24:58 PDT 2020
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using domain.interfaces.*.
using dataAccess.*.

block-level on error undo, throw.

class api.CoreConfigApi implements ICoreConfigApi: 

    // Private mmebers ..........................................
    {domain/defs/CoreConfigApiDefs.i}
    {domain/defs/CoreConfigRepositoryDefs.i}
    
    define variable dataRepositoryObj as ICoreConfigRepository.
    
    
    // Constructors .............................................
    
    // Default constructor
    constructor public CoreConfigApi (  ):
        super ().
        
        if (not valid-object(dataRepositoryObj) ) then 
        do:
            dataRepositoryObj = new CoreConfigRepository().
        end.
        
    end constructor.
    
    // Constructor with dependency injection 
    constructor public CoreConfigApi ( input coreCfgRepoObj as ICoreConfigRepository  ):
        super ().
        
        if (valid-object(coreCfgRepoObj) ) then 
        do:
            dataRepositoryObj = coreCfgRepoObj.
        end.
        
    end constructor.
    
    destructor public CoreConfigApi ( ):
       
       // clear memeory 
        empty temp-table coreConfigTable.
        empty temp-table updtCoreConfigTable.
        empty temp-table coreConfigInfo.
       
        if (valid-object(dataRepositoryObj)) then 
        do:
            delete object dataRepositoryObj.
            dataRepositoryObj = ?.
        end.
       
    end destructor.
    
    
    // Methods ......................................................
    
   /*------------------------------------------------------------------------------
      Purpose: Get all configuration variables
      Notes:
     ------------------------------------------------------------------------------*/    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    method public void GetAll 
        (input cfgGrp as character,
        output pgmExec  as character,
        output successMsg as character, 
        output sucess as logical,
        output table coreConfigTable ) :
            
        // clear temp-tables from memory 
        empty temp-table coreConfigTable.
        empty temp-table coreConfigInfo.    
        
        // Considerations
        if (cfgGrp eq ?) then cfgGrp = "".
        
        // Get all records 
        dataRepositoryObj:GetAll(input cfgGrp, output table coreConfigInfo).
        
        // Map to API table
        for each coreConfigInfo:
             create coreConfigTable.
             buffer-copy coreConfigInfo to coreConfigTable.
        end.
        
        pgmExec = "api.CoreConfigApi-GetAll".
        successMsg = "OK".
        sucess = true.
        
        return.
        
        finally:
            
            // clear table returned by repo
            empty temp-table coreConfigInfo. 
        
        end finally.
        
    end method.

    /*------------------------------------------------------------------------------
      Purpose: Get all confiruration groups
      Notes:
     ------------------------------------------------------------------------------*/          
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    method public void GetGroups
        (output pgmExec  as character,
        output successMsg as character, 
        output sucess as logical,
        output table coreConfigTable ) : 
            
        // variables
        define variable isAlredyIncluded as logical no-undo.
       
        // clear temp-tables from memory 
        empty temp-table coreConfigTable.
        empty temp-table coreConfigInfo.          
       
        // Get config groups 
        dataRepositoryObj:GeGroups(output table coreConfigInfo).
        
        // Map to API table
        for each coreConfigInfo:
            create coreConfigTable.
            buffer-copy coreConfigInfo to coreConfigTable.
        end.
        
        pgmExec = "api.CoreConfigApi-GeGroups".
        successMsg = "OK".
        sucess = true.
        
        return.
        
        finally:
            
            // clear table returned by repo
            empty temp-table coreConfigInfo. 
        
        end finally.
                
    end method.      
  
    /*------------------------------------------------------------------------------
      Purpose: Get a configuration variable by Id 
      Notes:
     ------------------------------------------------------------------------------*/    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    method public void GetOneById
        (input uniqueID as integer,
        output pgmExec  as character,
        output successMsg as character, 
        output sucess as logical,
        output table coreConfigTable): 
                    
        // clear temp-tables from memory 
        empty temp-table coreConfigTable.
        empty temp-table coreConfigInfo.    
        
        // Get single record 
        dataRepositoryObj:GetOneById(input uniqueID, output table coreConfigInfo).
        
        find first coreConfigInfo no-error.
        if (not available coreConfigInfo) then 
        do:
            successMsg = "Record-not-found".
            sucess = false.
        end.
        else
        do:
            // Map local to API table
            for each coreConfigInfo:
                create coreConfigTable.
                buffer-copy coreConfigInfo to coreConfigTable.
            end.
            
            successMsg = "OK".
            sucess = true.
            
        end.
        
        pgmExec = "api.CoreConfigApi-GetOneById".           
        
        return.
        
        finally:
            
            // clear table returned by repo
            empty temp-table coreConfigInfo. 
        
        end finally.            
                    
    end method.

     /*------------------------------------------------------------------------------
      Purpose: Delete one record by id
      Notes:
     ------------------------------------------------------------------------------*/   
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    method public void DeleteOne
        (input uniqueID as integer,
        output pgmExec  as character,
        output successMsg as character, 
        output sucess as logical,
        output table coreConfigTable) : 
        
        // variables
        define variable execSuccess as logical no-undo.
        define variable execStatus as character no-undo.
        
        // clear temp-tables from memory 
        empty temp-table coreConfigTable.
        empty temp-table coreConfigInfo.  
        
        // Delete record 
        execSuccess = dataRepositoryObj:DeleteOne(input uniqueID, output execStatus, output table coreConfigInfo).
        
        if (execSuccess) then 
        do:
            // TODO: Consder returning deleted data
            // Map local to API table
            for each coreConfigInfo:
                create coreConfigTable.
                buffer-copy coreConfigInfo to coreConfigTable.
            end.
            
            successMsg = "OK".
            sucess = true.
        end.
        else
        do:
            successMsg = execStatus.
            sucess = false.
        end.
        
        pgmExec = "api.CoreConfigApi-DeleteOne".        
            
        return.
        
        finally:
            
            // clear table returned by repo
            empty temp-table coreConfigInfo. 
        
        end finally. 
                        
    end method.

    /*------------------------------------------------------------------------------
     Purpose: Create new configuration variable
     Notes:
    ------------------------------------------------------------------------------*/    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    method public void CreateOne
        ( input cfgGrp as character, 
        input cfgSgrp as character,
        input keyName as character,
        input keyValue as character,
        input keyNotes as character,
        output pgmExec  as character,
        output successMsg as character, 
        output sucess as logical,
        output table coreConfigTable ) : 
        
        // variables
        define variable uniqueId    as integer   no-undo.
        define variable execSuccess as logical   no-undo.
        define variable execStatus  as character no-undo.
        
        // clear temp-tables from memory 
        empty temp-table coreConfigTable.
        empty temp-table coreConfigInfo.  
        
        // Create or update a record 
        dataRepositoryObj:CreateOne(input cfgGrp,
                input cfgSgrp, 
                input keyName, 
                input keyValue, 
                input keyNotes, 
                output execStatus, 
                output table coreConfigInfo).
        
         // Map local to API table
        for each coreConfigInfo:
            create coreConfigTable.
            buffer-copy coreConfigInfo to coreConfigTable.
        end.
            
        successMsg = "OK".
        sucess = true.
        pgmExec = "api.CoreConfigApi-CreateOne".  
        
        return.
        
        finally:
            
            // clear table returned by repo
            empty temp-table coreConfigInfo. 
        
        end finally. 
                            
    end method.

   /*------------------------------------------------------------------------------
      Purpose: update a configuration variable
      Notes:
     ------------------------------------------------------------------------------*/    
    @openapi.openedge.export(type="REST", useReturnValue="false", writeDataSetBeforeImage="false").
    method public void UpdateOne
        ( input uniqueID as integer,
        input dataset coreConfigSet,
        output pgmExec  as character,
        output successMsg as character, 
        output sucess as logical,
        output table coreConfigTable  ) : 
        
        // variables
        define variable execSuccess as logical   no-undo.
        define variable execStatus  as character no-undo. 
        
        // clear temp-tables from memory 
        empty temp-table coreConfigTable.
        empty temp-table coreConfigInfo.         
        
        // Validate teh data  
        find first updtCoreConfigTable no-error.
        if (not available updtCoreConfigTable) then 
        do:
            successMsg = "Eempty-Dataset".
            sucess = true.
            pgmExec = "api.CoreConfigApi-UpdateOne".  
            return.
        end. 
        
        // Mapp input to local table
        create coreConfigInfo.         
        buffer-copy updtCoreConfigTable to coreConfigInfo.
         
        // Update tehy record  
        execSuccess = dataRepositoryObj:UpdateOne(input uniqueID, 
                    input-output table coreConfigInfo, 
                    output execStatus).
         
        if (execSuccess) then 
        do:
            // Map local to API table
            for each coreConfigInfo:
                create coreConfigTable.
                buffer-copy coreConfigInfo to coreConfigTable.
            end.
            
            successMsg = execStatus.
            sucess = true.
        end.
        else
        do:
            if (execStatus eq "") then execStatus = "Record-Not-Found".
            successMsg = execStatus.
            sucess = false.
            
        end.
         
        pgmExec = "api.CoreConfigApi-UpdateOne".   
         
         
        return.
        
        finally:
            
            // clear table returned by repo
            empty temp-table coreConfigInfo. 
        
        end finally.                        
    end method.

    

end class.