*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.DT.TR.APP(TR.APPROVER)
*---------------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : GANESH R
* Program Name  : REDO.APAP.DT.TR.APP
* ODR NUMBER    : ODR-2010-07-0074
*----------------------------------------------------------------------------------
*Description:  REDO.APAP.DT.TR.APP is a deal slip routine for the DEAL.SLIP.FORMAT FX.DEAL.TICKET,
*             the routine checks if an OVERRIDE is generated, if generated then checks from the file
*             REDO.APAP.SIGNATORY.LIST if the INPUTTER is TRESURY and return the value accordingly
* In parameter  : None
* out parameter : TR.APPROVER
*----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.FOREX
$INSERT I_F.REDO.APAP.SIGNATORY.LIST

  GOSUB OPEN.PARA
  GOSUB PROCESS.PARA
  RETURN

OPEN.PARA:

  FN.REDO.APAP.SIGNATORY.LIST = 'F.REDO.APAP.SIGNATORY.LIST'
  F.REDO.APAP.SIGNATORY.LIST = ''
  CALL OPF(FN.REDO.APAP.SIGNATORY.LIST,F.REDO.APAP.SIGNATORY.LIST)

PROCESS.PARA:
  IF NOT(R.NEW(FX.OVERRIDE)) THEN
    TR.APPROVER = 'N/A'
  END
  ELSE
    GOSUB GET.TR.APPROVER
  END
  RETURN

GET.TR.APPROVER:
*Getting the Approval details
  VAR.INPUTTER = R.NEW(FX.INPUTTER)
  REDO.APAP.SIGNATORY.LIST.ID = FIELD(VAR.INPUTTER,'_',2)
  CALL F.READ(FN.REDO.APAP.SIGNATORY.LIST,REDO.APAP.SIGNATORY.LIST.ID,R.REDO.APAP.SIGNATORY.LIST,F.REDO.APAP.SIGNATORY.LIST,ERR.SIGN.LIST)
  IF NOT(R.REDO.APAP.SIGNATORY.LIST) THEN
    TR.APPROVER = 'N/A'
  END
  IF R.REDO.APAP.SIGNATORY.LIST<SIG.LIST.DEPARTMENT> EQ 'TREASURY' THEN
    TR.APPROVER = REDO.APAP.SIGNATORY.LIST.ID
  END
  ELSE
    TR.APPROVER = 'N/A'
  END
  RETURN

END
