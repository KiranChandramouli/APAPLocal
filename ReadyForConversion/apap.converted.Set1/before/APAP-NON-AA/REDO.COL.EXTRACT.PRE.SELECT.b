* Version 1 13/04/00  GLOBUS Release No. 200508 30/06/05
*-----------------------------------------------------------------------------
* <Rating>-53</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COL.EXTRACT.PRE.SELECT
*-----------------------------------------------------------------------------
* REDO COLLECTOR EXTRACT PRE-Process Load routine
* Service : REDO.COL.EXTRACT.PRE
*-----------------------------------------------------------------------------
* Modification Details:
*=====================
* 14/09/2011 - PACS00110378         En lugar de leer toda la CUSTOMER.ACCOUNT leer los prestamos
*                                   para mejorar el Performance y extraer los ID de clientes
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.COL.EXTRACT.PRE.COMMON
$INSERT I_F.DATES
*-----------------------------------------------------------------------------
  LIST.PARAMETERS = '' ; ID.LIST = ''

  IF NOT(C.ALREADY.PROCESSED) THEN      ;* This is first time that th process is executed
    GOSUB CRITERIA.VALUE
    LIST.PARAMETERS<2> = 'F.AA.ARRANGEMENT'
    LIST.PARAMETERS<3> = CRITERIA
    CALL OCOMO("Deleting F.REDO.MSG.COL.QUEUE content")
    CALL EB.CLEAR.FILE(FN.REDO.COL.MSG.QUEUE, F.REDO.COL.MSG.QUEUE)
  END ELSE
    CALL OCOMO("Atention!!!!")
    CALL OCOMO("-------------")
    CALL OCOMO("Process was already executing, this an re-execution process ")
  END

  CALL OCOMO("Deleting F.REDO.COL.QUEUE content")
  CALL EB.CLEAR.FILE(FN.REDO.COL.QUEUE, F.REDO.COL.QUEUE)

*
  GOSUB DELETE.ERROR.TRACE    ;* Just delete ERROR from trace
*

  CALL OCOMO("Deleting F.REDO.COL.QUEUE.ERROR content")
  CALL EB.CLEAR.FILE(FN.REDO.COL.QUEUE.ERROR, F.REDO.COL.QUEUE.ERROR)
*
  CALL BATCH.BUILD.LIST(LIST.PARAMETERS,ID.LIST)

  RETURN
*-------------------------------------------------------------
* Create the list of Elements to process
DELETE.ERROR.TRACE:
*-------------------------------------------------------------
  NUM.TABLE=0
  NUM.TABLE = DCOUNT(C.TABLE.PROCESS,VM)
  SELECT.STMT=''
  FOR I=1 TO NUM.TABLE

    SELECT.STMT :=' OR TABLE EQ ':C.TABLE.PROCESS<1,I>

  NEXT I

  FILE.NAME = FN.REDO.COL.TRACE
  FILE.NAME<2> = " WITH @ID LIKE " : TODAY : ".... ":SELECT.STMT
  CALL EB.CLEAR.FILE(FILE.NAME, F.REDO.COL.TRACE)


  RETURN
*-------------------------------------------------------------
CRITERIA.VALUE:
*-------------------------------------------------------------

  NUM.PRODUCT =DCOUNT(C.AA.PRODUCT.GROUP<1>,VM)
  NUM.STATUS  =DCOUNT(C.AA.STATUS<1>,VM)
  CRITERIA    ='ARR.STATUS EQ '
  FOR I=1 TO NUM.STATUS
    CRITERIA   :=C.AA.STATUS<1,I>:' '
  NEXT I

  CRITERIA   :='AND PRODUCT.GROUP EQ '

  FOR I=1 TO NUM.PRODUCT
    CRITERIA   :=C.AA.PRODUCT.GROUP<1,I>:' '
  NEXT I

  CRITERIA   :='AND START.DATE LE ':R.DATES(EB.DAT.LAST.WORKING.DAY):' CUSTOMER'

  RETURN
END
