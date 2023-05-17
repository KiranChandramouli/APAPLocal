*-----------------------------------------------------------------------------
* <Rating>-31</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.UTIL.AMT
*--------------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :SRIRAMAN.C
*Program   Name    :REDO.VAL.UTIL.AMT
*---------------------------------------------------------------------------------

*DESCRIPTION       :This routine is No file routine
*
*LINKED WITH       :
* ----------------------------------------------------------------------------------
* ----------------------------------------------------------------------------------
* DATE                  WHO        REF                 DESC
* 14-05-2011            PRABHU     ACCOUNT VI-CR013    Error Logic removed
*------------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_ENQUIRY.COMMON

  GOSUB INIT
  GOSUB PROCESS

  RETURN

INIT:
  FN.ACCOUNT = 'F.ACCOUNT'
  F.ACCOUNT = ''
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  RETURN

*******
PROCESS:
********

  ACCOUNT.ID = ID.NEW

  APL.ARRAY ='ACCOUNT'
  APL.FLD = 'L.AC.TRANS.LIM'
  FLD.POS = ''
  CALL MULTI.GET.LOC.REF(APL.ARRAY,APL.FLD,FLD.POS)

  LOC.L.AC.TRANS.LIM.POS = FLD.POS<1,1>

  Y.TRANS.LIM = R.NEW(AC.LOCAL.REF)<1,LOC.L.AC.TRANS.LIM.POS>

  IF Y.TRANS.LIM GT 0 THEN
    GOSUB TRANS.INT
  END
  ELSE
    COMI='Y'
  END

  RETURN

*********
TRANS.INT:
**********

  COMI = 'N'

  RETURN
********************************
END

*END OF PROGRAM
**********************************************
