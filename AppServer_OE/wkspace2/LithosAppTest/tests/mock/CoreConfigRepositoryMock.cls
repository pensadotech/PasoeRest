 
 /*------------------------------------------------------------------------
    File        : mock/CoreConfigRepositoryMock
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Pensado
    Created     : Fri Sep 04 11:20:54 PDT 2020
    Notes       : 
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using domain.interfaces.*.

block-level on error undo, throw.

class mock.CoreConfigRepositoryMock implements ICoreConfigRepository: 

     // Private members ............................................
    {domain/defs/CoreConfigRepositoryDefs.i} 
    
    define temp-table ttCORE_CONFIG like CORE_CONFIG.
    
    // Constructors ................................................

    constructor public CoreConfigRepositoryMock (  ):
        super ().
        
        // Initalize Mock data
        InitializeMockData().
        
    end constructor.

    destructor public CoreConfigRepositoryMock ( ):
        
        // Clear memory 
        empty temp-table ttCORE_CONFIG.
        empty temp-table coreConfigInfo.
        
    end destructor.


    // Methods ......................................................
    
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
        for each ttCORE_CONFIG no-lock:
            
            // apply filter if provided
            if( cfgGrp ne "" and cfgGrp ne ttCORE_CONFIG.CfgGrp ) then 
            do:
                next lbl-var.
            end.
            
            create coreConfigInfo.
            buffer-copy ttCORE_CONFIG to coreConfigInfo.
            coreConfigInfo.uniqueId = recid(ttCORE_CONFIG).
            
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
        for each ttCORE_CONFIG no-lock:
            
            // Is the configuration group arelady inlcuded?
            isAlreadyIncluded = can-find(first coreConfigInfo
                                         where coreConfigInfo.CfgGrp eq ttCORE_CONFIG.CfgGrp).
            
            if (not isAlreadyIncluded) then
            do:
                create coreConfigInfo.
                buffer-copy ttCORE_CONFIG to coreConfigInfo.
                coreConfigInfo.uniqueid = recid(ttCORE_CONFIG).
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
            find first ttCORE_CONFIG no-lock no-error.
        end.
        else
        do:
            find first ttCORE_CONFIG 
                where ttCORE_CONFIG.CfgGrp eq cfgGrp
                no-lock no-error.
        end.
        
        if (available ttCORE_CONFIG) then 
        do:
            create coreConfigInfo.
            buffer-copy ttCORE_CONFIG to coreConfigInfo.
            coreConfigInfo.uniqueid = recid(ttCORE_CONFIG).
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
        
        find first ttCORE_CONFIG 
            where recid(ttCORE_CONFIG) eq uniqueID
            no-lock no-error.
             
        if (available ttCORE_CONFIG) then 
        do:
            create coreConfigInfo.
            buffer-copy ttCORE_CONFIG to coreConfigInfo.
            coreConfigInfo.uniqueid = recid(ttCORE_CONFIG).
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
        
        find first ttCORE_CONFIG where recid(ttCORE_CONFIG) eq uniqueID no-lock no-error.
        
        if (available ttCORE_CONFIG) then 
        do:
            // Keep a copy in memory 
            create coreConfigInfo.
            buffer-copy ttCORE_CONFIG to coreConfigInfo.
            
            // delete record 
            delete ttCORE_CONFIG.
            
            excuteSucess = true. 
            executeStatus = "OK".
            
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
        define variable excuteSucess as logical no-undo.
       
        // Clear temp-table from memory       
        empty temp-table coreConfigInfo.
       
        // Translate entry into teh local temp-table
        // and apply security considerations 
        create coreConfigInfo.
        assign
            coreConfigInfo.CfgGrp   = cfgGrp
            coreConfigInfo.CfgSgrp  = cfgSgrp
            coreConfigInfo.KeyName  = keyName
            coreConfigInfo.KeyValue = keyValue
            coreConfigInfo.Notes    = keyNotes
            coreConfigInfo.uniqueid = 0.
       
       // create or update the record
       find first ttCORE_CONFIG
            where ttCORE_CONFIG.CfgGrp  eq  cfgGrp
              and ttCORE_CONFIG.CfgSgrp eq cfgSgrp
              and ttCORE_CONFIG.KeyName eq keyName
            no-error.
       if ( not available ttCORE_CONFIG) then 
       do:           
            create ttCORE_CONFIG.
       end.
       
       buffer-copy coreConfigInfo to ttCORE_CONFIG.
       coreConfigInfo.uniqueid = recid(ttCORE_CONFIG).
       
       excuteSucess = true. 
       executeStatus = "OK". 
       
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
        find first ttCORE_CONFIG where recid(ttCORE_CONFIG) eq uniqueId no-lock no-error.
        
        if (available ttCORE_CONFIG) then
        do:
             //  update the record 
             buffer-copy coreConfigInfo to ttCORE_CONFIG.
            coreConfigInfo.uniqueid = recid(ttCORE_CONFIG).
            excuteSucess = true. 
            executeStatus = "OK".  
        end.
        else
        do:
            excuteSucess = false. 
            executeStatus = "RECORD-DOES-NOT-EXISTS".  
        end.
  
        return excuteSucess.         
             
    end method.   
    
    
    
    // Private methods ..............................................
    
   /*------------------------------------------------------------------------------
      Purpose: Initalize prenetd data
      Notes:
     ------------------------------------------------------------------------------*/
    method private void InitializeMockData
          ():
              
        // Clear temp-table from memory 
        empty temp-table ttCORE_CONFIG.      
        
        lbl-rcd:
        for each CORE_CONFIG no-lock:
            create ttCORE_CONFIG.
            buffer-copy CORE_CONFIG to ttCORE_CONFIG.
        end.
        
        return.      
              
    end method.           
 
end class.