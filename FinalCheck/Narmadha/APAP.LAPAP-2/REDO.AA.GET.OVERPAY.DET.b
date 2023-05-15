* @ValidationCode : MjoxMzYzMjYxNTI4OkNwMTI1MjoxNjgyMzE5MzQ0MDcwOnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 12:25:44
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
$PACKAGE APAP.LAPAP
SUBROUTINE REDO.AA.GET.OVERPAY.DET(LOAN.ID,RECORD.VAL)
*--------------------------------------------------------------------------------------------------
*  M O D I F I C A T I O N S
* ***************************
*--------------------------------------------------------------------------------------------------
* Defect Reference       Modified By                    Date of Change        Change Details
*
*                       Ashokkumar.V.P                  12/11/2015
*--------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED,FM TO @FM
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*----------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.REDO.AA.OVERPAYMENT    ;*R22 AUTO CODE CONVERSION.END

    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    RECORD.VAL = ''; OVERPAY.ID = ''; TOT.AMT = 0
    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'; F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)
    FN.REDO.AA.OVERPAY.CONCAT = 'F.REDO.AA.OVERPAY.CONCAT'; F.REDO.AA.OVERPAY.CONCAT = ''
    CALL OPF(FN.REDO.AA.OVERPAY.CONCAT,F.REDO.AA.OVERPAY.CONCAT)
    Y.TODAY = TODAY
    Y.LSTW.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
RETURN

PROCESS:
********
    ERR.REDO.AA.OVERPAY.CONCAT = ''; R.REDO.AA.OVERPAY.CONCAT = ''; Y.REC.CNT = 0
    CALL F.READ(FN.REDO.AA.OVERPAY.CONCAT,LOAN.ID,R.REDO.AA.OVERPAY.CONCAT,F.REDO.AA.OVERPAY.CONCAT,ERR.REDO.AA.OVERPAY.CONCAT)
    IF NOT(R.REDO.AA.OVERPAY.CONCAT) THEN
        RETURN
    END
    YREC.CNT = DCOUNT(R.REDO.AA.OVERPAY.CONCAT,@FM)
    IF YREC.CNT EQ 1 THEN
        OVERPAY.ID = R.REDO.AA.OVERPAY.CONCAT
        GOSUB READ.AA.OVERPAY
        TOT.AMT = YOVERPAY.AMT
    END ELSE
        GOSUB GET.OVERPAY.LOOP
    END
    RECORD.VAL = TOT.AMT
RETURN

READ.AA.OVERPAY:
****************
    ERR.REDO.AA.OVERPAYMENT = ''; R.REDO.AA.OVERPAYMENT = ''; YOVERPAY.AMT = 0; YSTATUS = ''
    CALL F.READ(FN.REDO.AA.OVERPAYMENT,OVERPAY.ID,R.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT,ERR.REDO.AA.OVERPAYMENT)
    YOVERPAY.AMT = R.REDO.AA.OVERPAYMENT<REDO.OVER.AMOUNT>
    YSTATUS  = R.REDO.AA.OVERPAYMENT<REDO.OVER.STATUS>
RETURN

GET.OVERPAY.LOOP:
****************
    LOOP
        REMOVE OVERPAY.ID FROM R.REDO.AA.OVERPAY.CONCAT SETTING OVER.POSN
    WHILE OVERPAY.ID:OVER.POSN

        GOSUB READ.AA.OVERPAY
        IF YSTATUS NE 'REVERSADO' THEN
            TOT.AMT += YOVERPAY.AMT
        END
    REPEAT
RETURN
END
