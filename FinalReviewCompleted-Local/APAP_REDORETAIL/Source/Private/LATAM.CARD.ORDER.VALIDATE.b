* @ValidationCode : Mjo4NjUxNDQ4NTM6Q3AxMjUyOjE2ODI1OTgwMTEwNTg6c2FtYXI6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 27 Apr 2023 17:50:11
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.ORDER.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.VALIDATE
*--------------------------------------------------------------------------------------------------------
*Description  : This is a VALIDATION routine for LATAM.CARD.ORDER
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 6 Aug 2010    Mohammed Anies K       ODR-2010-03-0400          Initial Creation
* 18-may-2011   Prabhu N               PACS00061649              line 340 Modified to support Changes from various status to ACTIVE(94)
* 18-may-2011   Prabhu N               PACS00062260              Line added to update cancellation date in case status is modified to 93
* 20-may-2011   KAVITHA                PACS00024249              STOCK.REGISTER logic removed as we have designed new template without card numbers , just qty alone
* 16 JUN 2011   KAVITHA                PACS00072694              ADDED PROSPECT DETAILS
* 8 AUG 2011    KAVITHA                PACS00093181              FIX FOR  PACS00093181
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*10-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION                 = TO EQ
*10-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*--------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CARD.CHARGE
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.LOCKING
    $INSERT I_F.DATES
    $INSERT I_F.PAYMENT.STOP.TYPE

    $INSERT I_F.CARD.STATUS
    $INSERT I_F.COMPANY
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.CARD.REPAYMENT.DATE
    $INSERT I_F.CARD.BILL.CLOSE.DATE
    $INSERT I_F.STOCK.REGISTER
    $INSERT I_F.STOCK.PARAMETER
    $INSERT I_F.MNEMONIC.COMPANY
    $INSERT I_F.MNEMONIC.DAO
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.LOCAL.TABLE
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_GTS.COMMON
*    -------End of core---------------------
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.LATAM.CARD.CLASS.CODE
    $INSERT I_F.REDO.CARD.SERIES.PARAM
    $INSERT I_F.REDO.APAP.H.PARAMETER
    $INSERT I_F.CUSTOMER

*--------------------------------------------------------------------------------------------------------
**********
MAIN.PARA:
**********

    GOSUB INIT.PARA
    GOSUB PROCESS.PARA

* CHANGES FOR HD1101263
    IF R.NEW(CARD.IS.ACCOUNT) NE '' OR AF EQ CARD.IS.ACCOUNT THEN

        GOSUB ACCOUNT.VAL

    END
* CHANGES END  HD1101263

*CALL APAP.REDORETAIL.LATAM.CARD.ORDER.SPLIT.VALIDATE.3
    CALL APAP.REDORETAIL.latamCardOrderSplitValidate3();*MANUAL R22 CODE CONVERSION


    CARD.TYPE.SER = FIELD(ID.NEW,".",1)
    CALL CACHE.READ('F.REDO.CARD.SERIES.PARAM','SYSTEM',R.REDO.CARD.SERIES.PARAM,PARAM.ERR)
    Y.PARAM.CARD.TYPE = R.REDO.CARD.SERIES.PARAM<REDO.CARD.SERIES.PARAM.CARD.TYPE>
    LOCATE CARD.TYPE.SER IN Y.PARAM.CARD.TYPE<1,1> SETTING Y.CARD.POS ELSE
        AF = CARD.IS.STOCK.SERIERS.ID
        ETEXT = "EB-SERIES.PARAM"
        CALL STORE.END.ERROR
    END

*PACS00063138-S

    IF R.NEW(CARD.IS.ISSUE.NUMBER) NE '' THEN

        IF R.NEW(CARD.IS.CARD.STATUS) EQ 52 AND R.NEW(CARD.IS.ISSUE.NUMBER) NE "DIFFERENT" THEN

            AF = CARD.IS.ISSUE.NUMBER
            ETEXT = "EB-LOST.CHECK"
            CALL STORE.END.ERROR

        END
    END

*PACS00063138-E


    FETCH.CRD.STAT = R.NEW(CARD.IS.CARD.STATUS)
    IF R.NEW(CARD.IS.APPLY.PERIOD.CHG) NE R.OLD(CARD.IS.APPLY.PERIOD.CHG) THEN
        IF (FETCH.CRD.STAT EQ 35) OR (FETCH.CRD.STAT EQ 51) OR (FETCH.CRD.STAT EQ 52) OR (FETCH.CRD.STAT EQ 60) OR (FETCH.CRD.STAT EQ 91) OR (FETCH.CRD.STAT EQ 92) OR (FETCH.CRD.STAT EQ 93) OR (FETCH.CRD.STAT EQ 95) OR (FETCH.CRD.STAT EQ 96) OR (FETCH.CRD.STAT EQ 97) THEN

            AF = CARD.IS.APPLY.PERIOD.CHG
            ETEXT = "EB-APPLY.CHG.CHECK"
            CALL STORE.END.ERROR

        END
    END
    Y.CHANGE.FLD.LIST=OFS$CHANGED.FIELDS
    Y.CHANGE.FLD.LIST=FIELDS(Y.CHANGE.FLD.LIST,':',2,1)
    LOCATE 'CARD.STATUS' IN Y.CHANGE.FLD.LIST SETTING Y.CARD.ST.CH.POS THEN
        IF R.NEW(CARD.IS.CARD.STATUS) EQ 90 THEN
            AF = CARD.IS.CARD.STATUS
            ETEXT = "ST-RTN.NOT.VALID.STATUS"
            CALL STORE.END.ERROR
        END
    END

RETURN
*--------------------------------------------------------------------------------------------------------
GET.CUSTOMER.ID:


    CALL F.READ(FN.L.CU.CIDENT,PROSPECT.ID,R.L.CU.CIDENT,F.L.CU.CIDENT,CIDENT.ERR)
    IF R.L.CU.CIDENT THEN
        R.NEW(CARD.IS.PROSPECT.ID) = FIELD(R.L.CU.CIDENT,"*",2)
    END ELSE
        CALL F.READ(FN.L.CU.NOUNICO,PROSPECT.ID,R.L.CU.NOUNICO,F.L.CU.NOUNICO,NOUN.ERR)
        IF R.L.CU.NOUNICO THEN
            R.NEW(CARD.IS.PROSPECT.ID) = FIELD(R.L.CU.NOUNICO,"*",2)
        END ELSE
            CALL F.READ(FN.L.CU.RNC,PROSPECT.ID,R.L.CU.RNC,F.L.CU.RNC,RNC.ERR)
            IF R.L.CU.RNC THEN
                R.NEW(CARD.IS.PROSPECT.ID) = FIELD(R.L.CU.RNC,"*",2)
            END
        END
    END

RETURN
*-------------------------------------------------------------------------
**********
INIT.PARA:
**********
    DFQU = ''
    DFQU1 = ''
    COM.DFQ = ''

    FN.L.CU.CIDENT = 'F.CUSTOMER.L.CU.CIDENT'
    F.L.CU.CIDENT = ''
    CALL OPF(FN.L.CU.CIDENT,F.L.CU.CIDENT)

    FN.L.CU.NOUNICO = 'F.CUSTOMER.L.CU.NOUNICO'
    F.L.CU.NOUNICO = ''
    CALL OPF(FN.L.CU.NOUNICO,F.L.CU.NOUNICO)

    FN.L.CU.RNC = 'F.CUSTOMER.L.CU.RNC'
    F.L.CU.RNC = ''
    CALL OPF(FN.L.CU.RNC,F.L.CU.RNC)

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.CARD.RENEW = 'F.REDO.CARD.RENEWAL'
    F.CARD.RENEW = ''
    CALL OPF(FN.CARD.RENEW,F.CARD.RENEW)

    AZ.INSTALLED = 0
    LOCATE 'AZ' IN R.COMPANY(EB.COM.APPLICATIONS)<1,1> SETTING AZ.INSTALLED THEN
        FN.AZ.ACC = 'F.AZ.ACCOUNT'
        F.AZ.ACC = ''
        CALL OPF(FN.AZ.ACC,F.AZ.ACC)
        AZ.INSTALLED = 1
    END
*
    FV.STO.REG = 'F.STOCK.REGISTER'
    FP.STO.REG = ''
    CALL OPF(FV.STO.REG,FP.STO.REG)
*
    AZ.ACC.REC = ''
**
    FV.CRD.ISS = 'F.CARD.ISSUE'
    FP.CRD.ISS = ''
    CALL OPF(FV.CRD.ISS,FP.CRD.ISS)
*
    FV.CRD.RPY.DT = 'F.CARD.REPAYMENT.DATE'
    FP.CRD.RPY.DT = ''
    CALL OPF(FV.CRD.RPY.DT,FP.CRD.RPY.DT)
*
    FV.CRD.ISS.AC = 'F.CARD.ISSUE.ACCOUNT'
    FP.CRD.ISS.AC = ''
    CALL OPF(FV.CRD.ISS.AC,FP.CRD.ISS.AC)
*
    AZ.INSTALLED = 0
    LOCATE 'AZ' IN R.COMPANY(EB.COM.APPLICATIONS)<1,1> SETTING AZ.INSTALLED THEN
        FV.AZ.ACT.SUB.ACC = 'F.AZ.ACTIVE.SUB.ACC'
        FP.AZ.ACT.SUB.ACC = ''
        CALL OPF(FV.AZ.ACT.SUB.ACC,FP.AZ.ACT.SUB.ACC)
        AZ.INSTALLED = 1
    END
*
    PD.INSTALLED = 0
    LOCATE 'PD' IN R.COMPANY(EB.COM.APPLICATIONS)<1,1> SETTING PD.INSTALLED THEN
        FV.PD.PAY.DUE = 'F.PD.PAYMENT.DUE'
        FP.PD.PAY.DUE = ''
        CALL OPF(FV.PD.PAY.DUE,FP.PD.PAY.DUE)
        PD.INSTALLED = 1
    END
*
    FN.REDO.CARD.SERIES.PARAM = 'F.REDO.CARD.SERIES.PARAM'
    F.REDO.CARD.SERIES.PARAM = ''
    CALL OPF(FN.REDO.CARD.SERIES.PARAM,F.REDO.CARD.SERIES.PARAM)

    FN.ACCOUNT     = 'F.ACCOUNT'     ; F.ACCOUNT=''     ; CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.CARD.CHARGE = 'F.CARD.CHARGE' ; F.CARD.CHARGE='' ; CALL OPF(FN.CARD.CHARGE,F.CARD.CHARGE)
    FN.CARD.TYPE   ='F.CARD.TYPE'    ; F.CARD.TYPE=''   ; CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)
    CARD.TYPE.ID='' ; CARD.NO=''          ;* used in id validation
    ACCOUNT=''        ;* used in name validation
    ER=''
    LCY.AMT = ""

    CARD.TYPE = ''
    CARD.TYPE.ID = FIELD(ID.NEW,'.',1,1)
    CALL F.READ(FN.CARD.TYPE,CARD.TYPE.ID,R.CARD.TYPE,F.CARD.TYPE,ER)
    IF R.CARD.TYPE THEN
        ALLOW.FCY.ACCT = R.CARD.TYPE<CARD.TYPE.ALLOW.FCY.ACCT>
    END

    F.REDO.APAP.H.PARAMETER=''
    FN.REDO.APAP.H.PARAMETER='F.REDO.APAP.H.PARAMETER'
    CALL OPF(FN.REDO.APAP.H.PARAMETER,F.REDO.APAP.H.PARAMETER)

RETURN
*--------------------------------------------------------------------------------------------------------
************
PROCESS.PARA:
************

*CALL APAP.REDORETAIL.LATAM.CARD.ORDER.SPLIT.VALIDATE.1
    CALL APAP.REDORETAIL.latamCardOrderSplitValidate1();*MANUAL R22 CODE CONVERSION
*CALL APAP.REDORETAIL.LATAM.CARD.ORDER.SPLIT.VALIDATE.2
    CALL APAP.REDORETAIL.latamCardOrderSplitValidate2();*MANUAL R22 CODE CONVERSION

    GOSUB NEW.REPAY.DATE.VAL

**Validation for the inputting of new repay/bill date
    IF R.NEW(CARD.IS.NEW.BILLING.CLOSE) THEN
        IF TODAY LT R.OLD(CARD.IS.REPAY.DATE)[1,8] THEN         ;* CI_10016836 - S
            IF R.NEW(CARD.IS.NEW.BILLING.CLOSE)[1,8] GE R.OLD(CARD.IS.REPAY.DATE)[1,8] OR R.NEW(CARD.IS.NEW.BILLING.CLOSE)[1,8] LT TODAY THEN
                AF=CARD.IS.NEW.BILLING.CLOSE
                ETEXT = 'ST-RTN.BET.TODAY.AND.REPAY.DATE' ;* CI_10016836 - E
                CALL STORE.END.ERROR
                RETURN
            END
        END
    END

***First time checking for the status

    GOSUB CARD.STATUS.VAL

*split routine for STOCK.REG.ID validation is to be called

    IF R.NEW(CARD.IS.CURR.NO) GE 1 THEN
        RETURN
    END

RETURN
*--------------------------------------------------------------------------------------
NEW.REPAY.DATE.VAL:

    IF NOT(R.NEW(CARD.IS.NEW.REPAY.DATE)) THEN
        RETURN
    END
    IF R.NEW(CARD.IS.NEW.REPAY.DATE)[1,8] LT TODAY THEN
        AF = CARD.IS.NEW.REPAY.DATE
        ETEXT = "ST-RTN.LESS.THAN.TODAY"
        CALL STORE.END.ERROR
        RETURN

    END
    IF R.NEW(CARD.IS.NEW.REPAY.DATE)[1,8] LT R.OLD(CARD.IS.REPAY.DATE)[1,8] THEN
        AF = CARD.IS.NEW.REPAY.DATE
        ETEXT = "ST-RTN.NEW.REPAY.GRT.REPAY.DATE"
        CALL STORE.END.ERROR
        RETURN

    END ELSE
        COMI1 = R.NEW(CARD.IS.NEW.REPAY.DATE)
        COMI = R.NEW(CARD.IS.REPAY.DATE)
        CALL CFQ
        IF COMI1 LT COMI THEN
            AF = CARD.IS.NEW.REPAY.DATE
            ETEXT = 'ST-RTN.GRT.CYCL.REPAY.DATE'
            CALL STORE.END.ERROR

            RETURN
        END
        R.NEW(CARD.IS.NEW.REPAY.DATE) = COMI1
    END
    IF TODAY GT R.OLD(CARD.IS.LST.BILLING.CLOSE)[1,8] THEN
        IF R.NEW(CARD.IS.NEW.REPAY.DATE)[1,8] LT R.OLD(CARD.IS.BILLING.CLOSE)[1,8] THEN
            AF = CARD.IS.NEW.REPAY.DATE
            ETEXT = "ST-CRD.ISS.GT.BILL.CLOSE"
            CALL STORE.END.ERROR
            RETURN

        END
    END
RETURN
* CHANGES FOR HD1101263
*****************
ACCOUNT.VAL:
*****************

    CALL CACHE.READ(FN.REDO.APAP.H.PARAMETER,'SYSTEM',R.REDO.APAP.H.PARAMETER,PARAM.ERR)

    REST.REL.CODE=R.REDO.APAP.H.PARAMETER<PARAM.REST.REL.CRD>
    ACCT.ID=R.NEW(CARD.IS.ACCOUNT)
    CALL F.READ(FN.ACCOUNT,ACCT.ID,R.ACCOUNT,F.ACCOUNT,ERR)
    IF R.ACCOUNT THEN
        LOCATE REST.REL.CODE IN R.ACCOUNT<AC.RELATION.CODE,1> SETTING POS.REL THEN
            AF = CARD.IS.ACCOUNT
            ETEXT = 'EB-NOT.ALLOWED.FOR.JH'
            CALL STORE.END.ERROR
        END

    END

RETURN
* CHANGES END HD1101263
*------------------------------------------------------------------
CARD.STATUS.VAL:


*Prabhu N-PACS00061649-Start of modification



*PACS00061649-End of Modification
** No change of status after the card is ret/canl/scarp
    OLD.STATUS = R.OLD(CARD.IS.CARD.STATUS)

    IF OLD.STATUS EQ 93 OR OLD.STATUS EQ 35 THEN
        IF R.NEW(CARD.IS.CARD.STATUS) NE "97" THEN
            T(CARD.IS.ACCOUNT)<3> = 'NOINPUT'
            T(CARD.IS.CURRENCY)<3> = 'NOINPUT'
            T(CARD.IS.STOCK.REG.ID)<3> = 'NOINPUT'
            T(CARD.IS.STOCK.SERIERS.ID)<3> = 'NOINPUT'
            T(CARD.IS.CARD.START.NO)<3> = 'NOINPUT'
            AF = CARD.IS.CARD.STATUS
            ETEXT = "ST-RTN.NOT.VALID.STATUS"
            CALL STORE.END.ERROR
            RETURN
        END
    END
    IF (OLD.STATUS EQ 92 OR OLD.STATUS EQ 97) AND R.NEW(CARD.IS.CARD.STATUS) EQ 94 THEN
        AF = CARD.IS.CARD.STATUS
        ETEXT = "ST-RTN.NOT.VALID.STATUS"
        CALL STORE.END.ERROR
    END

*PACS00062260---------------------------------------

    IF R.NEW(CARD.IS.CARD.STATUS) EQ 93 AND R.OLD(CARD.IS.CARD.STATUS) NE 93 THEN
        R.NEW(CARD.IS.CANCELLATION.DATE)=TODAY
    END
*PACS00062260-END OF MODIFICATION------------------------------------------------



    IF R.NEW(CARD.IS.CARD.STATUS) EQ 90 AND R.NEW(CARD.IS.RENEW.STATUS) EQ "AVAILABLE" THEN
        R.NEW(CARD.IS.RENEWAL.NOTES) = "RENEWAL CARD ISSUE"
    END
*PACS00093181 -S

    IF R.NEW(CARD.IS.RENEW.CARD.LOST) EQ "YES" AND (R.NEW(CARD.IS.CARD.STATUS) EQ "52" OR R.NEW(CARD.IS.CARD.STATUS) EQ "92") THEN

        GOSUB CHECK.REISSUE.CASE
    END

    IF (R.NEW(CARD.IS.RENEW.REQ.ID) NE '' OR R.NEW(CARD.IS.RENEW.STATUS) NE '') AND (R.NEW(CARD.IS.CARD.STATUS) EQ "52" OR R.NEW(CARD.IS.CARD.STATUS) EQ "92") THEN
        GOSUB CHECK.REISSUE.CASE

    END

*PACS00093181 -E


RETURN
*---------------------------------------------------------------------------
CHECK.REISSUE.CASE:

    IF R.NEW(CARD.IS.ISSUE.INDICATOR) EQ "REISSUE" THEN
        AF = CARD.IS.ISSUE.INDICATOR
        ETEXT = "EB-NOT.ALLOW.RENEW.STAT"
        CALL STORE.END.ERROR
    END

    IF R.NEW(CARD.IS.ISSUE.NUMBER) NE '' THEN
        AF = CARD.IS.ISSUE.NUMBER
        ETEXT = "EB-NOT.ALLOW.RENEW.STAT"
        CALL STORE.END.ERROR
    END

RETURN
*-------------
END
