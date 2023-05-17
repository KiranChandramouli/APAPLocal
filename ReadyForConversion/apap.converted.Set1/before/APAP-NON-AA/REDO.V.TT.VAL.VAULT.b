*-----------------------------------------------------------------------------
* <Rating>-45</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.TT.VAL.VAULT
********************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Victor Panchi
*  Program   Name    :REDO.V.TT.VAL.VAULT
***********************************************************************************
*Description:    This is an VALIDATION routine attached to the versions
*                TELLER,REDO.TILL.TO.VAULT and TELLER,REDO.TILL.TO.VAULT.FCY
*                Not allow transfer to another vault that correspnds to company
*****************************************************************************
*linked with:  TELLER,REDO.TILL.TO.VAULT and TELLER,REDO.TILL.TO.VAULT.FCY
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*16-Mar-2012       Victor Panchi         PACS00186440       INITIAL CREATION
****************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TELLER
$INSERT I_F.TELLER.PARAMETER

  IF MESSAGE NE "VAL" THEN
    GOSUB INITIALIZE
    GOSUB OPEN
    GOSUB PROCESS
  END
*
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
  F.TELLER.PARAMETER  = ''
  CALL OPF(FN.TELLER.PARAMETER,F.TELLER.PARAMETER)

  RETURN

********
PROCESS:
********
* Get Company code
  Y.CO.CODE = ID.COMPANY

  CALL F.READ(FN.TELLER.PARAMETER, Y.CO.CODE, R.TELLER.PARAMETER, F.TELLER.PARAMETER,Y.TT.ERROR)

  IF R.TELLER.PARAMETER THEN
* Get vault
*        Y.TELLER.ID.1 = R.NEW(TT.TE.TELLER.ID.1)
    Y.TELLER.ID.1 = COMI
    LOCATE Y.TELLER.ID.1 IN R.TELLER.PARAMETER<TT.PAR.VAULT.ID,1> SETTING VAULT.POS ELSE
      Y.ERROR.MSG = 'TT-ONLY.ALLOW.TO.VAULT'
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
*    AF    = TT.TE.TELLER.ID.1
  ETEXT = Y.ERROR.MSG
  CALL STORE.END.ERROR

  RETURN
********************************************************
END
*----------------End of Program-----------------------------------------------------------
