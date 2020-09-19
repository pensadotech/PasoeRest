
/*------------------------------------------------------------------------
    File        : domain/defs/CoreConfigApiDefs.i
    Purpose     : API definitions for Core configuration

    Syntax      :

    Description : 

    Author(s)   : Pensado
    Created     : Fri Sep 04 09:08:01 PDT 2020
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

define temp-table coreConfigTable like CORE_CONFIG
           field uniqueId as integer.

define temp-table updtCoreConfigTable like CORE_CONFIG.
define dataset coreConfigSet for updtCoreConfigTable.
