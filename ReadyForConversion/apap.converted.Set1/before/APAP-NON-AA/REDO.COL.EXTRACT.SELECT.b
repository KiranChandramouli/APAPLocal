*-------------------------------------------------------------------------
* <Rating>-46</Rating>
*-------------------------------------------------------------------------
  SUBROUTINE REDO.COL.EXTRACT.SELECT
********************************************************************
* Company   Name    :  APAP
* Developed By      : Temenos Application Management mgudino@tamenos.com
*--------------------------------------------------------------------------------------------
* Description:       Routine to extract data list of customer to past to REDO.COL.EXTRACT Routine
* Linked With:       REDO.COL.EXTRACT Service
* In Parameter:
* Out Parameter:     EXTRACT.LIST
*--------------------------------------------------------------------------------------------
* Modification Details:
*=====================
* 14/09/2011 - PACS00110378         El registro del log del procesamiento lo haga en una cola
*
* 05/12/2011 - PACS00169639         COB improvements hpasquel@temenos.com

$INSERT I_COMMON
$INSERT I_EQUATE
  $INSERT I_REDO.COL.CUSTOMER.COMMON
*
  GOSUB PROCESS
  RETURN

*------------------------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------------------------

  LIST.PARAMETERS = '' ; ID.LIST = ''
*
  Y.ERROR = @FALSE
  GOSUB TEST.DB.CONNECTION
* If Oracle is not available, then the process could not send any information to COLLECTOR DB
  IF Y.ERROR EQ @FALSE THEN
    LIST.PARAMETERS<2> = 'F.REDO.COL.EXTRACT.CONTROL'
    LIST.PARAMETERS<3> = ''
  END
*
  C.DESC = 'SELECCION DE DATOS EN REDO.COL.EXTRACT.SELECT ':Y.PROCESS.FLAG.TABLE
  GOSUB STORE.MSG.ON.QUEUE
*
  CALL BATCH.BUILD.LIST(LIST.PARAMETERS, ID.LIST)

  RETURN

*------------------------------------------------------------------------------------------------------
STORE.MSG.ON.QUEUE:
* Keep information for C.22 interface.
*------------------------------------------------------------------------------------------------------

  Y.MSG.QUEUE.ID = ''
  CALL ALLOCATE.UNIQUE.TIME(Y.MSG.QUEUE.ID)
  R.REDO.COL.MSG.QUEUE = C.DESC
  WRITE R.REDO.COL.MSG.QUEUE TO F.REDO.COL.MSG.QUEUE, Y.MSG.QUEUE.ID ON ERROR CALL OCOMO("NO REGISTRO EL SUCESO")
  

  RETURN

*-----------------------------------------------------------------------
TEST.DB.CONNECTION:
*<< PACS00169639, TEST DB CONNECTION BEFORE TO START EXTRACT & DELIVERY PROCESS
*-----------------------------------------------------------------------

  REDO.INTERFACE.PARAM.ID = "COL001"    ;* Just for this interface !! Warning, if we created COL002 ?
  CALL CACHE.READ('F.REDO.INTERFACE.PARAM',REDO.INTERFACE.PARAM.ID,R.REDO.INTERFACE.PARAM,YERR)
* Load String connection on Common Variable
  Y.CONNECTION = ''
  E = ''
  CALL REDO.COL.R.GET.CONNECTION(REDO.INTERFACE.PARAM.ID, R.REDO.INTERFACE.PARAM, Y.CONNECTION)
  Y.CONNECTION = CHANGE(Y.CONNECTION, FM, "@fm")
  IF E NE '' THEN
    TEXT = E
    CALL FATAL.ERROR("REDO.COL.DELIVERY.LOAD")
    RETURN
  END
* Open Data Base Connection
  Y.EB.API.ID = "REDO.COL.DB.OPEN"
  Y.REQUEST     = Y.CONNECTION
  GOSUB CALL.JAVA
  IF Y.ERROR THEN
    RETURN
  END

  Y.EB.API.ID = "REDO.COL.DB.CLOSE"
  Y.REQUEST     = ''
  GOSUB CALL.JAVA
  IF Y.ERROR THEN
    Y.ERROR = 0
    CALL OCOMO("JAVA EXCEPTION TRYING TO CLOSE THE CONNECTION, PLEASE CHECK")
  END

  RETURN
*-----------------------------------------------------------------------
CALL.JAVA:
*-----------------------------------------------------------------------
  Y.RESPONSE    = ''
  CALL REDO.COL.R.CALL.JAVA.API(Y.EB.API.ID, Y.REQUEST, Y.RESPONSE)
  IF Y.RESPONSE NE '' THEN
    C.DESC = Y.RESPONSE
    GOSUB STORE.MSG.ON.QUEUE
    Y.ERROR = @TRUE
    CALL REDO.R.COL.EXTRACT.ERROR(C.DESC, "REDO.COL.EXTRACT.SELECT","TMPCLIENTES")
    CALL REDO.R.COL.PROCESS.TRACE('EXTRACT', 20, 1, "TMPCLIENTES", '', C.DESC)
  END
  RETURN
*-----------------------------------------------------------------------
END
