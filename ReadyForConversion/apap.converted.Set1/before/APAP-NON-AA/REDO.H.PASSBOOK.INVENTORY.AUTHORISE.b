*--------------------------------------------------------------------------------------------------------
* <Rating>-30</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.H.PASSBOOK.INVENTORY.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.H.PASSBOOK.INVENTORY.AUTHORISE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a authorisation routine to
*Linked With  : REDO.H.PASSBOOK.INVENTORY.AUTHORISE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                      Reference               Description
*   ------         ------                    -------------            -------------
*  10-10-2011       JEEVA T                     B.42
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.H.PASSBOOK.INVENTORY
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB OPEN.FILE
  GOSUB PROCESS.PARA
  RETURN
*--------------------------------------------------------------------------------------------------------
OPEN.FILE:
*--------------------------------------------------------------------------------------------------------

  FN.REDO.ITEM.SERIES = 'F.REDO.ITEM.SERIES'
  F.REDO.ITEM.SERIES =''
  CALL OPF(FN.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES)

  RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------
  R.REDO.ITEM.SERIES = ''
  Y.COMPANY = R.NEW(REDO.PASS.BRANCH.DEPT)
  Y.CODE =    R.NEW(REDO.PASS.CODE)
  Y.ITEM =    R.NEW(REDO.PASS.ITEM.CODE)
  Y.FRM =  R.NEW(REDO.PASS.SERIAL.NO)
  Y.STATUS = R.NEW(REDO.PASS.STATUS)
  IF Y.STATUS EQ 'AVAILABLE' THEN
    IF Y.CODE THEN
      Y.ID = Y.COMPANY:'-':Y.CODE:'.':Y.ITEM
    END ELSE
      Y.ID = Y.COMPANY:'.':Y.ITEM
    END
    CALL F.READ(FN.REDO.ITEM.SERIES,Y.ID,R.REDO.ITEM.SERIES,F.REDO.ITEM.SERIES,Y.ERR)
    R.REDO.ITEM.SERIES<-1> = Y.FRM:'*':Y.STATUS:'*':ID.NEW:"*":R.NEW(REDO.PASS.DATE.UPDATED)
    CALL F.WRITE(FN.REDO.ITEM.SERIES,Y.ID,R.REDO.ITEM.SERIES)
  END
  RETURN
END
