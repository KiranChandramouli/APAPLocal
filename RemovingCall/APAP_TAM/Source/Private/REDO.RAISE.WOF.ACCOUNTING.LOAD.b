* @ValidationCode : MjotMzA3OTI5Mjc5OkNwMTI1MjoxNjgyNTI4NDcxNDM2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 26 Apr 2023 22:31:11
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
SUBROUTINE REDO.RAISE.WOF.ACCOUNTING.LOAD

*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will process the selected IDs from the REDO.WOF.ACCOUNTING file.
* This will raise a Consolidated Accounting Entry for NAB Contracts
*
* Input/Output:
*--------------
* IN : -NA-
* OUT : -NA-
*---------------
*-----------------------------------------------------------------------------------------------------------------
* Modification History :
*   Date            Who                   Reference               Description
*   ------         ------               -------------            -------------
* 26 Feb 2012    Ravikiran AV              CR.43                 Initial Creation
*
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*13/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*13/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.RAISE.WOF.ACCOUNTING.COMMON

*------------------------------------------------------------------------------------------------------------------
*
*
MAIN:

    GOSUB OPEN.FILES

RETURN
*--------------------------------------------------------------------------------------------------------------------
*
*
OPEN.FILES:

    FN.REDO.WOF.ACCOUNTING = 'F.REDO.WOF.ACCOUNTING'
    F.REDO.WOF.ACCOUNTING = ''
    CALL OPF (FN.REDO.WOF.ACCOUNTING, F.REDO.WOF.ACCOUNTING)

    FN.REDO.AA.INT.CLASSIFICATION = 'F.REDO.AA.INT.CLASSIFICATION'
    F.REDO.AA.INT.CLASSIFICATION = ''
    CALL OPF(FN.REDO.AA.INT.CLASSIFICATION, F.REDO.AA.INT.CLASSIFICATION)

    FN.REDO.AA.NAB.HISTORY = 'F.REDO.AA.NAB.HISTORY'
    F.REDO.AA.NAB.HISTORY = ''
    CALL OPF(FN.REDO.AA.NAB.HISTORY, F.REDO.AA.NAB.HISTORY)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT, F.ACCOUNT)

    APP = 'ACCOUNT'
    LOC.FLD = 'L.LOAN.STATUS'
    LOC.FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APP, LOC.FLD, LOC.FLD.POS)
    L.LOAN.STATUS.POS = LOC.FLD.POS<1,1>

RETURN
*--------------------------------------------------------------------------------------------------------------------
*
*
END
