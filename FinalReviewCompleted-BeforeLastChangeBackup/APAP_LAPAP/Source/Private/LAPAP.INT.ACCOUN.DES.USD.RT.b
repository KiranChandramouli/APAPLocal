* @ValidationCode : MjoyMDQ0NDY5MTk1OkNwMTI1MjoxNjg0MjIyODEwNTIxOklUU1M6LTE6LTE6LTE0OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -14
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.INT.ACCOUN.DES.USD.RT
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE          WHO             REFERENCE               DESCRIPTION

* 21-APR-2023  Conversion tool   R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023    Narmadha V      R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.REDO.FT.TT.TRANSACTION ;*R22 Auto conversion - END

    GOSUB INIT
    GOSUB PROCESS
RETURN

*====
INIT:
*====
    Y.VERSION.NAME = APPLICATION:PGM.VERSION
    Y.APPLICATION = APPLICATION
    Y.OFS.BDY     = '' ;
    Y.INTERNAL.ACCT.NO          = "DOP1763500020017"
    Y.TRANSACTION.ID            = ID.NEW
RETURN

*=======
PROCESS:
*=======

    BEGIN CASE
        CASE Y.VERSION.NAME EQ 'REDO.FT.TT.TRANSACTION,L.APAP.TRANS.DOLARES' OR Y.VERSION.NAME EQ 'REDO.FT.TT.TRANSACTION,L.APAP.PART.TRANS.ACH.DOLARES'
            Y.INT.ACCOUNT                       = Y.INTERNAL.ACCT.NO
            R.NEW(FT.TN.CREDIT.ACCT.NO)         = Y.INT.ACCOUNT
        CASE 1
    END CASE

RETURN
END
