*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ID.TTID.VAULT
*-----------------------------------------------------------------------------
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: V NAVA
* PROGRAM NAME: REDO.V.ID.TTID.VAULT
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used to check that current TELLER.ID record
*it's a valid Vault on current COMPANY.
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH:   TELLER.ID,MAIN.LIMIT version.
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*27.11.2012     V.NAVA        PACS00235401     INITIAL CREATION

  $INSERT I_COMMON
  $INSERT I_EQUATE
$INSERT I_F.TELLER.PARAMETER
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
  F.TELLER.PARAMETER = ''
  FN.TELLER.PARAMETER = 'F.TELLER.PARAMETER'
  CALL OPF(FN.TELLER.PARAMETER, F.TELLER.PARAMETER)
*
  Y.VAULT.ID     = COMI
  Y.FUNCT        = V$FUNCTION
*
  RETURN
*
*-------
PROCESS:
*-------
*
  R.TELLER.PARAMETER = "" ; TT.PRM.ERR = ""
  CALL CACHE.READ(FN.TELLER.PARAMETER, ID.COMPANY, R.TELLER.PARAMETER, TT.PRM.ERR)
  IF R.TELLER.PARAMETER NE "" AND Y.FUNCT EQ "I" THEN
*
    LIST.OF.VAULTS = R.TELLER.PARAMETER<TT.PAR.VAULT.ID>
    CONVERT VM TO FM IN LIST.OF.VAULTS
*
    LOCATE Y.VAULT.ID IN LIST.OF.VAULTS SETTING POS THEN
*
    END
    ELSE
      E = 'TT-ONLY.ALLOW.TO.VAULT'
    END
*
  END
*
  RETURN
*
END
