* @ValidationCode : MjotMTIwMzg5MDM2NzpDcDEyNTI6MTY4MTI4MTk2NjA2NzpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 12:16:06
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
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
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
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
