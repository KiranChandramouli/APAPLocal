$PACKAGE APAP.LAPAP
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE          WHO                 REFERENCE               DESCRIPTION
*13-07-2023    CONVERSION TOOL     R22 AUTO CONVERSION     TAM.BP and LAPAP.BP is removed
*13-07-2023    AJITHKUMAR S        R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE L.APAP.B.AC.NCF.CHREQ.LOAD
*
* Client Name : APAP
* Description: Routine to generate / issue the NCF for AC.CHARGE.REQUEST table
* Dev By : Ashokkumar
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.AC.CHARGE.REQUEST
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.REDO.NCF.ISSUED ;*R22 Auto code conversion
    $INSERT I_L.APAP.B.AC.NCF.CHREQ.COMMON



    GOSUB INIT
RETURN


INIT:
*****
    FN.AC.CHARGE.REQUEST = 'F.AC.CHARGE.REQUEST'; F.AC.CHARGE.REQUEST = ''
    CALL OPF(FN.AC.CHARGE.REQUEST,F.AC.CHARGE.REQUEST)
    FN.AC.CHARGE.REQUEST.H = 'F.AC.CHARGE.REQUEST$HIS'; F.AC.CHARGE.REQUEST.H = ''
    CALL OPF(FN.AC.CHARGE.REQUEST.H,F.AC.CHARGE.REQUEST.H)
    FN.STMT.ENTRY = 'F.STMT.ENTRY'; F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY,F.STMT.ENTRY)
    FN.REDO.NCF.ISSUED = 'F.REDO.NCF.ISSUED'; F.REDO.NCF.ISSUED = ''
    CALL OPF(FN.REDO.NCF.ISSUED,F.REDO.NCF.ISSUED)
    FN.REDO.L.NCF.STATUS = 'F.REDO.L.NCF.STATUS'; F.REDO.L.NCF.STATUS = ''
    CALL OPF(FN.REDO.L.NCF.STATUS,F.REDO.L.NCF.STATUS)
    FN.REDO.AA.NCF.IDS = 'F.REDO.AA.NCF.IDS'; F.REDO.AA.NCF.IDS = ''
    CALL OPF(FN.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS)
    FN.STMT.PRINTED = 'F.STMT.PRINTED'; F.STMT.PRINTED = ''
    CALL OPF(FN.STMT.PRINTED,F.STMT.PRINTED)
    FN.FT.COMMISSION.TYPE = 'F.FT.COMMISSION.TYPE'; F.FT.COMMISSION.TYPE = ''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
    FN.REDO.AA.NCF.IDS = 'F.REDO.AA.NCF.IDS'; F.REDO.AA.NCF.IDS = ''
    CALL OPF(FN.REDO.AA.NCF.IDS,F.REDO.AA.NCF.IDS)
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
    FN.PENDING.CHARGE = 'F.REDO.PENDING.CHARGE'; F.PENDING.CHARGE = ''
    CALL OPF(FN.PENDING.CHARGE,F.PENDING.CHARGE)
    FN.REDO.REPAYMENT.CHARGE = 'F.REDO.REPAYMENT.CHARGE'; F.REDO.REPAYMENT.CHARGE = ''
    CALL OPF(FN.REDO.REPAYMENT.CHARGE,F.REDO.REPAYMENT.CHARGE)
    YLSTDAY = R.DATES(EB.DAT.LAST.WORKING.DAY)

RETURN

END
