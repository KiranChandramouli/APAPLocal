SUBROUTINE REDO.V.ANC.DEFAULTSTK

*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.V.ANC.DEFAULTSTK
*--------------------------------------------------------------------------------------------------------
*Description  : This is to default values in stock entry
*Linked With  : Application REDO.CARD.STOCK.ENTRY,REDO.MV
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 21 May 2011    BALAGURUNATHAN       PACS00056634        Initial Creation


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.DMG.EMBOSS
    $INSERT I_System
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.STOCK.ENTRY
    $INSERT I_REDO.CRD.DMG.LST.COMMON

    FN.REDO.CARD.SERIES.PARAM='F.REDO.CARD.SERIES.PARAM'

    CALL CACHE.READ(FN.REDO.CARD.SERIES.PARAM,'SYSTEM',R.REDO.CARD.SERIES.PARAM,ERR.PARAM)
    VIRGIN.DPT= R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.VIRGIN.DEPT.CODE>
    EMBOSS.DPT= R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.EMBOSS.DEPT.CODE>

    STK.DETAILS= System.getVariable('CURRENT.GETSTK')
    IF E EQ "EB-UNKNOWN.VARIABLE" THEN
        STK.DETAILS = ""
    END
    STK.DETAILS= CHANGE (STK.DETAILS,'@',@FM)

    R.NEW(STK.FROM.REGISTER)='CARD.':ID.COMPANY:'-':VIRGIN.DPT
    R.NEW(STK.TO.REGISTER)=  STK.DETAILS<2>
    R.NEW(STK.STOCK.SERIES)=STK.DETAILS<3>
    CARD.SER=STK.DETAILS<6>
    SER.CNT=DCOUNT(STK.DETAILS<3>,@VM)

    FOR SER.LOOP=1 TO SER.CNT
        R.NEW(STK.STOCK.QUANTITY)<1,SER.LOOP>=STK.DETAILS<4,SER.LOOP>+STK.DETAILS<5,SER.LOOP>
    NEXT

    R.NEW(STK.NOTES)='REPLACEMENT STOCK'
    R.NEW(STK.BATCH.NO)=STK.DETAILS<1>

RETURN
END
