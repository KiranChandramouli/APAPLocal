* @ValidationCode : Mjo2NzU1MjE0MDE6Q3AxMjUyOjE2ODEyODgyODI5Njg6c2FtYXI6LTE6LTE6MDowOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Apr 2023 14:01:22
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.FUND.CHK
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.V.INP.FUND.CHK
*----------------------------------------------------------------------
*DESCRIPTION: This routine is used to check the available balance of L.AZ.DEBIT.ACC if mode of payment is equal to "FROM.CUST.ACC"
*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: AZ OPENING VERSIONS
*----------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------
* DATE           WHO              REFERENCE        DESCRIPTION
* 28.10.2011  S SUDHARSANAN       CR.18            INITIAL CREATION
* 27/10/2015  Vignesh Kumaar R    PACS00460448     SOBR OVERRIDE NOT TO BE RAISED WHEN FUNDS ARE IN TRANSIT
*----------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*12-04-2023            Conversion Tool             R22 Auto Code conversion                   FM TO @FM,VM TO @VM,SM TO @SM,++ TO +=1
*12-04-2023              Samaran T                R22 Manual Code conversion                         CALL ROUTINE FORMAT MODIFIED
*-------------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AZ.ACCOUNT
    $INSERT I_F.USER
    $INSERT I_F.REDO.MTS.DISBURSE
    GOSUB INIT
    IF OFS$OPERATION EQ 'PROCESS' THEN
        GOSUB PROCESS
    END
    GOSUB END1
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.MTS.DISBURSE = 'F.REDO.MTS.DISBURSE'
    F.REDO.MTS.DISBURSE = ''
    CALL OPF(FN.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE)

    LOC.REF.APPLICATION="ACCOUNT":@FM:"AZ.ACCOUNT"
    LOC.REF.FIELDS='L.AC.AV.BAL':@VM:'L.AC.STATUS1':@FM:'L.AZ.METHOD.PAY':@VM:'L.AZ.AMOUNT':@VM:'L.AZ.DEBIT.ACC'
    LOC.REF.POS=''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.AC.AV.BAL     = LOC.REF.POS<1,1>
    POS.AC.STATUS     = LOC.REF.POS<1,2>
    POS.AZ.METHOD.PAY = LOC.REF.POS<2,1>
    POS.AZ.AMOUNT     = LOC.REF.POS<2,2>
    POS.DEBIT.ACC     = LOC.REF.POS<2,3>

RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------
    VAR.ACCOUNT = R.NEW(AZ.REPAY.ACCOUNT)
    VAR.CUSTOMER = R.NEW(AZ.CUSTOMER)
    IF NOT(VAR.ACCOUNT) THEN
        VAR.METHOD.PAY = R.NEW(AZ.LOCAL.REF)<1,POS.AZ.METHOD.PAY>
        CHANGE @SM TO @FM IN VAR.METHOD.PAY
        METHOD.COUNT = DCOUNT(VAR.METHOD.PAY,@FM) ; CNT =1
        IF NOT(METHOD.COUNT) THEN
            AF = AZ.LOCAL.REF
            AV = POS.AZ.METHOD.PAY
            AS = 1
            ETEXT = 'AC-MAND.FLD'
            CALL STORE.END.ERROR
            GOSUB END1
        END
        GOSUB CHECK.DISBURSEMENT
        LOOP
        WHILE CNT LE METHOD.COUNT
            POS = ''
            VAR.DEB.ACC = R.NEW(AZ.LOCAL.REF)<1,POS.DEBIT.ACC>
            CHANGE @SM TO @FM IN VAR.DEB.ACC
            GOSUB CHECK.ACCOUNT
            CNT += 1
        REPEAT
    END ELSE
        GOSUB CHECK.STATUS
    END
RETURN
*----------------------------------------------------------------------------
CHECK.DISBURSEMENT:
*----------------------------------------------------------------------------
    LOCATE "FROM.DISBURSEMENT" IN VAR.METHOD.PAY SETTING DIS.POS THEN
        Y.METHOD.PAY = VAR.METHOD.PAY<DIS.POS>
        Y.DISB.AMT = R.NEW(AZ.LOCAL.REF)<1,POS.AZ.AMOUNT,DIS.POS>
        VAR.DISB.AMT.LIST = '' ; SEL.LIST = ''
*PACS00269502-S
        CALL APAP.REDOFCFI.REDO.CUST.IDENTITY.REF(VAR.CUSTOMER,VAR.CUST.ALTER.ID,VAR.CUST.NAME)    ;*R22 MANUAL CODE CONVERSION
*SEL.CMD = "SELECT ":FN.REDO.MTS.DISBURSE:" WITH CUSTOMER.NO EQ ":VAR.CUSTOMER:" AND TRAN.TYPE EQ DEPOSIT"
        SEL.CMD = "SELECT ":FN.REDO.MTS.DISBURSE:" WITH IDENTITY.DOC EQ ":VAR.CUST.ALTER.ID:" AND TRAN.TYPE EQ DEPOSIT AND AZ.ACCOUNT EQ ''"
*PACS00269502-E
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NOR,ER.REC)

        IF NOT(SEL.LIST) AND V$FUNCTION EQ 'I' THEN
            GOSUB CHECK.ERROR.MSG
            GOSUB END1
        END

        GOSUB FORM.DISB.AMOUNT

        LOCATE Y.DISB.AMT IN VAR.DISB.AMT.LIST SETTING POS.DISB THEN

            Y.MTS.ID = VAR.MTS.ID.LIST<POS.DISB>
            CALL F.READ(FN.REDO.MTS.DISBURSE,Y.MTS.ID,R.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE,DISB.ERR)

            BEGIN CASE
                CASE V$FUNCTION EQ 'I'
                    R.REDO.MTS.DISBURSE<MT.AZ.ACCOUNT> = ID.NEW
                CASE V$FUNCTION EQ 'D'
                    R.REDO.MTS.DISBURSE<MT.AZ.ACCOUNT> = ''
            END CASE

            CALL F.WRITE(FN.REDO.MTS.DISBURSE,Y.MTS.ID,R.REDO.MTS.DISBURSE)

        END ELSE
            IF V$FUNCTION EQ 'I' THEN
                GOSUB CHECK.ERROR.MSG
                GOSUB END1
            END
        END
    END
RETURN
*---------------------------------------------------------------------------------------------
CHECK.ERROR.MSG:
*----------------------------------------------------------------------------------------------

    AF = AZ.LOCAL.REF
    AV = POS.AZ.AMOUNT
    AS = DIS.POS
    ETEXT = 'EB-REDO.CHECK.DISBURSE'
    CALL STORE.END.ERROR

RETURN
*-----------------------------------------------------------------------------------------------
FORM.DISB.AMOUNT:
*--------------------------------------------------------------------------------------------------
    DISP.CNT = 1
    LOOP
    WHILE DISP.CNT LE NOR
        VAR.MTS.ID = SEL.LIST<DISP.CNT>
        CALL F.READ(FN.REDO.MTS.DISBURSE,VAR.MTS.ID,R.REDO.MTS.DISBURSE,F.REDO.MTS.DISBURSE,DISB.ERR)

        IF NOT(VAR.DISB.AMT.LIST) THEN
            VAR.DISB.AMT.LIST = R.REDO.MTS.DISBURSE<MT.AMOUNT>
            VAR.MTS.ID.LIST = VAR.MTS.ID
        END ELSE
            VAR.DISB.AMT.LIST<-1> = R.REDO.MTS.DISBURSE<MT.AMOUNT>
            VAR.MTS.ID.LIST<-1> = VAR.MTS.ID
        END
        DISP.CNT += 1
    REPEAT

RETURN
*--------------------------------------------------------------------------------------------------
CHECK.ACCOUNT:
*--------------------------------------------------------------------------------------------------
    IF (VAR.METHOD.PAY<CNT> EQ 'FROM.CUST.ACC') AND (VAR.DEB.ACC<CNT> NE '') THEN
        VAR.AMOUNT = R.NEW(AZ.LOCAL.REF)<1,POS.AZ.AMOUNT,CNT>
        VAR.ACCOUNT = VAR.DEB.ACC<CNT>
        GOSUB CHECK.STATUS
        ACC.CUR = R.ACCOUNT<AC.CURRENCY>

        IF R.ACCOUNT THEN
            Y.AMOUNT = R.ACCOUNT<AC.LOCAL.REF,POS.AC.AV.BAL>

* Fix for PACS00460448 [#2 SOBR OVERRIDE NOT TO BE RAISED WHEN FUNDS ARE IN TRANSIT]

            Y.LOCKED.AMOUNT = SUM(R.ACCOUNT<AC.LOCKED.AMOUNT>)
            Y.AMT.INCL.TRANS = Y.AMOUNT + Y.LOCKED.AMOUNT

            IF Y.AMOUNT LT VAR.AMOUNT THEN
                GOSUB RAISE.OVERRIDE
            END
        END
    END ELSE
* Add the code to validate the Account number for pay method type other than 'FROM.CUST.ACC'
        IF (VAR.METHOD.PAY<CNT> NE '' AND VAR.METHOD.PAY<CNT> NE 'FROM.CUST.ACC' AND VAR.DEB.ACC<CNT> NE '') THEN
            VAR.ACCOUNT = VAR.DEB.ACC<CNT>
            R.ACCOUNT = '' ; ACC.ERR = ''
            CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
            YCATEG = R.ACCOUNT<AC.CATEGORY>
            IF (YCATEG[1,1] EQ '6' AND LEN(YCATEG) EQ '4') THEN
                ETEXT = 'AZ-NOT.CUST.ACCT'
                CALL STORE.END.ERROR
                GOSUB END1
            END
        END
    END
RETURN
*--------------------------------------------------------------------------------------------------
RAISE.OVERRIDE:
*-----------------------------------------------------------------------------------------

    IF Y.AMT.INCL.TRANS LT VAR.AMOUNT THEN
        OD.AMOUNT = VAR.AMOUNT - Y.AMOUNT
        TEXT = "ACCT.UNAUTH.OD":@FM:ACC.CUR:@VM:OD.AMOUNT:@VM:VAR.ACCOUNT
    END ELSE
        TEXT = "NO.ENOUGH.LIMIT":@FM:VAR.ACCOUNT
    END

    CURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),'VM') + 1
    CALL STORE.OVERRIDE(CURR.NO)

* End of Fix

RETURN
*------------------------------------------------------------------------------------------
CHECK.STATUS:
*-------------------------------------------------------------------------------------------
    R.ACCOUNT = '' ; ACC.ERR = ''
    CALL F.READ(FN.ACCOUNT,VAR.ACCOUNT,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
    Y.CUSTOMER = R.ACCOUNT<AC.CUSTOMER>
    GOSUB CHECK.THIRD.PARTY
    Y.STATUS=R.ACCOUNT<AC.LOCAL.REF,POS.AC.STATUS>
    IF Y.STATUS NE 'ACTIVE' AND Y.STATUS NE '' AND R.ACCOUNT<AC.CUSTOMER> NE '' THEN
        VIRTUAL.TAB.ID='L.AC.STATUS1'
        CALL EB.LOOKUP.LIST(VIRTUAL.TAB.ID)
        Y.LOOKUP.LIST=VIRTUAL.TAB.ID<2>
        Y.LOOKUP.DESC=VIRTUAL.TAB.ID<11>
        CHANGE '_' TO @FM IN Y.LOOKUP.LIST
        CHANGE '_' TO @FM IN Y.LOOKUP.DESC
        LOCATE Y.STATUS IN Y.LOOKUP.LIST SETTING POS1 THEN
            IF R.USER<EB.USE.LANGUAGE> EQ 1 THEN  ;* This is for english user
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
            END
            IF R.USER<EB.USE.LANGUAGE> EQ 2 AND Y.LOOKUP.DESC<POS1,2> NE '' THEN
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,2>   ;* This is for spanish user
            END ELSE
                Y.MESSAGE=Y.LOOKUP.DESC<POS1,1>
            END
            TEXT="REDO.AC.CHECK.ACTIVE":@FM:VAR.ACCOUNT:@VM:Y.MESSAGE
            CURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),'VM') + 1
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
RETURN
*-----------------------------------------------------------------------------------------
CHECK.THIRD.PARTY:
*------------------------------------------------------------------------------------------
    IF (Y.CUSTOMER NE '') AND (Y.CUSTOMER NE VAR.CUSTOMER) THEN
        Y.JOINT.HOLD = R.ACCOUNT<AC.JOINT.HOLDER>
        LOCATE VAR.CUSTOMER IN Y.JOINT.HOLD<1,1> SETTING POS1 THEN
            GOSUB CHECK.JOINT.HOLD
        END ELSE
            TEXT = "EB-THIRD.PARTY.DEBIT"
            CURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),'VM') + 1
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
RETURN
*-------------------------------------------------------------------------------------------
CHECK.JOINT.HOLD:
*-------------------------------------------------------------------------------------------
    Y.RELATION.CODE = R.ACCOUNT<AC.RELATION.CODE,POS1>
    IF (Y.RELATION.CODE GE 500 AND Y.RELATION.CODE LE 599) ELSE
        TEXT = "EB-THIRD.PARTY.DEBIT"
        CURR.NO = DCOUNT(R.NEW(AZ.OVERRIDE),'VM') + 1
        CALL STORE.OVERRIDE(CURR.NO)
    END
RETURN
*-------------------------------------------------------------------------------------------
END1:
*------
END
