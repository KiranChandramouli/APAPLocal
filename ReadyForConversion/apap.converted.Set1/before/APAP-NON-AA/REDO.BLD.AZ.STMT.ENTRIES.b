*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BLD.AZ.STMT.ENTRIES(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  :
* Program Name  : REDO.BLD.E.REPRINT.TXN
*-------------------------------------------------------------------------
* Description:
*
*----------------------------------------------------------
* Linked with: All enquiries with AZ.ACCOUNT no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
***********************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.AZ.ACCOUNT


  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN

*---------
OPENFILES:
*----------

  FN.AZ.ACCOUNT = 'F.AZ.ACCOUNT'
  F.AZ.ACCOUNT = ''
  CALL OPF(FN.AZ.ACCOUNT,F.AZ.ACCOUNT)
  LOC.REF.APPLICATION="AZ.ACCOUNT"
  LOC.REF.FIELDS='L.TYPE.INT.PAY'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  POS.L.TYPE.INT.PAY = LOC.REF.POS<1,1>
  RETURN
*------------
PROCESS:
*------------
  Y.VAL  = ENQ.DATA<2,1>
  ENQ.DATA<3,1> ="EQ"
  Y.VAL = ENQ.DATA<4,1>
  CALL F.READ(FN.AZ.ACCOUNT,Y.VAL,R.AZ.ACCOUNT,F.AZ.ACCOUNT,Y.ERR.DSQ)
  IF R.AZ.ACCOUNT THEN
    Y.TYPE.INT.PAY = R.AZ.ACCOUNT<AZ.LOCAL.REF,POS.L.TYPE.INT.PAY>
    IF Y.TYPE.INT.PAY NE 'Reinvested' THEN
      ENQ.ERROR = 'EB-REINVEST.AZ.STMT.ENTRIES'
    END
  END
  RETURN
**************************************
END
