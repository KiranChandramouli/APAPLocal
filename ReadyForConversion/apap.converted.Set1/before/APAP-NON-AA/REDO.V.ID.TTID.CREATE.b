*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ID.TTID.CREATE
*-----------------------------------------------------------------------------
*
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: V NAVA
* PROGRAM NAME: REDO.V.ID.TTID.CREATE
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used to check that current TELLER.ID record
*it's already CREATED, sends and error.
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:   TELLER.ID,CREATE version.
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*20.10.2012     V.NAVA        PACS00230506     INITIAL CREATION

  $INSERT I_COMMON
  $INSERT I_EQUATE
*-----------------------------------------------------------------------------
*
  GOSUB INITIALISE
  GOSUB PROCESS
*
  RETURN
*
*----------
INITIALISE:
*----------
*
  F.TELLER.ID = ''
  FN.TELLER.ID = 'F.TELLER.ID'
  CALL OPF(FN.TELLER.ID, F.TELLER.ID)
*
  TO.VAULT.ID    = COMI
  Y.FUNCT        = V$FUNCTION
*
  RETURN
*
*-------
PROCESS:
*-------
*
  R.TELLER.ID = "" ; TT.ID.ERR = ""
  CALL F.READ(FN.TELLER.ID, TO.VAULT.ID, R.TELLER.ID, F.TELLER.ID, TT.ID.ERR)
  IF R.TELLER.ID NE "" AND Y.FUNCT EQ "I" THEN
    E = 'EB-ONLY.NOT.CREATED'
  END
*
  RETURN
*
*** </region>
END
