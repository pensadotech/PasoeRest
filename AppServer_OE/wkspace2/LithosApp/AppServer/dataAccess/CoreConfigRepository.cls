 
/*------------------------------------------------------------------------
   File        : dataAccess/CoreConfigRepository
   Purpose     : Repository for Core configuration
   Syntax      : 
   Description : 
   Author(s)   : apens
   Created     : Fri Sep 04 09:22:52 PDT 2020
   Notes       : 
 ----------------------------------------------------------------------*/

using Progress.Lang.*.
using domain.interfaces.*.

block-level on error undo, throw.

class dataAccess.CoreConfigRepository implements ICoreConfigRepository: 

    // Private members ............................................
    {domain/defs/CoreConfigRepositoryDefs.i} 
    
    // Constructors ................................................
   
    constructor public CoreConfigRepository (  ):
        super ().
        
    end constructor.
 
    destructor public CoreConfigRepository ( ):
            
        empty temp-table coreConfigInfo.
            
    end destructor.
    
    // Methods ........................................................
    
   /*------------------------------------------------------------------------------
      Purpose: Get all configuration variables
      Notes:
     ------------------------------------------------------------------------------*/
    method public void GetAll 
        (input cfgGrp as character,
         output table coreConfigInfo):
       
       // Clear temp-table from memory       
        empty temp-table coreConfigInfo.
          
        // Get all configuration variables
        lbl-var:
        for each CORE_CONFIG no-lock:
            
            // apply filter if provided
            if( cfgGrp ne "" and cfgGrp ne CORE_CONFIG.CfgGrp ) then 
            do:
                next lbl-var.
            end.
            
            create coreConfigInfo.
            buffer-copy CORE_CONFIG to coreConfigInfo.
            coreConfigInfo.uniqueId = recid(CORE_CONFIG).
            
        end. // for each
               
        return.
             
    end method.

    /*------------------------------------------------------------------------------
      Purpose: Get all confiruration groups
      Notes:
     ------------------------------------------------------------------------------*/  
    method public void GeGroups
        (output table coreConfigInfo):
            
         // Variables
        define variable isAlreadyIncluded as logical no-undo. 
           
        // Clear temp-table from memory       
        empty temp-table coreConfigInfo.
        
        // Get all gloabl variables
        lbl-var:
        for each CORE_CONFIG no-lock:
            
            // Is the configuration group arelady inlcuded?
            isAlreadyIncluded = can-find(first coreConfigInfo
                                          where coreConfigInfo.CfgGrp eq CORE_CONFIG.CfgGrp).
            
            if (not isAlreadyIncluded) then
            do:
                create coreConfigInfo.
                buffer-copy CORE_CONFIG to coreConfigInfo.
                coreConfigInfo.uniqueid = recid(CORE_CONFIG).
            end.
            
        end. // for each
           
        return.   
            
     end method.

    /*------------------------------------------------------------------------------
      Purpose: Get first configuration variable inside a group
      Notes:
     ------------------------------------------------------------------------------*/    
    method public void GetFirst 
        (input cfgGrp as character,
         output table coreConfigInfo):
            
        // Clear temp-table from memory       
        empty temp-table coreConfigInfo.
        
        // Filter consideration
        if (cfgGrp eq ?) then cfgGrp = "".
        
        // Get first record
        if (cfgGrp eq "") then 
        do:
            find first CORE_CONFIG no-lock no-error.
        end.
        else
        do:
            find first CORE_CONFIG 
                where CORE_CONFIG.CfgGrp eq cfgGrp
                no-lock no-error.
        end.
        
        if (available CORE_CONFIG) then 
        do:
            create coreConfigInfo.
            buffer-copy CORE_CONFIG to coreConfigInfo.
            coreConfigInfo.uniqueid = recid(CORE_CONFIG).
        end.
             
        return.   
             
    end method.
   
    /*------------------------------------------------------------------------------
      Purpose: Get a configuration variable by Id 
      Notes:
     ------------------------------------------------------------------------------*/    
    method public void GetOneById
        (input uniqueID as integer,
         output table coreConfigInfo):
       
       // Clear temp-table from memory       
        empty temp-table coreConfigInfo.
        
        find first CORE_CONFIG 
            where recid(CORE_CONFIG) eq uniqueID
            no-lock no-error.
             
        if (available CORE_CONFIG) then 
        do:
            create coreConfigInfo.
            buffer-copy CORE_CONFIG to coreConfigInfo.
            coreConfigInfo.uniqueid = recid(CORE_CONFIG).
        end.
            
        return.      
             
    end method.

     /*------------------------------------------------------------------------------
      Purpose: Delete one record by id
      Notes:
     ------------------------------------------------------------------------------*/ 
    method public logical DeleteOne
        (input uniqueID as integer,
         output executeStatus as character,
         output table coreConfigInfo):
        
        // Variables
        define variable excuteSucess as logical no-undo.
        
        // Clear temp-table from memory       
        empty temp-table coreConfigInfo.
        
        find first CORE_CONFIG where recid(CORE_CONFIG) eq uniqueID no-lock no-error.
        
        if (available CORE_CONFIG) then 
        do:
            // Keep a copy in memory 
            create coreConfigInfo.
            buffer-copy CORE_CONFIG to coreConfigInfo.
            
            // delete record 
            excuteSucess = DeleteConfiguration(input rowid(CORE_CONFIG),output executeStatus).
        end.
        else
        do:
            // the record is not available anymore, that is ok
            excuteSucess = true. 
            executeStatus = "OK".  
        end.
             
        return excuteSucess.
             
    end method.

    /*------------------------------------------------------------------------------
     Purpose: Create new configuration variable
     Notes:
    ------------------------------------------------------------------------------*/ 
    method public void CreateOne
        ( input cfgGrp as character, 
        input cfgSgrp as character,
        input keyName as character,
        input keyValue as character,
        input keyNotes as character,
        output executeStatus as character,
        output table coreConfigInfo ):
       
       // variables
        define variable rcdUniqueId  as integer no-undo.
        define variable excuteSucess as logical no-undo.
       
       // Clear temp-table from memory       
        empty temp-table coreConfigInfo.
       
       // Translate entry into teh local temp-table
       // and apply security considerations 
        create coreConfigInfo.
        assign
            coreConfigInfo.CfgGrp     = cfgGrp
            coreConfigInfo.CfgSgrp    = cfgSgrp
            coreConfigInfo.KeyName    = keyName
            coreConfigInfo.KeyValue   = keyValue
            coreConfigInfo.Notes      = keyNotes
            coreConfigInfo.uniqueid   = 0.
       
       // create or update the record 
        excuteSucess = CreateOrUpdateConfiguration
            ( input rowid(coreConfigInfo),
             input-output rcdUniqueId,
             output executeStatus). 
       
        if (excuteSucess) then 
        do:
            find first coreConfigInfo no-error.
            if (available coreConfigInfo) then 
            do:
                assign 
                    coreConfigInfo.uniqueid = rcdUniqueId.
            end.    
        end.
       
        return.
              
    end method. 
 
   /*------------------------------------------------------------------------------
      Purpose: update a configuration variable
      Notes:
     ------------------------------------------------------------------------------*/  
    method public logical UpdateOne
        (input uniqueId as integer,
         input-output table coreConfigInfo,
         output executeStatus as character):
           
        // variables
        define variable excuteSucess as logical no-undo.
        
        // validate input data
        find first coreConfigInfo no-error.
        if (not available coreConfigInfo) then 
        do:
            excuteSucess= false.
            executeStatus = "NO-DATA-AVAILABLE-FOR-UPDATE".
        end.
        
        // retreive target record 
        find first CORE_CONFIG where recid(CORE_CONFIG) eq uniqueId no-lock no-error.
        
        if (available CORE_CONFIG) then
        do:
             // create or update the record 
            excuteSucess = CreateOrUpdateConfiguration
                  (input rowid(coreConfigInfo),
                  input-output uniqueId,
                  output executeStatus). 
          
            find first coreConfigInfo no-error.
            if (available coreConfigInfo) then 
            do:
                assign 
                    coreConfigInfo.uniqueid = uniqueId.
            end.
            
        end.
        else
        do:
            excuteSucess = false. 
            executeStatus = "RECORD-DOES-NOT-EXISTS (recid:" + string(uniqueId)+ ")".  
        end.
  
       return excuteSucess.         
             
             
    end method.   


   // Pirvate methods ........................................
   
   
    /*------------------------------------------------------------------------------
       Purpose: Delete one record from database considering a retry mechanism 
       Notes:
      ------------------------------------------------------------------------------*/ 
    method private final logical DeleteConfiguration 
        ( input recordRowid as rowid,
         output execResult as character):
     
        // variables
        define variable tryCount as integer no-undo.
        define variable isSucess as logical no-undo.
        // buffers 
        define buffer bfCORE_CONFIG for CORE_CONFIG. 
     
        lbl-retry:
        repeat:
     
            lbl-delete:
            do for bfCORE_CONFIG on error undo:
           
                find first bfCORE_CONFIG 
                    where rowid(bfCORE_CONFIG) eq recordRowid
                    exclusive-lock no-wait no-error.
            
                if (not available bfCORE_CONFIG) then 
                do:
                    if (locked bfCORE_CONFIG) then 
                    do:
                        tryCount= tryCount + 1. 
                        if (tryCount > 10) then undo, leave lbl-retry.
                        next lbl-retry.
                    end.
                    else
                    do:
                        // Nothing, all ok
                        isSucess = true.
                    end. 
                end.
                else
                do:
                    delete bfCORE_CONFIG.
                    isSucess = true.
                end. 
           
                // clears\ record from record-buffer and unites with databae
                release bfCORE_CONFIG.
            
            end. // do for 
     
            leave lbl-retry.
        
        end. // repeat     
        
        
        if (not isSucess) then 
            execResult = "CORE_CONFIG-RECORD-IS-LOCKED".
        else
            execResult = "OK".
        
        return isSucess.
        
    end method. 
    
    
    /*------------------------------------------------------------------------------
       Purpose: Delete one record from database considering a retry mechanism 
       Notes:
      ------------------------------------------------------------------------------*/ 
      method private final logical CreateOrUpdateConfiguration
            (input temptableRowid as rowid,
             input-output uniqueId as integer,
             output execResult as character  ) :
               
          // variables
          define variable tryCount as integer no-undo.
          define variable isSucess as logical no-undo.
          // buffers 
          define buffer bfCORE_CONFIG for CORE_CONFIG.   
                
          find first coreConfigInfo where rowid(coreConfigInfo) eq temptableRowid no-error.
          if (not available coreConfigInfo) then 
          do:
              execResult = "LOCAL-RECORD-NOT-FOUND".
              return false.
          end.
          
          
          lbl-retry:
          repeat:
     
              lbl-save:
              do for bfCORE_CONFIG on error undo:
                  
                  if (uniqueId eq 0) then 
                  do:
                       find first bfCORE_CONFIG 
                          where bfCORE_CONFIG.CfgGrp  eq coreConfigInfo.CfgGrp
                          and bfCORE_CONFIG.CfgSgrp eq coreConfigInfo.CfgSgrp
                          and bfCORE_CONFIG.KeyName eq coreConfigInfo.KeyName
                          exclusive-lock no-wait no-error.
                  end.
                  else
                  do:
                      find first bfCORE_CONFIG 
                          where recid(bfCORE_CONFIG) eq uniqueId
                          exclusive-lock no-wait no-error.
                  end.
                  
                  if (not available bfCORE_CONFIG) then 
                  do:
                      if (locked bfCORE_CONFIG) then 
                      do:
                          tryCount= tryCount + 1. 
                          if (tryCount > 10) then undo, leave lbl-retry.
                          next lbl-retry.
                      end.
                      else
                      do:
                          create bfCORE_CONFIG.
                          buffer-copy coreConfigInfo to bfCORE_CONFIG.
                          uniqueId = recid(bfCORE_CONFIG).
                          isSucess = true.
                      end. 
                  end.
                  else
                  do:
                      buffer-copy coreConfigInfo 
                                  except CfgGrp CfgSgrp KeyName
                                  to bfCORE_CONFIG.
                      assign 
                         bfCORE_CONFIG.ModifyBy   = "system"
                         bfCORE_CONFIG.ModifyDate = today.
                                     
                      uniqueId = recid(bfCORE_CONFIG).
                      isSucess = true.
                  end. 
           
                  // clears record from record-buffer and unites with databae
                  release bfCORE_CONFIG.
            
              end. // do for 
     
              leave lbl-retry.
        
          end. // repeat     
          
          if (not isSucess) then 
              execResult = "CORE_CONFIG-RECORD-IS-LOCKED-OR-NOT-FOUND".
          else
              execResult = "OK".
          
          
          return isSucess.
                 
     end method.
      

end class.