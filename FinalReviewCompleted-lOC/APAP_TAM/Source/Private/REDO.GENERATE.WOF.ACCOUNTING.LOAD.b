* @ValidationCode : MjotMTI0OTMxNDk2MjpDcDEyNTI6MTY4MDcxNTk4NTk5NzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 23:03:05
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
SUBROUTINE REDO.GENERATE.WOF.ACCOUNTING.LOAD

*DESCRIPTION:
*------------
* This is the COB routine for CR-43.
*
* This will process the selected Arrangement IDs from the REDO.UPDATE.NAB.HISTORY file with WOF eq 'TODAY'
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
* 06.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 06.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*-------------------------------------------------------------------------------------------------------------------
* All File INSERTS done here
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.GENERATE.WOF.ACCOUNTING.COMMON

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

    FN.REDO.AA.NAB.HISTORY = 'F.REDO.AA.NAB.HISTORY'
    F.REDO.AA.NAB.HISTORY = ''
    CALL OPF (FN.REDO.AA.NAB.HISTORY, F.REDO.AA.NAB.HISTORY)

    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF (FN.AA.ARRANGEMENT, F.AA.ARRANGEMENT)

    FN.REDO.WOF.ACCOUNTING = 'F.REDO.WOF.ACCOUNTING'
    F.REDO.WOF.ACCOUNTING  = ''
    CALL OPF (FN.REDO.WOF.ACCOUNTING, F.REDO.WOF.ACCOUNTING)

RETURN
*--------------------------------------------------------------------------------------------------------------------
*
*
END
