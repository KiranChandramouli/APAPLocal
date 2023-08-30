* @ValidationCode : MjoxNTc0MTk0NDU5OkNwMTI1MjoxNjg4NTM2NDUwMzE4OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Jul 2023 11:24:10
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
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.BR.TERM(ENQ.DATA)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM ,SM to @SM
* 10-APRIL-2023      Harsha                R22 Manual Conversion - Insert file modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
*$INSERT I_F.ATM.BRANCH ;*R22 MANUAL CONVERSION
    $INSERT I_F.COMPANY

    GOSUB OPENFILES
    GOSUB PROCESS

RETURN

*---------
OPENFILES:
*---------
    FN.ATM.BRANCH='F.ATM.BRANCH'
    F.ATM.BRANCH=''
    CALL OPF(FN.ATM.BRANCH,F.ATM.BRANCH)

RETURN
PROCESS:

    LOCATE 'TERM.ID' IN ENQ.DATA<2,1> SETTING POS1 THEN
        Y.ATM.BRANCH.ID=ENQ.DATA<4,POS1>
        CALL F.READ(FN.ATM.BRANCH,Y.ATM.BRANCH.ID<1,1>,R.ATM.BRANCH,F.ATM.BRANCH,ERR)
        IF NOT(R.ATM.BRANCH) THEN
            SEL.DATA.CAP="SELECT ":FN.ATM.BRANCH:" WITH COMPANY.CODE EQ ":Y.ATM.BRANCH.ID
            CALL EB.READLIST(SEL.DATA.CAP,SEL.LIST,'',NO.OF.REC,DATA.ERR)
            IF SEL.LIST THEN
                CHANGE @FM TO @SM IN SEL.LIST
                ENQ.DATA<4,POS1>=SEL.LIST
            END
        END
    END
RETURN
END
