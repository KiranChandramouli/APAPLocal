* @ValidationCode : MjotMTg2MDI4NTY2NzpDcDEyNTI6MTY4NDQxMzM4Mjk0NjpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 May 2023 18:06:22
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
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM, FM TO @FM
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.TRIGGER.PART.DIS.BILLS

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC
*-----------------------------------------------------------------------------
* Developed By : TAM (Marimuthu S)
* Purpose : To trigger the bills whenever partial disbursement made.
* Reference : PACS00245100
*-----------------------------------------------------------------------------
    FN.AA.CHG.DET = 'F.AA.CHARGE.DETAILS'
    F.AA.CHG.DET = ''
    CALL OPF(FN.AA.CHG.DET,F.AA.CHG.DET)

    FN.REDO.AA.PART.DISBURSE.FC = 'F.REDO.AA.PART.DISBURSE.FC'
    F.REDO.AA.PART.DISBURSE.FC = ''
    CALL OPF(FN.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC)

    FN.REDO.GET.AAA.NEW.CHG.PDIS = 'F.REDO.GET.AAA.NEW.CHG.PDIS'
    F.REDO.GET.AAA.NEW.CHG.PDIS = ''
    CALL OPF(FN.REDO.GET.AAA.NEW.CHG.PDIS,F.REDO.GET.AAA.NEW.CHG.PDIS)

    Y.AA.ID = R.NEW(REDO.PDIS.ID.ARRANGEMENT)
    Y.EF.DATE = R.NEW(REDO.PDIS.VALUE.DATE)


    Y.HID = ID.NEW

    CALL F.READ(FN.REDO.AA.PART.DISBURSE.FC,Y.HID,R.REDO.AA.PART.DISBURSE.FC,F.REDO.AA.PART.DISBURSE.FC,FC.ER)

    OD.PROPERTY = 'CHARGE'
    Y.ACT.CHG = R.NEW(REDO.PDIS.CHARG.DISC)
    Y.CHG.AMT = R.NEW(REDO.PDIS.CHARG.AMOUNT)
    Y.CNT = DCOUNT(Y.ACT.CHG,@VM) ;*R22 AUTO CONVERSION

    IF NOT(R.REDO.AA.PART.DISBURSE.FC) THEN
        GOSUB NEW.PRO
    END ELSE
        GOSUB MOD.PRO
        GOSUB NEW.PRO
    END

RETURN

NEW.PRO:

    FLG = ''
    LOOP
    WHILE Y.CNT GT 0 DO
        FLG += 1
        Y.CHG = Y.ACT.CHG<1,FLG>
        Y.AMT = Y.CHG.AMT<1,FLG>
        Y.ID = Y.AA.ID:'-':Y.CHG
        CALL F.READ(FN.AA.CHG.DET,Y.ID,R.CHF,F.AA.CHG.DET,CHG.ERR)
* IF NOT(R.CHF) THEN
        ACT.ID = 'LENDING-CHANGE':'-':Y.CHG
        GOSUB TRIGGER.BILL
* END
        Y.CNT -= 1
    REPEAT

RETURN

MOD.PRO:

    CALL F.READ(FN.REDO.GET.AAA.NEW.CHG.PDIS,Y.HID,R.REDO.GET.AAA.NEW.CHG.PDIS,F.REDO.GET.AAA.NEW.CHG.PDIS,ST.ERR)

    IF R.REDO.GET.AAA.NEW.CHG.PDIS THEN
        Y.CND = DCOUNT(R.REDO.GET.AAA.NEW.CHG.PDIS,@FM) ; FLG.R = '' ;*R22 AUTO CONVERSION
        LOOP
        WHILE Y.CND GT 0 DO
            FLG.R += 1
            Y.AAA.ID = R.REDO.GET.AAA.NEW.CHG.PDIS<FLG.R>
            OFS.STRING.FINAL="AA.ARRANGEMENT.ACTIVITY,APAP.PDIS/R/PROCESS,,":Y.AAA.ID
            OFS.SRC = 'REDO.NAB'
            CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)
            Y.CND -= 1
        REPEAT
    END

RETURN

TRIGGER.BILL:


    OFS.STRING.FINAL="AA.ARRANGEMENT.ACTIVITY,APAP.PDIS/I/PROCESS,,,ARRANGEMENT:1:1=":Y.AA.ID:",ACTIVITY:1:1=":ACT.ID:",DIS.REF.ID:1:1=":Y.HID:",PROPERTY:1:1=":Y.CHG:",FIELD.NAME:1:1=FIXED.AMOUNT,FIELD.VALUE:1:1=":Y.AMT
    OFS.SRC = 'REDO.NAB'
    CALL OFS.POST.MESSAGE(OFS.STRING.FINAL,OFS.MSG.ID,OFS.SRC,OPTIONS)

RETURN

END
