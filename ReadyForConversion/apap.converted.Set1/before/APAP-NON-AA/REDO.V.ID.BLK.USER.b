*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.ID.BLK.USER
*-----------------------------------------------------------------------------
*COMPANY NAME: Group Financiero Banorte
*-------------
*DEVELOPED BY: Temenos Application Management
*-------------
*SUBROUTINE TYPE: ID routine
*------------
*DESCRIPTION:
*------------
* This is the ID routine for the version of the application REDO.APAP.USER.LIMITS
* The routine is used to block the unauthorised users amending the records or making
* transaction
*---------------------------------------------------------------------------
* Input / Output
*----------------
*
* Input / Output
* IN     : -na-
* OUT    : -na-
*
*---------------------------------------------------------------------------
* Revision History
* Date           Who                Reference              Description
* 09-NOV-2010   A.SabariKumar     ODR-2010-07-0075       Initial Creation
*---------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.APAP.USER.LIMITS
$INSERT I_F.REDO.APAP.AUTH.TABLE

  Y.FUNCTION = ''
  Y.FUNCTION = V$FUNCTION
  IF Y.FUNCTION EQ 'I' OR Y.FUNCTION EQ 'A' OR Y.FUNCTION EQ 'D' OR Y.FUNCTION EQ 'R' OR Y.FUNCTION EQ 'S' THEN
    GOSUB INITIALISE
    GOSUB PROCESS
  END
  RETURN

*---------------------------------------------------------------------------
INITIALISE:
*------------
*Initialise/Open necessary varibles/files

  Y.INPUTTER = ''
  FN.REDO.APAP.AUTH.TABLE = 'F.REDO.APAP.AUTH.TABLE'
  F.REDO.APAP.AUTH.TABLE = ''
  CALL OPF(FN.REDO.APAP.AUTH.TABLE,F.REDO.APAP.AUTH.TABLE)

  FN.REDO.APAP.USER.LIMITS = 'F.REDO.APAP.USER.LIMITS'
  F.REDO.APAP.USER.LIMITS = ''
  CALL OPF(FN.REDO.APAP.USER.LIMITS,F.REDO.APAP.USER.LIMITS)
  RETURN

*---------------------------------------------------------------------------
PROCESS:
*------------
* The section checks the user(OPERATOR) making transaction against the local template
* REDO.APAP.AUTH.TABLE. If not located blocks the user to access

  Y.INPUTTER = OPERATOR
  CALL CACHE.READ('F.REDO.APAP.AUTH.TABLE','SYSTEM',R.AUTH.TABLE,AUTH.ERR)
  Y.AUTH.USER = R.AUTH.TABLE<REDO.AUTH.USR.USER.NAME>
  CHANGE VM TO FM IN Y.AUTH.USER
  LOCATE Y.INPUTTER IN Y.AUTH.USER SETTING USER.POS ELSE
    E="EB-NOT.AUTH.USER"
  END
  RETURN

*---------------------------------------------------------------------------
END
