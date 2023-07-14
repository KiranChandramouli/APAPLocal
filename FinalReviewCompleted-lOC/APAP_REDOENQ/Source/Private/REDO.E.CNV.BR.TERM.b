$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.E.CNV.BR.TERM(ENQ.DATA)
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                  
* 10-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM ,SM to @SM
* 10-APRIL-2023      Harsha                R22 Manual Conversion - No changes                             
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.ATM.BRANCH
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
