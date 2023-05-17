*-----------------------------------------------------------------------------
* <Rating>-33</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ID.TTID.OPEN
*-----------------------------------------------------------------------------
*
*******************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: V NAVA
* PROGRAM NAME: REDO.V.ID.TTID.OPEN
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used to check that current TELLER.ID record
*it's already OPEN, sends and error.
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:   TELLER.ID,OPEN and TELLER.ID,AUTH versions.
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*20.10.2012     V.NAVA        PACS00230506     INITIAL CREATION

  $INSERT I_COMMON
  $INSERT I_EQUATE
$INSERT I_F.TELLER.ID
*-----------------------------------------------------------------------
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
  Y.FUNCT        = V$FUNCTION
  TO.VAULT.ID    = COMI
  Y.TTID.ST      = ""
*
  RETURN
*
*-------
PROCESS:
*-------
*
  R.TELLER.ID = "" ; TT.ID.ERR = ""
  CALL F.READ(FN.TELLER.ID, TO.VAULT.ID, R.TELLER.ID, F.TELLER.ID, TT.ID.ERR)
  IF R.TELLER.ID NE "" THEN
    GOSUB GET.TTID.STATUS     ;* Get current status of cashier.
  END
*
  RETURN
*
*** <region name= GET.TTID.STATUS>
GET.TTID.STATUS:
*** <desc>Get current status of cashier.</desc>
  Y.TTID.ST = R.TELLER.ID<TT.TID.STATUS>
  IF Y.TTID.ST EQ "OPEN" AND Y.FUNCT EQ "I" THEN
    E = 'EB-ONLY.CLOSE'
  END
*
  RETURN
*** </region>
END
