*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.VAL.LOC.STATUS
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.LOC.STATUS
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the Movement Type is
*                    "RECEIVED BY VAULT", if YES then assign the value "In Valut" to the field L.CO.LOC.STATUS
*Linked With       : COLLATERAL,DOC.RECEPTION
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 20/05/2010    Shiva Prasad Y     ODR-2009-10-0310 B.180C      Initial Creation
* 04/05/2011    Kavitha            PACS00054322 B.180C          Bug Fix
*********************************************************************************************************
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.COLLATERAL
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
  GOSUB PROCESS.PARA

  RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
  GOSUB FIND.MULTI.LOCAL.REF
  Y.LOC.STATUS=R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.LOC.STATUS,AS>
*PACS00054322-S
  IF R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.MVMT.TYPE,AS> EQ "VAULT" THEN
    COMI = 'VAULT'
  END
*PACS00054322-E

  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
  APPL.ARRAY = 'COLLATERAL'
  FLD.ARRAY  = 'L.CO.MVMT.TYPE':VM:'L.CO.LOC.STATUS'
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  LOC.L.CO.MVMT.TYPE        = FLD.POS<1,1>
  LOC.L.CO.LOC.STATUS       = FLD.POS<1,2>

  RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
