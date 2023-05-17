* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-2</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COL.DELIVERY.SELECT
*-----------------------------------------------------------------------------
* REDO DELIVERY INTERFACE
* Create the list of the tables to be proceesed on this interface
*-----------------------------------------------------------------------------
  $INSERT I_COMMON
  $INSERT I_EQUATE
  $INSERT I_BATCH.FILES
  $INSERT I_REDO.COL.DELIVERY.COMMON
*-----------------------------------------------------------------------------

  LIST.PARAMETERS = '' ; ID.LIST = ''

* This list contains the name of the tables to process
* We take one by one, because we need to guarantee the ACID for eact table
  E = ''
  CALL  REDO.COL.R.DEL.UPD.LOCKING("READ", ID.LIST)
  IF E NE '' THEN
    CALL OCOMO("OMITTING THE COLLECTOR.DELIVERY PROCESS")
    CALL OCOMO(E)
    ID.LIST = ""
  END

  CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)

  RETURN
END
