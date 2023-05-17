SUBROUTINE LATAM.CARD.ORDER.OVERRIDES
*----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.ID
*--------------------------------------------------------------------------------------------------------
*Description  : This is a ID routine to
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 9 Aug 2010    Mohammed Anies K       ODR-2010-03-0400          Initial Creation
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.LATAM.CARD.ORDER



    GOSUB OVERRIDES
RETURN
*-----OVERRIDES----------------------------------------------------------
*
OVERRIDES:
*********
    IF ID.OLD NE '' THEN
        RETURN
    END

    CURR.NO=0
    CALL STORE.OVERRIDE(CURR.NO)          ;* Initialising
    CHARGE.DATE = R.NEW(CARD.IS.CHARGE.DATE)
    GOSUB PROCESS.OVERRIDES

    IF TEXT EQ 'NO' THEN
        V$ERROR=1
        MESSAGE = "ERRROR"
    END

RETURN
******************************************************
PROCESS.OVERRIDES:
***************
    CURR.NO = DCOUNT(R.NEW(CARD.IS.OVERRIDE),@VM)+1
    IF CHARGE.DATE NE '' THEN
        BEGIN CASE
            CASE CHARGE.DATE GT R.DATES(EB.DAT.FORW.VALUE.MINIMUM)
                TEXT='FWD.VAL.DATE'
                AF=CARD.IS.CHARGE.DATE
                CALL STORE.OVERRIDE(CURR.NO)
            CASE CHARGE.DATE LT R.DATES(EB.DAT.BACK.VALUE.MINIMUM)
                TEXT='BCK.VAL.DATE'
                AF=CARD.IS.CHARGE.DATE
                CALL STORE.OVERRIDE(CURR.NO)
        END CASE

        DAYTYPE=''
        CALL AWD('',CHARGE.DATE,DAYTYPE)
        IF DAYTYPE EQ 'H' THEN
            TEXT='CRG.DATE.N.WRK'
            AF=CARD.IS.CHARGE.DATE
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
RETURN
*------------------------------------------------------------
END
