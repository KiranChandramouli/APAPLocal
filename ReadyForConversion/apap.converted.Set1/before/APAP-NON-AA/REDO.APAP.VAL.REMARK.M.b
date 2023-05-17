*-----------------------------------------------------------------------------
* <Rating>-40</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.APAP.VAL.REMARK.M
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.VAL.REMARK.M
*--------------------------------------------------------------------------------------------------------
*Description       : This routine ia a validation routine. It is used to check if the REASON FOR MOVEMENT
*                    is 'OTHERS', make REMARK as mandatory
*Linked With       : COLLATERAL,DOC.MOVEMENT
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 27/05/2010        REKHA S         ODR-2009-10-0310 B.180C      Initial Creation
*
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

  IF R.NEW(COLL.LOCAL.REF)<1,Y.LOC.REASN.MVMT.POS> EQ 'OTHER' AND COMI EQ '' THEN
    ETEXT = 'CO-MANDATORY.REMARK'
    CALL STORE.END.ERROR
  END

  RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
  APPL.ARRAY = 'COLLATERAL'
  FLD.ARRAY  = 'L.CO.REASN.MVMT':VM:'L.CO.REMARK'
  FLD.POS    = ''
  CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
  Y.LOC.REASN.MVMT.POS    = FLD.POS<1,1>
  Y.LOC.REM.POS         = FLD.POS<1,2>

  RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
