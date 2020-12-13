 
 /*------------------------------------------------------------------------
    File        : CoreConfigApiTest
    Purpose     : 
    Syntax      : 
    Description : 
    Author(s)   : Pensado
    Created     : Fri Sep 04 12:14:23 PDT 2020
    Notes       : OpenEdge.Core.* needed for Unit testing
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
using OpenEdge.Core.* from propath.
using api.*.
using dataAccess.*.
using domain.interfaces.*.
using mock.*.


block-level on error undo, throw.

class CoreConfigApiTest:
    
    // Private mmebers ..........................................
    {domain/defs/CoreConfigApiDefs.i}
    {domain/defs/CoreConfigRepositoryDefs.i}
    
    define variable pgmExec  as character no-undo.
    define variable successMsg as character no-undo. 
    define variable sucess as logical no-undo.
    define variable isTestSucessful as logica no-undo.
    
    define variable apiObj as ICoreConfigApi.
    define variable dataRepositoryObj as ICoreConfigRepository.
    define variable dsHdl as handle no-undo.
    
    /*------------------------------------------------------------------------------
            Purpose:   Actions to initialize test                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
   
    @Setup.
    method public void setUp(  ):
        
        // Clear memory 
        empty temp-table coreConfigTable.
        empty temp-table coreConfigInfo.
        
        // Prepare dataset 
        dsHdl = dataset coreConfigSet:handle.
        dsHdl:empty-dataset().
        
        // Use Mock repository 
        dataRepositoryObj = new CoreConfigRepositoryMock().
              
        return.

    end method.
    
    /*------------------------------------------------------------------------------
            Purpose:  Action before terminating the test                                                                       
            Notes:                                                                        
    ------------------------------------------------------------------------------*/

    @TearDown.
    method public void tearDown(  ):
        
         // Clear memory 
        empty temp-table coreConfigTable.
        empty temp-table coreConfigInfo.
        
        if (valid-object(dsHdl)) then 
        do:
            delete object dsHdl.
            dsHdl = ?.
        end.
        
        if (valid-object(dataRepositoryObj)) then 
        do:
            delete object dataRepositoryObj.
            dataRepositoryObj = ?.    
        end.
        
        if (valid-object(apiObj)) then 
        do:
           delete object apiObj.
           apiObj= ?. 
       end.
        
        return.

    end method.
      
    
    /*------------------------------------------------------------------------------
            Purpose:   Get all records Test                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @Test. 
    method public void testGetAll(  ):
        
        // Variables
        define variable cfgGrp as character no-undo.
        
        // Arrange 
        apiObj = new CoreConfigApi(input dataRepositoryObj).
        
        // Act
        apiObj:GetAll(input cfgGrp ,
                      output pgmExec,
                      output successMsg , 
                      output sucess,
                      output table coreConfigTable).
        
        // Use the FIND command to force the system
        // to bring ot memeory the incoming table
        find first coreConfigTable no-error. 
        isTestSucessful = (available coreConfigTable).
                      
        // Assert 
        assert:Equals(isTestSucessful,true) .
        
        return.
        
        // Clean test 
        finally:
            
            empty temp-table coreConfigTable. 
            
            if (valid-object(apiObj)) then 
            do:
                delete object apiObj.
                apiObj= ?.
            end.
            
        end finally.

    end method.
    
    /*------------------------------------------------------------------------------
           Purpose:   Get all records in a group Test                                                                      
           Notes:                                                                        
   ------------------------------------------------------------------------------*/
    @Test. 
    method public void testGetGroup(  ):
        
        // Variables
        define variable cfgGrp as character no-undo.
        
        // Arrange 
        apiObj = new CoreConfigApi(input dataRepositoryObj).
        
        // Target group 
        cfgGrp = "TSTGRP01".
        
        // Act
        apiObj:GetAll(input cfgGrp ,
            output pgmExec,
            output successMsg , 
            output sucess,
            output table coreConfigTable).
        
        // Use the FIND command to force the system
        // to bring ot memeory the incoming table
        find first coreConfigTable no-error. 
        isTestSucessful = (available coreConfigTable).
                      
        // Assert 
        assert:Equals(isTestSucessful,true) .
        
        return.
        
        // Clean test 
        finally:
            
            empty temp-table coreConfigTable. 
            
            if (valid-object(apiObj)) then 
            do:
                delete object apiObj.
                apiObj= ?.
            end.
            
        end finally.

    end method.
    
    /*------------------------------------------------------------------------------
            Purpose:   Get all groups test                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @Test. 
    method public void testGeGroups(  ):
        
        // Arrange 
        apiObj = new CoreConfigApi(input dataRepositoryObj).
        
        // Act
        apiObj:GetGroups(output pgmExec, 
               output successMsg, 
               output sucess, 
               output table coreConfigTable).
               
        // Use the FIND command to force the system
        // to bring ot memeory the incoming table
        find first coreConfigTable no-error. 
        isTestSucessful = (available coreConfigTable).
                      
        // Assert 
        assert:Equals(isTestSucessful,true).
        
        return.
        
        // Clean test 
        finally:
            
            empty temp-table coreConfigTable. 
            
            if (valid-object(apiObj)) then 
            do:
                delete object apiObj.
                apiObj= ?.
            end.
            
        end finally.

    end method.
    
    
    /*------------------------------------------------------------------------------
            Purpose:   Get one record by ID TEst                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @Test. 
    method public void testGetOneById(  ):
        
        // variables
        define variable uniqueId as integer no-undo.
        
        // Arrange 
        apiObj = new CoreConfigApi(input dataRepositoryObj).
        
        // Use MOck object to get a record for the test 
        uniqueId = GetFirstMock(input "").
        
        if (uniqueId <= 0 ) then 
        do:
            assert:RaiseError("Error: no record was found for test").
        end.
        
        // Act
        apiObj:GetOneById(input uniqueId,
            output pgmExec, 
            output successMsg, 
            output sucess, 
            output table coreConfigTable).
        
        // Use the FIND command to force the system
        // to bring ot memeory the incoming table
        find first coreConfigTable no-error. 
        isTestSucessful = (available coreConfigTable).
        
        // Assert 
        assert:Equals(isTestSucessful,true).
        
        // Clean test 
        finally:
            
            empty temp-table coreConfigTable. 
            
            if (valid-object(apiObj)) then 
            do:
                delete object apiObj.
                apiObj= ?.
            end.
            
        end finally.

    end method.
    
    
    /*------------------------------------------------------------------------------
            Purpose:   Delete one record Test                                                                      
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @Test. 
    method public void testDeleteOne(  ):
        
        // variables
        define variable uniqueId as integer no-undo.
        define variable execStatus as character no-undo.
        
        // Arrange 
        apiObj = new CoreConfigApi(input dataRepositoryObj).
        
        // Use the Mock object to create a record for the test 
        uniqueId = CreateOneMock (input "TST", 
                                  input "TSTGRP",
                                  input "TSTVARx",
                                  input "abc123",
                                  input "Test Notes"). 
        
        if (uniqueId <= 0 ) then 
        do:
            assert:RaiseError("Error: no record was found for test").
        end.
        
        // Act
        apiObj:DeleteOne(input uniqueId, 
                         output pgmExec, 
                         output successMsg, 
                         output sucess, 
                         output table coreConfigTable).
                         
        isTestSucessful =  sucess.
        
        // Assert 
        assert:Equals(isTestSucessful,true).                      
        
        return.
        
        // Clean test 
        finally:
            
            empty temp-table coreConfigTable. 
            
            if (valid-object(apiObj)) then 
            do:
                delete object apiObj.
                apiObj= ?.
            end.
            
        end finally.

    end method.
    
    
    /*------------------------------------------------------------------------------
            Purpose:  Create one record test                                                                       
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @Test. 
    method public void testCreateOne(  ):
                
        // variables
        define variable uniqueId   as integer   no-undo.
        
        // Arrange 
        apiObj = new CoreConfigApi(input dataRepositoryObj).
        
        // Act 
        apiObj:CreateOne(input "TST", 
                         input "TSTGRP",
                         input "TSTVARx",
                         input "abc123",
                         input "Test Notes",
                         output pgmExec,
                         output successMsg, 
                         output sucess,
                         output table coreConfigTable ).
        
        // Use the FIND command to force the system
        // to bring ot memeory the incoming table
        find first coreConfigTable no-error. 
        isTestSucessful = (available coreConfigTable and coreConfigTable.uniqueId ne 0).
        
        // Assert 
        assert:Equals(isTestSucessful,true).
        
        return.
        
        // Clean test 
        finally:
            
            empty temp-table coreConfigTable. 
            
            if (valid-object(apiObj)) then 
            do:
                delete object apiObj.
                apiObj= ?.
            end.
            
        end finally.

    end method.
    
    
    /*------------------------------------------------------------------------------
            Purpose:  Udate one record Test                                                                       
            Notes:                                                                        
    ------------------------------------------------------------------------------*/
    @Test. 
    method public void testUpdateOne(  ):
        
         // variables
        define variable uniqueId as integer no-undo.
        define variable targetValue as character no-undo.
        
        // Arrange 
        apiObj = new CoreConfigApi(input dataRepositoryObj).
        targetValue = "x1234".
        
        
        // Use the Mock object to create a record for the test 
        uniqueId = CreateOneMock (input "TST", 
                                  input "TSTGRP",
                                  input "TSTVARx",
                                  input "abc123",
                                  input "Test Notes"). 
        
        if (uniqueId <= 0 ) then 
        do:
            assert:RaiseError("Error: no record was found for test").
        end.
        
        // Prepare the dataset and update recrod value
        create updtCoreConfigTable.
        buffer-copy coreConfigInfo to updtCoreConfigTable.
        updtCoreConfigTable.KeyValue = targetValue.
        
        // Act 
        apiObj:UpdateOne(input uniqueId, 
                         input dataset coreConfigSet by-reference, 
                         output pgmExec, 
                         output successMsg, 
                         output sucess, 
                         output table coreConfigTable).
                         
        // Use the FIND command to force the system
        // to bring ot memeory the incoming table
        find first coreConfigTable no-error. 
        isTestSucessful = (available coreConfigTable and coreConfigTable.KeyValue eq targetValue).         
        
        // Assert 
        assert:Equals(isTestSucessful,true).
        
        return.
        
        // Clean test 
        finally:
            
            empty temp-table coreConfigTable. 
            
            if (valid-object(apiObj)) then 
            do:
                delete object apiObj.
                apiObj= ?.
            end.
            
        end finally.


    end method.
    
    
    // Private methods .....................................
    
    /*------------------------------------------------------------------------------
            Purpose:   MOCK - Get first record in a group                                                                     
            Notes:                                                                        
    ------------------------------------------------------------------------------*/    
    method public integer GetFirstMock
        (input cfgGrp as character):
                
                
        // variables
        define variable uniqueId as integer no-undo.
          
        // Use MOCK obj to find teh record
        dataRepositoryObj:GetFirst(input cfgGrp,output table coreConfigInfo).
          
        find first coreConfigInfo no-error.
        if (available coreConfigInfo) then 
        do:
            uniqueId = coreConfigInfo.uniqueid.
        end. 
        
        // Clear memory   
        empty temp-table coreConfigInfo.
        
        return uniqueId.
        
    end method.
    
    /*------------------------------------------------------------------------------
           Purpose:   MOCK -Create one record in a group                                                                     
           Notes:                                                                        
   ------------------------------------------------------------------------------*/       
    method public integer CreateOneMock
        (input cfgGrp as character, 
        input cfgSgrp as character,
        input keyName as character,
        input keyValue as character,
        input keyNotes as character ):
    
        // variables
        define variable uniqueId as integer no-undo.
        define variable execStatus as character no-undo.
        
        // Uske Mock to create a record 
        dataRepositoryObj:CreateOne(input cfgGrp, 
                        input cfgSgrp, 
                        input keyName, 
                        input keyValue, 
                        input keyNotes, 
                        output execStatus, 
                        output table coreConfigInfo).
        
        find first coreConfigInfo no-error.
        if (available coreConfigInfo) then 
        do:
            uniqueId = coreConfigInfo.uniqueid.
        end. 
            
        return uniqueId.
        
    end method.
    
    
end class.