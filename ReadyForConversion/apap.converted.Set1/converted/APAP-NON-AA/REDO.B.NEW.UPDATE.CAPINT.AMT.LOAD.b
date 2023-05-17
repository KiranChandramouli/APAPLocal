SUBROUTINE REDO.B.NEW.UPDATE.CAPINT.AMT.LOAD
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.NEW.UPDATE.CAPINT.AMT.LOAD

*-----------------------------------------------------------------
* Description :
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017   23-Oct-2012            Wof Accounting - PACS00202156
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.ACCT.MRKWOF.HIST
    $INSERT I_F.REDO.NEW.WORK.INT.CAP.OS
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.STMT.ENTRY
    $INSERT I_F.REDO.ACCT.MRKWOF.PARAMETER
    $INSERT I_F.COMPANY
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.AA.INT.CLASSIFICATION
    $INSERT I_REDO.B.NEW.UPDATE.CAPINT.AMT

MAIN:

    GOSUB OPENFILES
    GOSUB PGM.END

OPENFILES:

    FN.REDO.ACCT.MRKWOF.HIST = 'F.REDO.ACCT.MRKWOF.HIST'
    F.REDO.ACCT.MRKWOF.HIST = ''
    CALL OPF(FN.REDO.ACCT.MRKWOF.HIST,F.REDO.ACCT.MRKWOF.HIST)

    FN.REDO.NEW.WORK.INT.CAP.OS = 'F.REDO.NEW.WORK.INT.CAP.OS'
    F.REDO.NEW.WORK.INT.CAP.OS = ''
    CALL OPF(FN.REDO.NEW.WORK.INT.CAP.OS,F.REDO.NEW.WORK.INT.CAP.OS)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.AA.INT.CLASSIFICATION = 'F.REDO.AA.INT.CLASSIFICATION'
    F.REDO.AA.INT.CLASSIFICATION = ''

    FN.REDO.CONCAT.ACC.WOF = 'F.REDO.CONCAT.ACC.WOF'
    F.REDO.CONCAT.ACC.WOF = ''
    CALL OPF(FN.REDO.CONCAT.ACC.WOF,F.REDO.CONCAT.ACC.WOF)

    CALL CACHE.READ(FN.REDO.AA.INT.CLASSIFICATION,'SYSTEM',R.REDO.AA.INT.CLASSIFICATION,INT.ERR)

RETURN

PGM.END:

END
