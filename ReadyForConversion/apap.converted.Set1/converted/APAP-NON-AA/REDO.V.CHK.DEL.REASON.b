SUBROUTINE REDO.V.CHK.DEL.REASON
*********************************************************************************************************
*Company   Name    : APAP Bank
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.CHK.DEL.REASON
*--------------------------------------------------------------------------------------------------------
*Description       : This routine will nullify Movement reason field
*In  Parameter     :
*Out Parameter     :
*Files  Used       : COLLATERAL             As          I Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 04/05/2011    Kavitha            PACS00054322 B.180C          Bug Fix
*
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.COLLATERAL
*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********


    APPL.ARRAY = 'COLLATERAL'
    FLD.ARRAY  = 'L.CO.REASN.MVMT':@VM:'L.CO.DATE.MVMT'
    FLD.POS    = ''
    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)
    LOC.L.CO.MVMT  = FLD.POS<1,1>
    LOC.L.DATE.MVT = FLD.POS<1,2>


    CURR.NO = R.NEW(COLL.CURR.NO)

    IF PGM.VERSION EQ ",DOC.RECEPTION" THEN
        IF CURR.NO NE '' THEN
            R.NEW(COLL.LOCAL.REF)<1,LOC.L.CO.MVMT> = ""
            R.NEW(COLL.LOCAL.REF)<1,LOC.L.DATE.MVT> = TODAY
        END
    END

RETURN
*---------------------------------------------------------------------------------------------------------------------------
END
