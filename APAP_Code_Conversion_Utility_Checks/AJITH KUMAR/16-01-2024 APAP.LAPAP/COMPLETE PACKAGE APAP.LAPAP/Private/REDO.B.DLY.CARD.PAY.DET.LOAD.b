$PACKAGE APAP.LAPAP
SUBROUTINE REDO.B.DLY.CARD.PAY.DET.LOAD

*******************************************************************************************
* Description: The REPORT to capture the vision plus transaction posted on last working day.
* Dev By:V.P.Ashokkumar
*
*******************************************************************************************
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*13-07-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,INSERT FILE MODIFIED
*13-07-2023              Samaran T                R22 Manual Code conversion                         No Changes
*-----------------------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.DATES
    $INSERT I_F.REDO.VISION.PLUS.TXN
    $INSERT I_F.REDO.H.REPORTS.PARAM
    $INSERT I_REDO.B.DLY.CARD.PAY.DET.COMMON ;*R22 AUTO CODE CONVERSION.END


    GOSUB INIT
    GOSUB LOC.REF.DET
RETURN

INIT:
******
    R.REDO.H.REPORTS.PARAM = ''; Y.PARAM.ERR = ''; F.CHK.DIR = ''
    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'; F.FUNDS.TRANSFER = ''
    FN.TELLER = 'F.TELLER'; F.TELLER = ''
    FN.FUNDS.TRANSFER.HST = 'F.FUNDS.TRANSFER$HIS'; F.FUNDS.TRANSFER.HST = ''
    FN.TELLER.HST = 'F.TELLER$HIS'; F.TELLER.HST = ''
    FN.REDO.VISION.PLUS.TXN = 'F.REDO.VISION.PLUS.TXN'; F.REDO.VISION.PLUS.TXN = ''
    FN.REDO.H.REPORTS.PARAM = 'F.REDO.H.REPORTS.PARAM'; F.REDO.H.REPORTS.PARAM = ''
    FN.DR.OPER.VPLUS.WORKFILE = 'F.DR.OPER.VPLUS.WORKFILE'; F.DR.OPER.VPLUS.WORKFILE = ''

    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)
    CALL OPF(FN.TELLER,F.TELLER)
    CALL OPF(FN.FUNDS.TRANSFER.HST,F.FUNDS.TRANSFER.HST)
    CALL OPF(FN.TELLER.HST,F.TELLER.HST)
    CALL OPF(FN.REDO.VISION.PLUS.TXN,F.REDO.VISION.PLUS.TXN)
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)
    CALL OPF(FN.DR.OPER.VPLUS.WORKFILE,F.DR.OPER.VPLUS.WORKFILE)
    YLWORK.DAY = R.DATES(EB.DAT.LAST.WORKING.DAY)
RETURN

LOC.REF.DET:
************
    YLC.FILE.NAME = 'FUNDS.TRANSFER':@FM:'TELLER'  ;*R22 AUTO CODE CONVERSION
    YLC.FIELD.NAME = 'L.INP.USER.ID':@FM:'L.INP.USER.ID' ;*R22 AUTO CODE CONVERSION
    CALL MULTI.GET.LOC.REF(YLC.FILE.NAME,YLC.FIELD.NAME,YLOC.POSN)
    L.FT.INP.USER.ID.POS = YLOC.POSN<1,1>
    L.TT.INP.USER.ID.POS = YLOC.POSN<2,1>
RETURN

END
