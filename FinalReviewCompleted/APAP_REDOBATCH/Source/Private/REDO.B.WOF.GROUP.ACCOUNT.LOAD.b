* @ValidationCode : Mjo1NDM2MjkzMjc6Q3AxMjUyOjE2ODQ4NTQ0MDI1MjE6SVRTUzotMTotMTozMDA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:42
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 300
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.WOF.GROUP.ACCOUNT.LOAD
*-----------------------------------------------------------------------------
* Company Name  : APAP DEV2
* Developed By  : Marimuthu S
* Program Name  : REDO.B.WOF.GROUP.ACCOUNT.LOAD
*-----------------------------------------------------------------
* Description : This routine used to raise the entry for group of aa loans
*-----------------------------------------------------------------
* Linked With   : -NA-
* In Parameter  : -NA-
* Out Parameter : -NA-
*-----------------------------------------------------------------
* Modification History :
*-----------------------
* Reference              Date                Description
* ODR-2011-12-0017    21-Nov-2011          Initial draft
* Date                   who                   Reference              
* 17-04-2023         CONVERSTION TOOL     R22 AUTO CONVERSTION - NO CHANGES
* 17-04-2023          ANIL KUMAR B        R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.WORK.INT.CAP.AMT
    $INSERT I_REDO.B.WOF.GROUP.ACCOUNT.COMMON

    FN.REDO.WORK.INT.CAP.AMT = 'F.REDO.WORK.INT.CAP.AMT'
    F.REDO.WORK.INT.CAP.AMT = ''
    CALL OPF(FN.REDO.WORK.INT.CAP.AMT,F.REDO.WORK.INT.CAP.AMT)

    FN.REDO.ACCT.MRKWOF.PARAMETER = 'F.REDO.ACCT.MRKWOF.PARAMETER'
    F.REDO.ACCT.MRKWOF.PARAMETER = ''
    CALL OPF(FN.REDO.ACCT.MRKWOF.PARAMETER,F.REDO.ACCT.MRKWOF.PARAMETER)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    CALL CACHE.READ(FN.REDO.ACCT.MRKWOF.PARAMETER,ID.COMPANY,R.REDO.ACCT.MRKWOF.PARAMETER,PAR.ERR)

    APP = 'ACCOUNT'
    LOC.FLD = 'L.LOAN.STATUS'
    LOC.FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APP, LOC.FLD, LOC.FLD.POS)
    L.LOAN.STATUS.POS = LOC.FLD.POS<1,1>

RETURN

END
