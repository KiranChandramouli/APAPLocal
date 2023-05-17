*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FC.GEN.POL.ID(P.ID)
*-----------------------------------------------------------------------------
* Developer    : mgudino@temenos.com
* Date         : 2011-06-13
* Description  : This routine its on charge TO ASSING THE CORRECT POLICY TO THE CORRECT COLLATERAL
*                BASED ON RULES PARAMETRISED IN REDO.FC.PROD.COLL.POLICY
*
*-----------------------------------------------------------------------------
* Input/Output:
* -------------
* In  :  P.ID
* Out :
*-----------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE

  GOSUB PROCESS

  RETURN
*===========
PROCESS:
*===========
  UNIQUE.TIME = ''
  CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
  YSYSDATE = OCONV(DATE(),"D-")
  YSYSDATE = YSYSDATE[7,4]:YSYSDATE[1,2]:YSYSDATE[4,2]
  IDPOL ="POL":YSYSDATE:UNIQUE.TIME
  CHANGE "." TO "0" IN IDPOL
  P.ID = IDPOL

  RETURN


END
