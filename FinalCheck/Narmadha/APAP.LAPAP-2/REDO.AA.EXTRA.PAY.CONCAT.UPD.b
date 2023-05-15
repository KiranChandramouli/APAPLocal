* @ValidationCode : MjoxMDEzNjQ2MDY4OkNwMTI1MjoxNjgyMzE5MjA3MzM3OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 12:23:27
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
SUBROUTINE REDO.AA.EXTRA.PAY.CONCAT.UPD
*------------------------------------------------------------------------
* Description: This is routine to update the concat file to link the REDO.AA.OVERPAYMENT file with loan no for regulatory and SAP reports
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
* ----------------------
*   Date          Author              Modification Description
* 12-11-2015     V.P.Ashokkumar         Initial Release
*------------------------------------------------------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*24-04-2023       Conversion Tool        R22 Auto Code conversion          INSERT FILE MODIFIED
*24-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*-----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON   ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.AA.OVERPAYMENT     ;*R22 AUTO CODE CONVERSION.END


    GOSUB INIT
    GOSUB SEL.OVERPAY
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.REDO.AA.OVERPAYMENT = 'F.REDO.AA.OVERPAYMENT'; F.REDO.AA.OVERPAYMENT = ''
    CALL OPF(FN.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT)
    FN.REDO.AA.OVERPAY.CONCAT = 'F.REDO.AA.OVERPAY.CONCAT'; F.REDO.AA.OVERPAY.CONCAT = ''
    CALL OPF(FN.REDO.AA.OVERPAY.CONCAT,F.REDO.AA.OVERPAY.CONCAT)
    Y.TODAY = TODAY
    Y.LSTW.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
RETURN

SEL.OVERPAY:
************
    CALL EB.CLEAR.FILE(FN.REDO.AA.OVERPAY.CONCAT,F.REDO.AA.OVERPAY.CONCAT)
    SEL.CMD.OVER = '';  SEL.LSTOVER = ''; SEL.CNT = ''; SEL.ERR = ''
    SEL.CMD.OVER = "SELECT ":FN.REDO.AA.OVERPAYMENT:" WITH STATUS EQ 'PENDIENTE' OR (STATUS EQ 'APLICADO' AND NEXT.DUE.DATE GT ":Y.LSTW.DATE:" AND NEXT.DUE.DATE LE ":Y.TODAY:") BY LOAN.NO"
    CALL EB.READLIST(SEL.CMD.OVER,SEL.LSTOVER,'',SEL.CNT,SEL.ERR)
RETURN

PROCESS:
********
    LOOP
        OVERPAY.ID = ''
        REMOVE OVERPAY.ID FROM SEL.LSTOVER SETTING S.POSN
    WHILE OVERPAY.ID:S.POSN
        ERR.REDO.AA.OVERPAYMENT = ''; R.REDO.AA.OVERPAYMENT = ''
        CALL F.READ(FN.REDO.AA.OVERPAYMENT,OVERPAY.ID,R.REDO.AA.OVERPAYMENT,F.REDO.AA.OVERPAYMENT,ERR.REDO.AA.OVERPAYMENT)
        Y.LOAN.NO = ''; Y.AMT = ''
        Y.LOAN.NO = R.REDO.AA.OVERPAYMENT<REDO.OVER.LOAN.NO>
        Y.AMT = R.REDO.AA.OVERPAYMENT<REDO.OVER.AMOUNT>

        ERR.REDO.AA.OVERPAY.CONCAT = ''; R.REDO.AA.OVERPAY.CONCAT = ''
        CALL F.READ(FN.REDO.AA.OVERPAY.CONCAT,Y.LOAN.NO,R.REDO.AA.OVERPAY.CONCAT,F.REDO.AA.OVERPAY.CONCAT,ERR.REDO.AA.OVERPAY.CONCAT)
        IF R.REDO.AA.OVERPAY.CONCAT THEN
            R.REDO.AA.OVERPAY.CONCAT<-1> = OVERPAY.ID
        END ELSE
            R.REDO.AA.OVERPAY.CONCAT = OVERPAY.ID
        END
        WRITE R.REDO.AA.OVERPAY.CONCAT TO F.REDO.AA.OVERPAY.CONCAT,Y.LOAN.NO ON ERROR NULL
    REPEAT
RETURN
END
