SUBROUTINE REDO.APAP.V.VAL.PROV.PERCENTAGE
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.APAP.V.VAL.PROV.PERCENTAGE
*--------------------------------------------------------------------------------------------------------
*Description       : REDO.APAP.V.VAL.PROV.PERCENTAGE is an Input routine attached to the VERSION
*                    - EB.RATING,B23B, the routine checks if the value entered in the local field
*                     L.EB.PROV.PERC is less than 100 or not
*Linked With       : Version - EB.RATING,B23B
*In  Parameter     : NA
*Out Parameter     : NA
*Files  Used       : EB.RATING            As              I               Mode
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date               Who                  Reference                  Description
*   ------            ------               -------------               -------------
* 23 Sep 2010        Mudassir V         ODR-2010-09-0167 B.23B        Initial Creation
*********************************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.EB.RATING
*-------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA

RETURN
*--------------------------------------------------------------------------------------------------------
*************
PROCESS.PARA:
************
    GOSUB FIND.MULTI.LOCAL.REF

    IF NOT(R.NEW(EB.RAT.LOCAL.REF)<1,LOC.L.EB.PROV.PERC.POS>) THEN
        RETURN
    END

    IF R.NEW(EB.RAT.LOCAL.REF)<1,LOC.L.EB.PROV.PERC.POS> GT 100 THEN
        AF     = EB.RAT.LOCAL.REF
        AV     = LOC.L.EB.PROV.PERC.POS
        ETEXT = 'EB-PERC.LT.100'
        CALL STORE.END.ERROR
    END

RETURN
*--------------------------------------------------------------------------------------------------------
*********************
FIND.MULTI.LOCAL.REF:
*********************
    APPL.ARRAY = 'EB.RATING'
    FLD.ARRAY = 'L.EB.PROV.PERC'
    FLD.POS = ''

    CALL MULTI.GET.LOC.REF(APPL.ARRAY,FLD.ARRAY,FLD.POS)

    LOC.L.EB.PROV.PERC.POS =  FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------
END
