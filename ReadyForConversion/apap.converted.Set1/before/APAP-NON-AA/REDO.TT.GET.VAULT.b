*-----------------------------------------------------------------------------
* <Rating>-43</Rating>
*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------

*-----------------------------------------------------------------------------
  SUBROUTINE REDO.TT.GET.VAULT
********************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Victor Panchi
*  Program   Name    :REDO.TT.GET.VAULT
***********************************************************************************
*Description:    This is a Check Rec Rtn routine attached to the versions
*                TELLER,REDO.VAULT.TO.TILL.LCY and TELLER,REDO.VAULT.TO.TILL.FCY
*                Get Vault from the branch
*****************************************************************************
*linked with:    TELLER,REDO.VAULT.TO.TILL.LCY and TELLER,REDO.VAULT.TO.TILL.FCY
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*19-Mar-2012       Victor Panchi         PACS00186440       INITIAL CREATION
****************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.TELLER.PARAMETER

  GOSUB INITIALIZE
  GOSUB OPEN
  GOSUB PROCESS
  RETURN

*****
INITIALIZE:
*****
  Y.CO.CODE = ''
  R.TELLER.PARAMETER = ''
  Y.TT.ERROR = ''
  Y.ERROR.MSG = ''
  RETURN

*****
OPEN:
*****

  FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
  *F.TELLER.PARAMETER  = ''
  *CALL OPF(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

  RETURN

********
PROCESS:
********
* Get Company code

  Y.CO.CODE = ID.COMPANY

  CALL F.READ(FN.TELLER.PARAMETER, Y.CO.CODE, R.TELLER.PARAMETER, F.TELLER.PARAMETER, Y.TT.ERROR)
  
  IF R.TELLER.PARAMETER THEN
* Get vault count
    Y.COUNT.VAULT = DCOUNT(R.TELLER.PARAMETER<TT.PAR.VAULT.ID>, VM)

    IF Y.COUNT.VAULT GT 0 THEN
      R.NEW(TT.TE.TELLER.ID.2) = R.TELLER.PARAMETER<TT.PAR.VAULT.ID,1>
    END
    ELSE
      Y.ERROR.MSG = 'TT-NOT.EXIST.VAULT.TO.BRANCH'
      GOSUB GET.ERROR.MSG
    END
  END ELSE
    Y.ERROR.MSG = 'TT-NOT.EXIST.VAULT.TO.BRANCH'
    GOSUB GET.ERROR.MSG
  END
  RETURN

********
GET.ERROR.MSG:
********
  AF    = TT.TE.TELLER.ID.2
  ETEXT = Y.ERROR.MSG
  CALL STORE.END.ERROR

  RETURN
********************************************************
END
*----------------End of Program-----------------------------------------------------------
