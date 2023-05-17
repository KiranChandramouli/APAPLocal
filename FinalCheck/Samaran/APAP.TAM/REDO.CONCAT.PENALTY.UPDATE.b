* @ValidationCode : MjotMTM2NzcyODAxMTpDcDEyNTI6MTY4MDY3OTE5OTQ4NzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 12:49:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.CONCAT.PENALTY.UPDATE
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : NA
* Deals With     : ACTIVITY.API
* Description    : This routine is to update the concat file REDO.CONCAT.PENALTY.CHARGE
*                  based on repayment of the bills.

*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                          DESCRIPTION
* 01-NOV-2011     H GANESH     ODR-2011-08-0106 CR-PENALTY CHARGE            Initial Draft.
** 05-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 05-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AA.LOCAL.COMMON
    $INSERT I_F.AA.ACCOUNT.DETAILS

    IF c_aalocActivityStatus EQ 'AUTH' OR c_aalocActivityStatus EQ 'AUTH-REV' THEN
        GOSUB OPENFILES
        GOSUB PROCESS
    END
RETURN
*------------------------------------------------------------------------
OPENFILES:
*------------------------------------------------------------------------
    FN.REDO.CONCAT.PENALTY.CHARGE = 'F.REDO.CONCAT.PENALTY.CHARGE'
    F.REDO.CONCAT.PENALTY.CHARGE = ''
    CALL OPF(FN.REDO.CONCAT.PENALTY.CHARGE,F.REDO.CONCAT.PENALTY.CHARGE)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
* Here we will get the Bills that are aged for that arrangement.

    R.REDO.CONCAT.PENALTY.CHARGE = ''
    ARR.ID = c_aalocArrId
    CALL F.READ(FN.REDO.CONCAT.PENALTY.CHARGE,ARR.ID,R.REDO.CONCAT.PENALTY.CHARGE,F.REDO.CONCAT.PENALTY.CHARGE,PEN.CHR.ERR)

    IF R.REDO.CONCAT.PENALTY.CHARGE ELSE
        RETURN
    END

    Y.BILL.IDS = R.REDO.CONCAT.PENALTY.CHARGE<2>    ;* List of Bill ids that are aged.

    CALL F.READ(FN.AA.ACCOUNT.DETAILS,ARR.ID,R.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS,ACC.DET.ERR)
    IF R.AA.ACCOUNT.DETAILS THEN
        Y.ALL.BILL.IDS  = R.AA.ACCOUNT.DETAILS<AA.AD.BILL.ID>
        Y.SETTLE.STATUS = R.AA.ACCOUNT.DETAILS<AA.AD.SET.STATUS>
        CHANGE @SM TO @FM IN Y.ALL.BILL.IDS
        CHANGE @VM TO @FM IN Y.ALL.BILL.IDS
        CHANGE @SM TO @FM IN Y.SETTLE.STATUS
        CHANGE @VM TO @FM IN Y.SETTLE.STATUS

        GOSUB CHECK.BILLS
    END
RETURN

*------------------------------------------------------------------------
CHECK.BILLS:
*------------------------------------------------------------------------
* Here will check the all the Bills.

    Y.FINAL.BILL.IDS = ''
    Y.BILLS.CNT = DCOUNT(Y.BILL.IDS,@VM)
    Y.VAR1=1
    LOOP
    WHILE Y.VAR1 LE Y.BILLS.CNT
        Y.BILL.ID = Y.BILL.IDS<1,Y.VAR1>
        LOCATE Y.BILL.ID IN Y.ALL.BILL.IDS SETTING BILL.POS THEN
            IF Y.SETTLE.STATUS<BILL.POS> EQ 'UNPAID' THEN
                Y.FINAL.BILL.IDS<-1> = Y.ALL.BILL.IDS<BILL.POS>
            END
        END

        Y.VAR1 += 1 ;* R22 Auto conversion
    REPEAT

    IF Y.FINAL.BILL.IDS THEN    ;*  If any one of the bill is unpaid then update the concat file as YES
        R.REDO.CONCAT.PENALTY.CHARGE<1> = 'YES'
        CALL F.WRITE(FN.REDO.CONCAT.PENALTY.CHARGE,ARR.ID,R.REDO.CONCAT.PENALTY.CHARGE)
    END ELSE          ;* If all bills has been repaid then update the concat file as NO.
        R.REDO.CONCAT.PENALTY.CHARGE<1> = 'NO'
        CALL F.WRITE(FN.REDO.CONCAT.PENALTY.CHARGE,ARR.ID,R.REDO.CONCAT.PENALTY.CHARGE)
    END
RETURN
END
