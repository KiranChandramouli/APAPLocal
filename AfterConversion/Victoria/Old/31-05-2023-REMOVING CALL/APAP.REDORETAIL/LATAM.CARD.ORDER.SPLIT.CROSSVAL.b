* @ValidationCode : MjotMTU1OTIwNjU0OTpDcDEyNTI6MTY4NTUzNTg3NDg4NDp2aWN0bzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 31 May 2023 17:54:34
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.ORDER.SPLIT.CROSSVAL
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.SPLIT.CROSSVAL
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine called in LATAM.CARD.ORDER.PROCESS
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 9 Aug 2010    Mohammed Anies K       ODR-2010-03-0400          Initial Creation
* 29 MAR 2010   SWAMINATHAN            ODR-2010-03-0400          Check made to stock incrementing CARD START NO
* 20 MAY 2010   KAVITHA                PACS00024249              STOCK.REGISTER has been removed as new design to maintain stock quantity designed
* 27 MAY 2011   KAVITHA                *PACS00063156             *PACS00063156 FIX
* 16 JUN 2011   KAVITHA                PACS00072694              CONDITION FOR PRIMARY CARD MODIFIED
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM and I++ to I=+1 , = TO EQ, #= TO NE
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CARD.ISSUE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CARD.CHARGE
    $INSERT I_F.CARD.TYPE
    $INSERT I_F.DATES
    $INSERT I_F.PAYMENT.STOP.TYPE
**
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
*---------End of core---------------------
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.LATAM.CARD.CLASS.CODE
    $INSERT I_F.REDO.CARD.RENEWAL

*-----------------------------------------------------------------------
*---------
MAIN.PARA:
*---------



    GOSUB INIT.PARA
    GOSUB PROCESS.PARA
*CALL APAP.REDORETAIL.LATAM.CARD.ORDER.SPLIT.VALIDATE
    APAP.REDORETAIL.latamCardOrderSplitValidate();* R22 manual conversion
*CALL APAP.REDORETAIL.LATAM.CARD.ORDER.SPLIT.PROCESS(ACCOUNT.ID,ACCOUNT,CARD.CHARGE,CHARGES,CHARGE.DATE,LCY.AMT)
    APAP.REDORETAIL.latamCardOrderSplitProcess(ACCOUNT.ID,ACCOUNT,CARD.CHARGE,CHARGES,CHARGE.DATE,LCY.AMT);* R22 Manual Conversion

    GOSUB CHECK.PRIMARY.CARD

RETURN
*-----------------------------------------------------------------------
*********
INIT.PARA:
*********
    FN.ACCOUNT = "F.ACCOUNT"
    F.ACCOUNT = ""
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    DFQU = ''
    DFQU1 = ''
    COM.DFQ = ''

    FN.CARD.RENEW = 'F.REDO.CARD.RENEWAL'
    F.CARD.RENEW = ''
    CALL OPF(FN.CARD.RENEW,F.CARD.RENEW)

    FV.CRD.TYP = 'F.CARD.TYPE'
    FP.CRD.TYP = ''
    CALL OPF(FV.CRD.TYP,FP.CRD.TYPE)

    AZ.INSTALLED = 0
    LOCATE 'AZ' IN R.COMPANY(EB.COM.APPLICATIONS)<1,1> SETTING AZ.INSTALLED THEN
        FV.AZ.ACC = 'F.AZ.ACCOUNT'
        FP.AZ.ACC = ''
        CALL OPF(FV.AZ.ACC,FP.AZ.ACC)
        AZ.INSTALLED = 1
    END
*
    FV.STO.REG = 'F.STOCK.REGISTER'
    FP.STO.REG = ''
    CALL OPF(FV.STO.REG,FP.STO.REG)
*
    AZ.ACC.REC = ''
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
    F.ACCOUNT='' ; FN.ACCOUNT.2 = "F.ACCOUNT" ;* AUTO R22 CODE CONVERSION
    CALL OPF(FN.ACCOUNT.2,F.ACCOUNT) ;* AUTO R22 CODE CONVERSION
    F.CARD.CHARGE='' ; FN.CARD.CHARGE = "F.CARD.CHARGE" ;* AUTO R22 CODE CONVERSION
    CALL OPF(FN.CARD.CHARGE,F.CARD.CHARGE) ;* AUTO R22 CODE CONVERSION
    F.CARD.TYPE='' ; FN.CARD.TYPE = "F.CARD.TYPE" ;* AUTO R22 CODE CONVERSION
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE) ;* AUTO R22 CODE CONVERSION
    CARD.TYPE.ID='' ; CARD.NO=''          ;* used in id validation
    ACCOUNT=''        ;* used in name validation
    ER=''
    LCY.AMT = ""

    ERROR.FLAG = 0

    FN.CRD.TYPE = 'F.CARD.TYPE'
    F.CRD.TYPE = ''
    CALL OPF(FN.CRD.TYPE,F.CRD.TYPE)
    CARD.TYPE = ''

    CARD.TYPE.ID = FIELD(ID.NEW,'.',1,1)
    CALL F.READ(FN.CRD.TYPE,CARD.TYPE.ID,R.CARD.TYPE,F.CRD.TYPE,CARD.TYPE.ERR)
    ALLOW.FCY.ACCT = R.CARD.TYPE<CARD.TYPE.ALLOW.FCY.ACCT>
RETURN
*------------
PROCESS.PARA:
*------------
    IF R.NEW(CARD.IS.CHARGES) EQ '' THEN
        CHARGES=''
        GOSUB CHARGES.VAL
        R.NEW(CARD.IS.CHARGES) = CHARGES
    END

    IF R.NEW(CARD.IS.CHARGE.DATE) EQ '' THEN
        CHARGE.DATE=''
        CHARGES=R.NEW(CARD.IS.CHARGES)
        GOSUB CHARGE.DATE.VAL
        R.NEW(CARD.IS.CHARGE.DATE) = CHARGE.DATE
    END
**CHECK MADE TO STOP INCREMENTING CARD START NO
*GOSUB STOP.CARD.START.NO
***
*CALL APAP.REDORETAIL.LATAM.CARD.ORDER.SPLIT.CROSSVAL.1
    APAP.REDORETAIL.latamCardOrderSplitCrossval1();* MANUAL R22 CODE CONVERSION
*

*PACS00024249-S

*  IF R.NEW(CARD.IS.STOCK.REG.ID) THEN
*        IF R.NEW(CARD.IS.STOCK.SERIERS.ID) EQ '' THEN
*           T(CARD.IS.CARD.START.NO)<3> = 'NOINPUT'
*           R.NEW(CARD.IS.STOCK.SERIERS.ID) = "**"
*       END
*   END

*PACS00024249 -E

**
    AF=CARD.IS.CARD.STATUS
    IF R.NEW(CARD.IS.CARD.STATUS) EQ '' THEN
        R.NEW(CARD.IS.CARD.STATUS) = '90'
    END

    AF = CARD.IS.ACCOUNT
    CALL DUP
*
    VMC = DCOUNT(R.NEW(CARD.IS.ACCOUNT),@VM)
    FOR Y.AV = VMC TO 1 STEP -1 ;* GB0002605 S/E To ensure that the 1st account is used for charging
        LOCATE R.NEW(CARD.IS.ACCOUNT)<1,Y.AV> IN R.OLD(CARD.IS.ACCOUNT)<1,1> SETTING POS ELSE
            ACCOUNT.ID=R.NEW(CARD.IS.ACCOUNT)<1,Y.AV>
            GOSUB ACCOUNT.VAL
            IF ER NE '' THEN
                AF=CARD.IS.ACCOUNT ; ETEXT=ER ; CALL STORE.END.ERROR ; ER=''
            END
        END
    NEXT Y.AV
    ISSUE.DATE = R.NEW(CARD.IS.EXPIRY.DATE)
    EXPIRY.DATE=R.NEW(CARD.IS.EXPIRY.DATE)
    PIN.ISSUE.DATE=R.NEW(CARD.IS.PIN.ISSUE.DATE)
*
    AF = CARD.IS.CAN.REASON
    IF R.NEW(CARD.IS.CANCELLATION.DATE) AND R.NEW(CARD.IS.CAN.REASON) EQ "" THEN ;* AUTO R22 CODE CONVERSION
        ETEXT ="ST.RTN.REASON.REQUIRED.WITH.DATE" ; CALL STORE.END.ERROR
    END
*
    IF R.NEW(CARD.IS.CANCELLATION.DATE) EQ "" AND R.NEW(CARD.IS.CAN.REASON) THEN
        ETEXT ="ST.RTN.NO.INP.WITHOUT.DATE.ALLOW" ; CALL STORE.END.ERROR
    END
*
    IF ID.OLD EQ '' THEN ;* AUTO R22 CODE CONVERSION
        CHARGES=R.NEW(CARD.IS.CHARGES)
        GOSUB CHARGES.VAL
        IF ER NE '' THEN ;* AUTO R22 CODE CONVERSION
            AF=CARD.IS.CHARGES ; ETEXT=ER ; CALL STORE.END.ERROR ; ER=''
        END
        CHARGE.DATE=R.NEW(CARD.IS.CHARGE.DATE)
        GOSUB CHARGE.DATE.VAL
        IF ER NE '' THEN ;* AUTO R22 CODE CONVERSION
            AF=CARD.IS.CHARGE.DATE ; ETEXT=ER ; CALL STORE.END.ERROR ; ER=''
        END
    END
**
    IF END.ERROR THEN
        A = 1
        LOOP UNTIL T.ETEXT<A> <> "" DO A += 1 ; REPEAT
        T.SEQU = A
        V$ERROR = 1
        MESSAGE = 'ERROR'
        P = 0
        RETURN
    END

    IF ID.OLD EQ "" THEN
        R.NEW(CARD.IS.CHARGES)=CHARGES
        R.NEW(CARD.IS.CHARGE.DATE)=CHARGE.DATE
    END

RETURN
*********************
*STOP.CARD.START.NO:
*********************
*******CHECK IS MADE TO STOP INCREMENTING CARD START NO

*IF R.NEW(CARD.IS.STOCK.SERIERS.ID) THEN
*CALL F.READ("F.STOCK.REGISTER",R.NEW(CARD.IS.STOCK.REG.ID),STOCK.REC,'',ERR2)
*Y.SER.ID = R.NEW(CARD.IS.STOCK.SERIERS.ID)
*Y.SER.ID = "*":Y.SER.ID:"*"
*LOCATE Y.SER.ID IN STOCK.REC<STO.REG.SERIES.ID,1> SETTING POS THEN
*IF STOCK.REC<STO.REG.SERIES.NO,POS> EQ '' THEN
*T(CARD.IS.CARD.START.NO)<3> = 'NOINPUT'
*R.NEW(CARD.IS.CARD.START.NO) = ''
*END ELSE
*T(CARD.IS.CARD.START.NO)<3> = ''
*IF R.NEW(CARD.IS.CARD.START.NO) EQ '' THEN
*IF R.NEW(CARD.IS.CURR.NO) EQ '' THEN
*R.NEW(CARD.IS.CARD.START.NO) = FIELD(STOCK.REC<STO.REG.SERIES.NO,POS,1>,'-',1)
*END
*END
*END
*END
*IF R.NEW(CARD.IS.CURR.NO) EQ '' THEN
*LOCATE Y.SER.ID IN STOCK.REC<STO.REG.SERIES.ID,1> SETTING POS THEN
*RANGE.FIELD = STOCK.REC<STO.REG.SERIES.NO,POS>
*RANGE.FIELD = RAISE(RANGE.FIELD)
*START.NO = R.NEW(CARD.IS.CARD.START.NO)
*END.NO = ''
*CALL EB.MAINTAIN.RANGES(RANGE.FIELD,START.NO,END.NO,"ENQ",RESULT,CHQ.ERROR)
*END
*IF RESULT EQ '' THEN
*AF = CARD.IS.CARD.START.NO
*ETEXT = "ST-RTN.NOT.A.VALID.CARD"
*CALL STORE.END.ERROR
*RETURN
*END
*END
*END

*RETURN
*-----------
CHARGES.VAL:
*-----------
    IF CHARGES EQ 0 THEN
        RETURN
    END

    CARD.CHARGE='' ; CALL F.READ('F.CARD.CHARGE',CARD.TYPE.ID,CARD.CHARGE,F.CARD.CHARGE,ER)
    IF ER EQ '' THEN ;* AUTO R22 CODE CONVERSION
        IF CHARGES EQ '' THEN ;* AUTO R22 CODE CONVERSION
            CHARGES=CARD.CHARGE<CARD.CHG.ISSUE.CHARGE>
*
* Convert to FCY if relevant
*
            IF R.NEW(CARD.IS.CURRENCY) NE LCCY AND CHARGES THEN
                LCY.AMT = CHARGES
                YFAMT = ""
                YFCY = R.NEW(CARD.IS.CURRENCY)
                YRATE = ""
                YMARKET = 1
                YLAMT = CHARGES
                YDIF.AMT = ""
                YDIF.PCT = ""
                CALL MIDDLE.RATE.CONV.CHECK (YFAMT,YFCY,YRATE,YMARKET,YLAMT,YDIF.AMT,YDIF.PCT)
                CHARGES = YFAMT
            END
        END ELSE        ;* CI_10026587/S
            IF R.NEW(CARD.IS.CURRENCY) NE LCCY AND CHARGES THEN ;* AUTO R22 CODE CONVERSION
                FCY.AMT = CHARGES
                YFAMT = CHARGES
                YFCY = R.NEW(CARD.IS.CURRENCY)
                YRATE = ""
                YMARKET = 1
                YLAMT = ""
                YDIF.AMT = ""
                YDIF.PCT = ""
                CALL MIDDLE.RATE.CONV.CHECK (YFAMT,YFCY,YRATE,YMARKET,YLAMT,YDIF.AMT,YDIF.PCT)
                LCY.AMT = YLAMT
                CHARGES = YFAMT
            END
        END
    END ELSE
        IF CHARGES THEN ;* entered charges cannot be processed
            ER='NO CHARGES DEFINED FOR TYPE &':@FM:CARD.TYPE.ID
        END ELSE        ;* no default charges
            ER=''
        END
    END

RETURN
*---------------
CHARGE.DATE.VAL:
*---------------

    IF CHARGE.DATE NE '' THEN ;* AUTO R22 CODE CONVERSION
        IF CHARGES THEN
            BEGIN CASE
                CASE CHARGE.DATE GT R.DATES(EB.DAT.FORW.VALUE.MAXIMUM)
                    ER='DATE EXCEEDS FORWARD VALUE MAXIMUM'
                CASE CHARGE.DATE LT R.DATES(EB.DAT.BACK.VALUE.MAXIMUM)
                    ER='DATE EXCEEDS BACK VALUE MAXIMUM'
            END CASE
        END ELSE
            ER='NO INPUT WITHOUT CHARGES'
        END
    END ELSE
        IF CHARGES THEN
            CHARGE.DATE=TODAY
        END
    END

RETURN
*-----------
ACCOUNT.VAL:
*-----------
    IF ACCOUNT.ID NE '' THEN ;* AUTO R22 CODE CONVERSION
        YCUST = ''
*CALL ACCOUNT.DBR(AC.CUSTOMER,ACCOUNT.ID,YCUST)
        CALL F.READ(FN.ACCOUNT,ACCOUNT.ID,R.ACC,F.ACCOUNT,Y.AC.ERR)
        YCUST = R.ACC<AC.CUSTOMER>
        IF ETEXT THEN
            ER = 'ACCOUNT NOT IN THIS COMPANY'
            RETURN
        END
        ACCOUNT='' ; CALL F.READ('F.ACCOUNT',ACCOUNT.ID,ACCOUNT,F.ACCOUNT,ER)
        IF ER EQ '' THEN ;* AUTO R22 CODE CONVERSION
            IF CARD.TYPE<CARD.TYPE.CATEGORY> NE '' THEN ;* AUTO R22 CODE CONVERSION
                LOCATE ACCOUNT<AC.CATEGORY> IN CARD.TYPE<CARD.TYPE.CATEGORY,1> SETTING V$ ELSE
                    ER='ACCOUNT CATEGORY INCORRECT'
                END
                IF ACCOUNT<AC.CURRENCY> NE LCCY AND ALLOW.FCY.ACCT[1,1] NE 'Y' THEN ;* AUTO R22 CODE CONVERSION
                    ER='ACCOUNT CURRENCY MUST BE LOCAL'
                END
            END
        END ELSE
            ER='MISSING & RECORD -&':@FM:'ACCOUNT':@VM:ACCOUNT.ID
        END
    END

RETURN
*---------------------------------------------------------------------------------------------
CHECK.PRIMARY.CARD:


*PACS00063156-S
*PACS00072694-S



    GET.CARD.TYPE = R.NEW(CARD.IS.TYPE.OF.CARD)
    IF GET.CARD.TYPE EQ "PRINCIPAL"  AND  R.NEW(CARD.IS.CARD.STATUS) EQ '90' AND R.NEW(CARD.IS.RENEW.STATUS) NE "AVAILABLE" THEN ;* AUTO R22 CODE CONVERSION

        Y.CUSTOMER.ID =  R.NEW(CARD.IS.CUSTOMER.NO)<1,1>
        Y.ACCOUNT.ID = R.NEW(CARD.IS.ACCOUNT)<1,1>
        CARD.RENW.ID = Y.CUSTOMER.ID:"-":Y.ACCOUNT.ID

        R.CARD.RENEW = ''
        CALL F.READ(FN.CARD.RENEW,CARD.RENW.ID,R.CARD.RENEW,F.CARD.RENEW,REN.ERR)
        IF R.CARD.RENEW THEN

            TYPE.OF.CARD = R.CARD.RENEW<REDO.RENEW.TYPE.OF.CARD>
            CHANGE @VM TO @FM IN TYPE.OF.CARD


            AVALI.TOT.COUNTER = DCOUNT(TYPE.OF.CARD,@FM)
            LOOP.CNTR = 1

            LOOP
            WHILE LOOP.CNTR LE AVALI.TOT.COUNTER

                GET.CURRENT.TYPE = TYPE.OF.CARD<LOOP.CNTR>
                RENEW.STATUS = R.CARD.RENEW<REDO.RENEW.STATUS,LOOP.CNTR>
                PREV.CARD.NO = R.CARD.RENEW<REDO.RENEW.PREV.CARD.NO,LOOP.CNTR>

                IF PREV.CARD.NO NE ID.NEW AND GET.CURRENT.TYPE EQ 'PRINCIPAL' THEN
                    IF RENEW.STATUS EQ 50 OR RENEW.STATUS EQ 94  OR RENEW.STATUS EQ 90 OR RENEW.STATUS EQ 74 OR RENEW.STATUS EQ 70 OR RENEW.STATUS EQ 75 THEN
                        AF = CARD.IS.TYPE.OF.CARD
                        ETEXT = "EB-PRINCIPAL.ERROR"
                        CALL STORE.END.ERROR
                        EXIT
                    END
                END

                LOOP.CNTR += 1
            REPEAT
        END
    END


*PACS00072694-E
*PACS00063156-E
RETURN
*-------------------------------------
END
