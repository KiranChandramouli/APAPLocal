*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.INP.CHQ.REPRINT.OVRD
*------------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Shankar Raju
*Program Name      : REDO.INP.CHQ.REPRINT.OVRD
*Date              : 11 MARCH 2011
*-----------------------------------------------------------------------------------------------------------------
*Description       : This is a input routine which will show override when check is printed next day/after
*------------------------------------------------------------------------------------------------------------------
* Input/Output:
* -------------
* In  : N/A
* Out : N/A
*------------------------------------------------------------------------------------------------------------------
* Dependencies:
* -------------
* Calls     : N/A
* Called By : N/A
*------------------------------------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.PRINT.CHQ.LIST
*
  R.NEW(PRINT.CHQ.LIST.OVERRIDE)=''
  TAM.V.OVERRIDES = OFS$OVERRIDES
  TAM.V.OVERRIDES = FIELD(TAM.V.OVERRIDES,FM,2)
  TAM.V.OVERRIDES = CHANGE(TAM.V.OVERRIDES,'NO','')
  TAM.V.OVERRIDES = CHANGE(TAM.V.OVERRIDES,VM,'')
  VAR.PRINT = R.NEW(PRINT.CHQ.LIST.PRINT)
  IF OFS$OPERATION EQ 'PROCESS' AND VAR.PRINT EQ 'Y' THEN
    GOSUB INITIALISE
    GOSUB PROCESS
  END
*
  RETURN
*---------------------------------------------------------------------------------
INITIALISE:
*==========

  Y.CHQ.NO = R.NEW(PRINT.CHQ.LIST.CHEQUE.NO)
  Y.AMOUNT = R.NEW(PRINT.CHQ.LIST.AMOUNT)
  Y.BENEFI = R.NEW(PRINT.CHQ.LIST.BENEFICIARY)
  IF TAM.V.OVERRIDES EQ '' THEN
    IF R.NEW(PRINT.CHQ.LIST.NO.OF.REPRINT) EQ '' THEN
      R.NEW(PRINT.CHQ.LIST.NO.OF.REPRINT) = 1
    END ELSE
      R.NEW(PRINT.CHQ.LIST.NO.OF.REPRINT) += 1
    END
  END

  RETURN
*---------------------------------------------------------------------------------
PROCESS:
*=======
  CURR.NO=DCOUNT(R.NEW(PRINT.CHQ.LIST.OVERRIDE),VM) + 1

  TEXT="REDO.CHQ.REPRINT.OVR":FM:Y.CHQ.NO
  CALL STORE.OVERRIDE(CURR.NO)

  TEXT="REDO.CHQ.REPRINT.OVRD"
  CALL STORE.OVERRIDE(CURR.NO+1)

  RETURN
*---------------------------------------------------------------------------------
END
