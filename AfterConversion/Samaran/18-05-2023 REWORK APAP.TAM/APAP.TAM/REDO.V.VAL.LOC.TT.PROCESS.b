* @ValidationCode : MjoyMDE0MjM5NTc0OkNwMTI1MjoxNjg0NDA4NjM0NzU5OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 May 2023 16:47:14
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
SUBROUTINE REDO.V.VAL.LOC.TT.PROCESS
*-----------------------------------------------------------------------------
*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :MARIMUTHU S
*Program   Name    :REDO.V.VAL.LOC.TT.PROCESS
*---------------------------------------------------------------------------------

*DESCRIPTION       : This is validation routine for the local field no.of.installament
* This will populate the amount value
* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 10-08-2010        MARIMUTHU S      PACS00094144       Initial Creation
* 20-10-2011        MARIMUTHU S      PACS00126000
* 16-05-2012        MARIMUTHU S      PACS00197550
*25-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM,SM TO @SM
*25-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.PAYMENT.SCHEDULE
    $INSERT I_F.AA.ACCOUNT.DETAILS
    $INSERT I_F.ACCOUNT
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.PART.TT.PROCESS
    $INSERT I_F.AA.BILL.DETAILS

MAIN:


    IF MESSAGE EQ 'VAL' THEN
        RETURN
    END

    FN.AA.ACCOUNT.DETAILS='F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS=''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT='F.ACCOUNT'
    F.ACCOUNT=''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)


    VAR.AA.ID=R.NEW(PAY.PART.TT.ARRANGEMENT.ID)
    GOSUB PROCESS

    R.NEW(PAY.PART.TT.AMOUNT)= Y.FIN.AMT

RETURN

PROCESS:


    Y.CNT.VAL = COMI
    Y.CNT.NN = COMI

    IF VAR.AA.ID[1,2] NE 'AA' THEN
        CALL F.READ(FN.ACCOUNT,VAR.AA.ID,R.ACCOUNT,F.ACCOUNT,ACC.ERR)
        VAR.AA.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
        Y.CUS = R.ACCOUNT<AC.CUSTOMER>
    END ELSE
        CALL F.READ(FN.AA.ARRANGEMENT,VAR.AA.ID,R.AA.ARRANGEMENT,F.AA.ARRANGEMENT,AA.ARR.ERR)
        Y.CUS = R.AA.ARRANGEMENT<AA.ARR.CUSTOMER>
    END

* PACS00126000 - S

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,VAR.AA.ID,R.AA.ACCOUNT.DETAILS ,F.AA.ACCOUNT.DETAILS ,ERR)
    Y.BILL.IDS = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
    Y.BILL.IDS = CHANGE(Y.BILL.IDS,@SM,@VM) ;*R22 AUTO CONVERSION
    Y.CNT.VM = DCOUNT(Y.BILL.IDS,@VM) ;*R22 AUTO CONVERSION
    Y.CN.VM = Y.CNT.VM
    FLG.BL = ''
    LOOP
    WHILE Y.CNT.VM GT 0 AND Y.CNT.VAL GT 0 DO
        FLG.BL += 1
        Y.BIL.ID = Y.BILL.IDS<1,FLG.BL>
        CALL F.READ(FN.AA.BILL.DETAILS,Y.BIL.ID,R.AA.BILL.DETAILS,F.AA.BILL.DETAILS,BIL.ER)
        Y.BL.TYPE = R.AA.BILL.DETAILS<AA.BD.BILL.TYPE>
        LOCATE 'PAYMENT' IN Y.BL.TYPE<1,1> SETTING POS.CH THEN
            IF R.AA.BILL.DETAILS<AA.BD.SETTLE.STATUS,1> EQ 'UNPAID' THEN
                Y.FIN.AMT += SUM(R.AA.BILL.DETAILS<AA.BD.OS.PROP.AMOUNT>)
                FLG += 1
                Y.CNT.VAL -= 1
            END
        END
        Y.CNT.VM -= 1
    REPEAT


    IF Y.CNT.NN GT FLG THEN
        ARRANGEMENT.ID = VAR.AA.ID
        CALL AA.SCHEDULE.PROJECTOR(ARRANGEMENT.ID, SIMULATION.REF, NO.RESET, DATE.RANGE, TOT.PAYMENT, DUE.DATES, DUE.DEFER.DATES, DUE.TYPES, DUE.METHODS,DUE.TYPE.AMTS,DUE.PROPS, DUE.PROP.AMTS, DUE.OUTS)

        Y.INS.CNT = Y.CNT.NN - FLG
        LOOP
        WHILE Y.INS.CNT GT 0 DO
            Y.CN.VM += 1
            Y.PROP.TYPE = DUE.TYPES<Y.CN.VM>
            IF Y.PROP.TYPE EQ 'CONSTANTE' THEN
                Y.FIN.AMT += TOT.PAYMENT<Y.CN.VM>
            END
            Y.INS.CNT -= 1
        REPEAT
    END

RETURN

* PACS00126000 -E

END
