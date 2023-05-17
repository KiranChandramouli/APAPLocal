*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VBA.ACCT.RBHP.GEN
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : Marimuthu S (TAM)
* Program Name  : REDO.VBA.ACCT.RBHP.GEN
*-------------------------------------------------------------------------
* Description: This routine is a After auth routine for the Version ACCOUNT,RBHP
*-------------------------------------------------------------------------
* Linked with   : VERSION>ACCOUNT,RBHP
* In parameter  :
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*------------------------------------------------------------------------
*   DATE              ODR / HD REF                  DESCRIPTION
* 13-02-13
*------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.SPF
$INSERT I_System

$INSERT I_F.REDO.ACCT.EXCE.RBHP

  IF R.SPF.SYSTEM<SPF.OP.MODE> NE 'B' THEN
    GOSUB OPEN.PROCESS
    GOSUB PROCESS
  END

  RETURN

*------------
OPEN.PROCESS:
*------------

  FN.REDO.ACCT.EXCE.RBHP='F.REDO.ACCT.EXCE.RBHP'
  F.REDO.ACCT.EXCE.RBHP=''
  CALL OPF(FN.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP)

  RETURN

*-------
PROCESS:
*-------

  CURRNT.COMP = System.getVariable("CURRENT.USER.BRANCH")

  IF CURRNT.COMP EQ "CURRENT.USER.BRANCH" THEN
    LOCATE 'EB-UNKNOWN.VARIABLE' IN E<1,1> SETTING POS THEN
      E = ''
    END
    RETURN
  END

  Y.ID = APPLICATION:'-':CURRNT.COMP:'-':ID.NEW

  ERR.EXCE = ''
  R.REDO.ACCT.EXCE.RBHP = ''

  CALL F.READ(FN.REDO.ACCT.EXCE.RBHP,Y.ID,R.REDO.ACCT.EXCE.RBHP,F.REDO.ACCT.EXCE.RBHP,ERR.EXCE)
  IF R.REDO.ACCT.EXCE.RBHP THEN
    CALL F.DELETE(FN.REDO.ACCT.EXCE.RBHP,Y.ID)
  END

  RETURN

END
