* @ValidationCode : MjotMzI1ODc2NDUxOkNwMTI1MjoxNjgxMjc2NTUwMjQ4OklUU1M6LTE6LTE6MjMyOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:45:50
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 232
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE LATAM.CARD.ORDER.SPLIT.CROSSVAL.1
*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : LATAM.CARD.ORDER.SPLIT.CROSSVAL.1
*--------------------------------------------------------------------------------------------------------
*Description  : This is a validation routine called in LATAM.CARD.ORDER.SPLIT.CROSSVAL.1
*Linked With  : LATAM.CARD.ORDER
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------         ------               -------------            -------------
* 9 Aug 2010    Mohammed Anies K       ODR-2010-03-0400          Initial Creation
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*06-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           = TO EQ, END ADDED FOR IF STATEMENT
*06-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
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
    $INSERT I_F.MNEMONIC.COMPANY
    $INSERT I_F.MNEMONIC.DAO
    $INSERT I_F.DEPT.ACCT.OFFICER
    $INSERT I_F.LOCAL.TABLE
    $INSERT I_F.AZ.PRODUCT.PARAMETER
    $INSERT I_GTS.COMMON
*---------End of core---------------------
    $INSERT I_F.LATAM.CARD.ORDER
    $INSERT I_F.LATAM.CARD.CLASS.CODE
*-----------------------------------------------------------------------
*---------
MAIN.PARA:
*---------



    GOSUB INIT.PARA
    GOSUB PROCESS.PARA

RETURN
*-----------------------------------------------------------------------
*********
INIT.PARA:
*********
*Necessary variables and file variables are initialised and opened
    DFQU = ''
    DFQU1 = ''
    COM.DFQ = ''

    LCY.AMT = ""

    ERROR.FLAG = 0
    FN.CARD.TYPE = 'F.CARD.TYPE'
    F.CARD.TYPE = ''
    CALL OPF(FN.CARD.TYPE,F.CARD.TYPE)
    CARD.TYPE.ID = FIELD(ID.NEW,'.',1)
    CALL F.READ(FN.CARD.TYPE,CARD.TYPE.ID,R.CARD.TYPE,F.CARD.TYPE,Y.ERR.CT)
RETURN
*-------------------------------------------------------------------------------------
*------------
PROCESS.PARA:
*------------
    IF R.NEW(CARD.IS.REPAY.DATE) NE '' AND R.NEW(CARD.IS.ORIG.REPAY.DATE) EQ '' AND GTSACTIVE THEN
        Y.SAVE.COMI = COMI
        COMI = R.NEW(CARD.IS.REPAY.DATE)
        GOSUB GET.REPAY.DATE
        IF ER NE '' THEN
            AF = CARD.IS.REPAY.DATE
            ETEXT = ER
            CALL STORE.END.ERROR
            ER = ''
        END
        R.NEW(CARD.IS.REPAY.DATE) = COMI
        COMI = Y.SAVE.COMI
    END
    IF R.NEW(CARD.IS.BILLING.CLOSE) NE '' AND R.NEW(CARD.IS.ORIG.BILLING.CLOSE) EQ '' AND GTSACTIVE THEN
        Y.SAVE.COMI = COMI
        COMI = R.NEW(CARD.IS.BILLING.CLOSE)
        GOSUB GET.BILL.CLOSE.DATE
        IF ER NE '' THEN
            AF = CARD.IS.BILLING.CLOSE
            ETEXT = ER
            CALL STORE.END.ERROR
            ER = ''
        END
        R.NEW(CARD.IS.BILLING.CLOSE) = COMI
        COMI = Y.SAVE.COMI
    END


    AF=CARD.IS.REPAY.DATE
    IF R.NEW(CARD.IS.REPAY.DATE) EQ '' THEN
        GOSUB CHECK.FOR.AZ.PRODUCT
        IF ER NE '' THEN
            AF=CARD.IS.REPAY.DATE ; ETEXT=ER ; CALL STORE.END.ERROR ; ER=''
        END
    END
    IF R.NEW(AF) AND R.NEW(CARD.IS.BILLING.CLOSE) EQ '' THEN
        ETEXT = 'ST-NO.INPUT.WHEN.BILL.CLOSE.EMPTY'
        CALL STORE.END.ERROR
    END

    AF=CARD.IS.BILLING.CLOSE
    IF R.NEW(CARD.IS.BILLING.CLOSE) EQ '' THEN
        GOSUB CHECK.FOR.AZ.PRODUCT
        IF ER NE '' THEN
            AF=CARD.IS.BILLING.CLOSE ; ETEXT=ER ; CALL STORE.END.ERROR ; ER=''
        END
    END
*CI_10018200 S
    AF=CARD.IS.BILLING.CLOSE
    IF NOT(R.OLD(CARD.IS.BILLING.CLOSE)) THEN
        IF R.NEW(CARD.IS.BILLING.CLOSE) GT R.NEW(CARD.IS.REPAY.DATE)  AND R.NEW(CARD.IS.REPAY.DATE) NE '' THEN    ;*CI_10024860 - S/E
            ETEXT = "ST-RTN.GRT.REPAY.DATE"
            CALL STORE.END.ERROR
        END
    END
    IF R.NEW(AF) AND R.NEW(CARD.IS.REPAY.DATE) EQ '' THEN
        ETEXT = 'ST-NO.INPUT.WHEN.REPAY.EMPTY'
        CALL STORE.END.ERROR
    END

    IF (R.NEW(CARD.IS.LST.REPAY.DATE)[1,8] OR R.NEW(CARD.IS.LST.BILLING.CLOSE)[1,8] ) ELSE
        IF R.NEW(CARD.IS.REPAY.DATE)[1,8] AND ( R.NEW(CARD.IS.REPAY.DATE)[1,8] EQ R.NEW(CARD.IS.BILLING.CLOSE)[1,8] ) THEN
            AF = CARD.IS.REPAY.DATE
            ETEXT = "ST-SHOULD.NOT.BE.SAME"
            CALL STORE.END.ERROR
        END
    END

    IF R.NEW(CARD.IS.BILLING.CLOSE) EQ '' THEN
        R.NEW(CARD.IS.ORIG.BILLING.CLOSE) = ''
    END
    IF R.NEW(CARD.IS.REPAY.DATE) EQ '' THEN
        R.NEW(CARD.IS.ORIG.REPAY.DATE) = ''
    END
RETURN
*-------------------------------------------------
*--------------
GET.REPAY.DATE:
*--------------
    DFQU = COMI[9,5]
    IF COMI EQ '' THEN
        GOSUB CHECK.FOR.AZ.PRODUCT
        IF ER THEN
            RETURN
        END
    END
*
    IF COMI THEN
        COMI1 = COMI
        R.NEW(CARD.IS.ORIG.REPAY.DATE) = COMI1
*CALL REBUILD.SCREEN
        GOSUB CHECK.FOR.HOLIDAY
    END

RETURN
*-------------------
GET.BILL.CLOSE.DATE:
*-------------------
    YDAYS = ''
    REP.DATE = R.NEW(CARD.IS.REPAY.DATE)[1,8]
    DFQU = R.NEW(CARD.IS.REPAY.DATE)[9,12]
*        IF COMI # '' THEN
*            IF COMI[1,1] NE 'D' THEN
*
    BEGIN CASE
        CASE COMI AND COMI[1,1] NE 'D'
            CALL IN2FQO(N(AF), T(AF))
            REP.DATE = ''
            IF COMI[9,5] THEN
                DFQU = ''
            END
            REP.DATE = COMI


        CASE COMI[1,1] EQ 'D' AND NOT(COMI MATCHES "'D-'2N")
            ER = "INVALID INPUT"
            RETURN

        CASE COMI[1,1] EQ 'D' ;*AUTO R22 CODE CONVERSION
            YDAYS = FIELD(COMI,'-',2)
            YDAYS = '-':YDAYS:'C'

        CASE COMI EQ ''
            CALL F.READ(FV.CRD.TYP,FIELD(ID.NEW,'.',1),CRD.TYP.REC,FP.CRD.TYP,ERR12)
            IF CRD.TYP.REC<CARD.TYPE.BILLING.DAY> NE '' THEN
                YDAYS = FIELD(CRD.TYP.REC<CARD.TYPE.BILLING.DAY>,'-',2)
                YDAYS = '-':YDAYS:'C'
            END ELSE
                REP.DATE = ''
                YDAYS = ''
            END

    END CASE
    IF ETEXT THEN
        ER = ETEXT
        RETURN
    END

    LOC.REGION = R.COMPANY(EB.COM.LOCAL.COUNTRY)
    IF LOC.REGION EQ "" THEN ;*AUTO R22 CODE CONVERSION
        LOC.REGION = R.COMPANY(EB.COM.LOCAL.REGION)
    END
    ELSE
        LOC.REGION = LOC.REGION:"00"
    END
    IF YDAYS AND REP.DATE THEN
        CALL CDT(LOC.REGION,REP.DATE,YDAYS)
        IF DFQU[1,1] EQ 'M' THEN
            COMI = REP.DATE:DFQU[1,3]:REP.DATE[7,2]
        END ELSE
            COMI = REP.DATE:DFQU
        END
        V$DISPLAY = COMI
    END ELSE
        IF REP.DATE THEN
            IF DFQU[1,1] EQ 'M' THEN
                COMI = REP.DATE:DFQU[1,3]:REP.DATE[7,2]
            END ELSE
                COMI = REP.DATE:DFQU
            END
        END
    END

    IF COMI THEN
        COMI1 = COMI
        COM.DFQ = COMI1[9,5]
        R.NEW(CARD.IS.ORIG.BILLING.CLOSE) = COMI1
*CALL REBUILD.SCREEN
        GOSUB CHECK.FOR.HOLIDAY
    END
    IF COMI EQ '' THEN
        GOSUB CHECK.FOR.AZ.PRODUCT
        IF ER THEN
            RETURN
        END
    END
    IF COMI THEN
        IF COMI LT TODAY THEN
            ER = "ST-RTN.NOT.LESS.THAN.TODAY"
            RETURN
        END
        IF COMI GT R.NEW(CARD.IS.REPAY.DATE) AND R.NEW(CARD.IS.REPAY.DATE) NE '' THEN
            ER = "ST-RTN.GRT.REPAY.DATE"
            RETURN
        END
    END

    IF COM.DFQ[1,1] EQ 'M' THEN
        COMI = COMI[1,8]:COM.DFQ
    END

    V$DISPLAY = COMI

RETURN
*------------------------------------------------------
*--------------------
CHECK.FOR.AZ.PRODUCT:
*--------------------
    CRD.TYP.REC = ''
    CRD.TYP.ID = FIELD(ID.NEW,'.',1)
*CALL DBR("CARD.TYPE":FM:CARD.TYPE.AZ.PRODUCT:FM:"L",CRD.TYP.ID,CRD.TYP.REC)
    CRD.TYP.REC = R.CARD.TYPE<CARD.TYPE.AZ.PRODUCT>
    IF CRD.TYP.REC NE '' THEN
        ER = "ST-RTN.MANDATORY.INPUT.CARD.TYPE"
    END ELSE
        ER = ''
    END

RETURN
*-----------------
CHECK.FOR.HOLIDAY:
*-----------------
    REGION.CODE = ''
    COUNTRY.CD = ''
    CARD.TYPE.ID = FIELD(ID.NEW,'.',1)
*CALL DBR("CARD.TYPE":FM: CARD.TYPE.FORWARD.BACKWARD,CARD.TYPE.ID,FWD.BWK.IND)
*FWD.BWK.IND = '1'
    FWD.BWK.IND =  R.CARD.TYPE<CARD.TYPE.FORWARD.BACKWARD>
    DAYTYPE = ''
    SAVE.COMI = COMI[1,8]
    CYCLED.DATES = ""
    IF COUNTRY.CD EQ "" THEN
        COUNTRY.CD = ID.COMPANY
    END
    IF REGION.CODE EQ '' THEN
        LOCAL.COUNTRY = R.COMPANY(EB.COM.LOCAL.COUNTRY)
        LOCAL.REGION = R.COMPANY(EB.COM.LOCAL.REGION)
        IF LOCAL.REGION EQ '' THEN ;*AUTO R22 CODE CONVERSION START
            LOCAL.REGION = '00'
        END ;*AUTO R22 CODE CONVERSION END
        REGION.CODE = LOCAL.COUNTRY:LOCAL.REGION
    END
    CALL AWD(REGION.CODE,SAVE.COMI,DAYTYPE)
    IF DAYTYPE EQ 'W' OR FWD.BWK.IND[1,1] EQ '4' THEN
        RETURN
    END ELSE
        BEGIN CASE
            CASE FWD.BWK.IND[1,1] EQ '1'
                CAL.TYPE = 'S'
                FOR.BACK.IND = 'F'
                DISPLACEMENT= ''
            CASE FWD.BWK.IND[1,1] EQ '2'
                CAL.TYPE = 'S'
                FOR.BACK.IND = 'B'
                DISPLACEMENT= ''
            CASE FWD.BWK.IND[1,1] EQ '3'
                FOR.BACK.IND = 'F'
                CAL.TYPE = 'D'
                DISPLACEMENT = '0M'
        END CASE
        START.DATE = COMI
        SIGN = ''
        COUNTRY.CODE = COUNTRY.CD
        REGION.CD = ''
        RETURN.DATE = ''
        RETURN.CODE = ''
        RETURN.DISPLACEMENT = ''
        CALL WORKING.DAY(CAL.TYPE, START.DATE, SIGN, DISPLACEMENT, FOR.BACK.IND, COUNTRY.CODE, REGION.CD, RETURN.DATE, RETURN.CODE,RETURN.DISPLACEMENT)
        IF DFQU THEN
            COMI = RETURN.DATE:DFQU
        END ELSE
            COMI = RETURN.DATE:DFQU1
        END
    END

RETURN
*----------------------------------------------------------------------------------------------
END
