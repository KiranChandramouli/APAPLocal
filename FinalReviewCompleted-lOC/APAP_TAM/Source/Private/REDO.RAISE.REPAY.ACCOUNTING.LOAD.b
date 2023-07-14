* @ValidationCode : Mjo4NzY5NDc1ODc6Q3AxMjUyOjE2ODEwNTY0ODQ5MzI6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 09 Apr 2023 21:38:04
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
SUBROUTINE REDO.RAISE.REPAY.ACCOUNTING.LOAD

*DESCRIPTION:
*------------
* This is the COB routine for CR-41.
*
* This will process the selected IDs from the REDO.NAB.ACCOUNTING file.
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
* 05 Dec 2011    Ravikiran AV              CR.41                 Initial Creation
* 10.04.2023     Conversion Tool           R22                   Auto Conversion     - No changes
* 10.04.2023     Shanmugapriya M           R22                   Manual Conversion   - No changes
*
*-------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.RAISE.REPAY.ACCOUNTING.COMMON

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

    FN.REDO.REPAID.INT = 'F.REDO.REPAID.INT'
    F.REDO.REPAID.INT = ''
    CALL OPF (FN.REDO.REPAID.INT, F.REDO.REPAID.INT)

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
