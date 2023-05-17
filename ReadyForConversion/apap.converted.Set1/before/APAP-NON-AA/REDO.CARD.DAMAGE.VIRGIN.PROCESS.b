*--------------------------------------------------------------------------------------------------------
* <Rating>-31</Rating>
*--------------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.CARD.DAMAGE.VIRGIN.PROCESS
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CARD.DAMAGE.VIRGIN.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : Check For mandatory fields in the REDO.CARD.DAMAGE.VIRGIN
*Linked With  : Application REDO.CARD.DAMAGE
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 19 MAY 2011     JEEVA T               ODR-2010-03-0400        Initail Draft
*--------------------------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COMPANY
$INSERT I_F.REDO.CARD.DAMAGE.VIRGIN

$INSERT I_F.REDO.CARD.SERIES.PARAM
$INSERT I_F.REDO.STOCK.REGISTER
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
PROCESS.PARA:
*--------------------------------------------------------------------------------------------------------
* Main processing section

  GOSUB CARD.TYPE.CHECK
  R.NEW(CARD.RET.DATE.DL)=TODAY
  RETURN
*--------------------------------------------------------------------------------------------------------
CARD.TYPE.CHECK:
*--------------------------------------------------------------------------------------------------------
  Y.CARD.TYPE.NEW = R.NEW(CARD.RET.CARD.TYPE)
  Y.LOST.LIST = R.NEW(CARD.RET.LOST)
  Y.DAMAGE.LIST = R.NEW(CARD.RET.DAMAGE)
  Y.COUNT = DCOUNT(Y.CARD.TYPE.NEW,VM)
  Y.CNT = 1
  LOOP
  WHILE Y.CNT LE Y.COUNT
    IF Y.CARD.TYPE.NEW<1,Y.CNT> AND NOT(Y.LOST.LIST<1,Y.CNT>) AND NOT(Y.DAMAGE.LIST<1,Y.CNT>) THEN
      AF = CARD.RET.LOST
      AV = Y.CNT
      ETEXT = "EB-ONE.SHLD.ENTER"
      CALL STORE.END.ERROR
      RETURN

    END
    Y.CNT = Y.CNT + 1
  REPEAT
  RETURN
END
