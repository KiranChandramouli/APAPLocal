* @ValidationCode : MjoyMDUwMjA5MjQ2OkNwMTI1MjoxNzAxMDkwMDMxOTAzOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 27 Nov 2023 18:30:31
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL


SUBROUTINE LATAM.CARD.ORDER.RECORD
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.RECORD
*--------------------------------------------------------------------------------------------------------
*Description  : This is a record routine for LATAM.CARD.ORDER
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 6 Aug 2010    Mohammed Anies K     ODR-2010-03-0400          Initial Creation
* 13-MAY-11       KAVITHA            ODR-2010-08-0467          PACS00055017  FIX
* 13 JUL 2011     KAVITHA            PACS00082440             *PACS00082440 FIX
* 4 AUG 2011      KAVITHA            PACS00094453              PACS00094453 FIX
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*27-11-2023	        VIGNESHWARI       ADDED COMMENT FOR INTERFACE CHANGES     Embozado  � By Santiago
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.CARD.NUMBERS
    $INSERT I_LATAM.CARD.COMMON
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CURRENCY
    $INSERT I_GTS.COMMON
    $USING APAP.TAM

*--------------------------------------------------------------------------------------------------------
**********
*MAIN.PARA:	;*Fix Embozado � By Santiago-Commented
**********
    CCY.ENRICHMENT = ''

    FN.REDO.CARD.NUMBERS = 'F.REDO.CARD.NUMBERS'
    F.REDO.CARD.NUMBERS = ''
    CALL OPF(FN.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS)

*PACS00082440 -S
    FN.REDO.CARD.REQUEST = 'F.REDO.CARD.REQUEST'
    F.REDO.CARD.REQUEST = ''
    CALL OPF(FN.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST)
    Y.PRIMARY.CARD  = ''

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CCY = 'F.CURRENCY'
    F.CCY = ''
    CALL OPF(FN.CCY,F.CCY)

*PACS00082440 -E

    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************



    IF NOT(Y.PROCESS) AND Y.NEW.CARD THEN
*APAP.TAM.REDO.DEFAULT.CHANNEL.ACCESS    ;* added to default channel exclusion
        APAP.TAM.redoDefaultChannelAccess() ;*MANUAL R22 CODE CONVERSION 
        Y.PROCESS=1
        Y.NEW.CARD=0
    END

    IF R.OLD(CARD.IS.REPAY.DATE) THEN
        T(CARD.IS.NEW.REPAY.DATE)<3> = ''
        T(CARD.IS.REPAY.DATE)<3> ='NOINPUT'
        T(CARD.IS.BILLING.CLOSE)<3> ='NOINPUT'
        T(CARD.IS.NEW.BILLING.CLOSE)<3> = ''
    END ELSE
        T(CARD.IS.REPAY.DATE)<3> = ''
        T(CARD.IS.NEW.REPAY.DATE)<3> = 'NOINPUT'
        T(CARD.IS.BILLING.CLOSE)<3> = ''
        T(CARD.IS.NEW.BILLING.CLOSE)<3> = 'NOINPUT'
    END
    IF R.OLD(CARD.IS.STOCK.REG.ID) THEN
        T(CARD.IS.STOCK.REG.ID)<3> = 'NOINPUT'
        T(CARD.IS.STOCK.SERIERS.ID)<3> = 'NOINPUT'
    END ELSE
        T(CARD.IS.STOCK.REG.ID)<3> = ''
        T(CARD.IS.STOCK.SERIERS.ID)<3> = ''
    END

    CARD.TYPE = ''
    CARD.TYPE = FIELD(ID.NEW,".",1)

    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    Y.RECEIVE.DEPT.CODE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.RECEIVE.DEPT.CODE>

    IF R.NEW(CARD.IS.STOCK.REG.ID) EQ '' THEN
        R.NEW(CARD.IS.STOCK.REG.ID) = "CARD.":ID.COMPANY:'-':Y.RECEIVE.DEPT.CODE
    END

    Y.PARAM.CARD.TYPE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>
    LOCATE CARD.TYPE IN Y.PARAM.CARD.TYPE<1,1> SETTING Y.CARD.POS THEN
        PAR.CARD.SERIES = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.SERIES,Y.CARD.POS>
        COMPANY.CNTR = LEN(ID.COMPANY)

        R.NEW(CARD.IS.STOCK.SERIERS.ID) = PAR.CARD.SERIES
    END


    Y.LOCK.ID = FIELD(ID.NEW,'.',2,1)
    Y.CARD.TYPE = FIELD(ID.NEW,'.',1)
*****Added to default EXPIRY.DATE & TYPE.OF.CARD
    Y.CARD.NO.AND.LOCK.ID = Y.CARD.TYPE:'.':ID.COMPANY

    CALL F.READ(FN.REDO.CARD.NUMBERS,Y.CARD.NO.AND.LOCK.ID,R.REDO.CARD.NUMBERS,F.REDO.CARD.NUMBERS,REDO.CARD.NUMBERS.ERR)
    Y.CARD.NUM.LIST = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CARD.NUMBER>
    LOCATE Y.LOCK.ID IN Y.CARD.NUM.LIST<1,1> SETTING Y.AVAILABLE.CARD.POS THEN

        EMB.TYPE=  R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EMBOSS.TYPE,Y.AVAILABLE.CARD.POS>
*PACS00055017  -S
        R.NEW(CARD.IS.EMBOSS.TYPE) = EMB.TYPE

* PACS00055017  -E

        IF R.NEW(CARD.IS.CARD.STATUS) EQ 90 THEN
            R.NEW(CARD.IS.EXPIRY.DATE) =   R.REDO.CARD.NUMBERS<REDO.CARD.NUM.EXPIRY.DATE,Y.AVAILABLE.CARD.POS>
        END

*PACS00082440 -S

        IF EMB.TYPE EQ 'PERSONALIZADA' THEN
            GOSUB DEFAULT.REQ.VALUES
        END
**PACS00082440-E

    END

RETURN
*--------------------------------------------------------------------------------------------------------
DEFAULT.REQ.VALUES:


    REQUEST.ID = R.REDO.CARD.NUMBERS<REDO.CARD.NUM.CRD.REQ.ID,Y.AVAILABLE.CARD.POS>

    CALL F.READ(FN.REDO.CARD.REQUEST,REQUEST.ID,R.REDO.CARD.REQUEST,F.REDO.CARD.REQUEST,REQ.ERR)
    IF R.REDO.CARD.REQUEST THEN

        Y.ACCOUNT = R.REDO.CARD.REQUEST<REDO.CARD.REQ.ACCOUNT.NO,1,1>
        R.NEW(CARD.IS.ACCOUNT) = Y.ACCOUNT
        CALL F.READ(FN.ACCOUNT,Y.ACCOUNT,R.ACCOUNT,F.ACCOUNT,Y.ACC.ERR)
        Y.CURRENCY = R.ACCOUNT<AC.CURRENCY>
        CALL CACHE.READ(FN.CCY, Y.CURRENCY, R.CCY, CCY.ERR) ;*AUTO R22 CODE CONVERSION
        CCY.ENRICHMENT = R.CCY<EB.CUR.CCY.NAME>

        R.NEW(CARD.IS.CURRENCY) = Y.CURRENCY

        IF OFS$BROWSER THEN
            OFS$ENRI<CARD.IS.CURRENCY> = CCY.ENRICHMENT
        END

        Y.PRIMARY.CARD = R.REDO.CARD.REQUEST<REDO.CARD.REQ.PRIMARY.CARD,1,1>
        Y.CARD.NUMBERS.LIST = ID.NEW:@VM:Y.PRIMARY.CARD
        R.NEW(CARD.IS.CARD.NUMBER) = Y.CARD.NUMBERS.LIST

        R.NEW(CARD.IS.TYPE.OF.CARD) = R.REDO.CARD.REQUEST<REDO.CARD.REQ.TYPE.OF.CARD,1>
        R.NEW(CARD.IS.CARD.TYPE) = FIELD(ID.NEW,'.',1)


*PACS00094453 -S
        IF R.REDO.CARD.REQUEST<REDO.CARD.REQ.TYPE.OF.CARD,1> EQ "PRINCIPAL" THEN
            R.NEW(CARD.IS.CUSTOMER.NO)<1,1> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NO,1,1>
            R.NEW(CARD.IS.NAME.ON.PLASTIC)<1,1> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NAME,1,1>
        END ELSE
            R.NEW(CARD.IS.CUSTOMER.NO)<1,1> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.PROSPECT.ID,1,1>
            R.NEW(CARD.IS.NAME.ON.PLASTIC)<1,1> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NAME,1,1>

            R.NEW(CARD.IS.CUSTOMER.NO)<1,2> = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NO,1,1>
        END
*PACS00094453-E

        R.NEW(CARD.IS.NAME) = R.REDO.CARD.REQUEST<REDO.CARD.REQ.CUSTOMER.NAME,1,1>

        R.NEW(CARD.IS.PROSPECT.ID) = R.REDO.CARD.REQUEST<REDO.CARD.REQ.PROSPECT.ID>

    END

RETURN
*--------------------------------------------------------------------------------------------------------
END
