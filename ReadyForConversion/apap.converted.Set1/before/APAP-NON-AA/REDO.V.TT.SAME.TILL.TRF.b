*-----------------------------------------------------------------------------
* <Rating>-22</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.TT.SAME.TILL.TRF
********************************************************************************
******************************************************************************
*  Company   Name    :Asociacion Popular de Ahorros y Prestamos
*  Developed By      :Victor Panchi
*  Program   Name    :REDO.V.TT.SAME.TILL.TRF
***********************************************************************************
*Description:    This is an VALIDATION routine attached to the  version
*                TELLER,REDO.LCY.FCY.TILLTFR. Not allow transfer to the same till
*****************************************************************************
*linked with:
*In parameter:
*Out parameter:
**********************************************************************
* Modification History :
***********************************************************************
*DATE              WHO                   REFERENCE         DESCRIPTION
*01-Mar-2012       Victor Panchi         Mantis GR8        INITIAL CREATION
*18-Mar-2012                             Joaquin GR8       Added validation to allow
*                                                          TO TILLS from the same Branch
*                                                          as input teller
*
****************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE

$INSERT I_F.TELLER
$INSERT I_F.TELLER.ID
*** Modify by CODE REVIEW
  GOSUB OPEN.FILES
***

  GOSUB PROCESS

  RETURN

*****
OPEN.FILES:
*****

  FN.TELLER.ID = 'F.TELLER.ID'
  F.TELLER.ID  = ''
  CALL OPF(FN.TELLER.ID, F.TELLER.ID)

  RETURN

********
PROCESS:
********

  IF AF EQ TT.TE.TELLER.ID.1 THEN
    Y.TELLER.ID.1 = COMI
  END ELSE
    Y.TELLER.ID.1 = R.NEW(TT.TE.TELLER.ID.1)
  END

  Y.TELLER.ID.2 = R.NEW(TT.TE.TELLER.ID.2)

  IF Y.TELLER.ID.1 EQ Y.TELLER.ID.2 THEN
    AF    = TT.TE.TELLER.ID.1
    ETEXT = 'TT-TRF.NOT.ALLOWED.SAME.TILL'
    CALL STORE.END.ERROR
  END ELSE
    CALL F.READ(FN.TELLER.ID, Y.TELLER.ID.1, R.TELLER.ID, F.TELLER.ID, TTID.ERR)
    IF R.TELLER.ID<TT.TID.USER> EQ "" AND R.TELLER.ID THEN
      AF = TT.TE.TELLER.ID.1
      ETEXT = 'TT-TILL.NOT.DEFINED'
      CALL STORE.END.ERROR
    END
    IF R.TELLER.ID<TT.TID.CO.CODE> NE ID.COMPANY AND R.TELLER.ID THEN
      AF    = TT.TE.TELLER.ID.1
      ETEXT = 'TT-TILL.NOT.BELONGS.THE.BRANCH'
      CALL STORE.END.ERROR
    END
  END

  RETURN
********************************************************
END
*----------------End of Program-----------------------------------------------------------
