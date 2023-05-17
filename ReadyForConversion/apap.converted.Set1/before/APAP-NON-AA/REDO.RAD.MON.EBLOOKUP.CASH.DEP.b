*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.RAD.MON.EBLOOKUP.CASH.DEP

*-----------------------------------------------------------------------------
* Primary Purpose: Returns identification and identification type of a customer given as parameter
*                  Used in RAD.CONDUIT.LINEAR as API routine.
* Input Parameters: CUSTOMER.CODE
* Output Parameters: Identification @ Identification type
*-----------------------------------------------------------------------------
* Modification History:
*
* 18/09/10 - Cesar Yepez
*            New Development
*
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.CUSTOMER
$INSERT I_TSS.COMMON
$INSERT I_F.EB.LOOKUP

  GOSUB OPEN.FILES

  GOSUB PROCESS

  RETURN
*-----------------------------------------------------------------------------------
PROCESS:

  Y.LOOKUP.ID = 'L.AC.CASH.DEP':'*':COMI
  CALL F.READ(FN.EB.LOOKUP,Y.LOOKUP.ID,R.EB.LOOKUP,F.EB.LOOKUP,EB.LOOKUP.ERR)
  IF NOT(EB.LOOKUP.ERR) THEN
    COMI = R.EB.LOOKUP<EB.LU.DESCRIPTION,1>
  END

  RETURN
*-----------------------------------------------------------------------------------
OPEN.FILES:

  FN.EB.LOOKUP = 'F.EB.LOOKUP'
  F.EB.LOOKUP = ''
  CALL OPF(FN.EB.LOOKUP,F.EB.LOOKUP)

  RETURN

*-----------------------------------------------------------------------------------
END
