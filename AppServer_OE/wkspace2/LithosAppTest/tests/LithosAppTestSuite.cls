 
 /*------------------------------------------------------------------------
    File        : LithosAppTestSuite
    Syntax      : 
    Author(s)   : Pensado
    Created     : Fri Sep 04 13:51:12 PDT 2020
    Notes       :  The test suite can include a collection of indiviual
                   test in teh following format

                   @TestSuite(classes="myModule1Tes,myModule2Test,myModule3Test").
  ----------------------------------------------------------------------*/

using Progress.Lang.*.
block-level on error undo, throw.
@TestSuite(classes="CoreConfigApiTest").
class LithosAppTestSuite: 

end class.