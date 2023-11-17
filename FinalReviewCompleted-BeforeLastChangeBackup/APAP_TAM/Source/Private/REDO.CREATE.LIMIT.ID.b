* @ValidationCode : MjotMTE3MDMyNjY2MzpDcDEyNTI6MTY4MDY4MDYwNzcwMzpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 13:13:27
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

** 06-04-2023 R22 Auto Conversion - FM TO @FM
** 06-04-2023 Skanda R22 Manual Conversion - No changes

$PACKAGE APAP.TAM
SUBROUTINE REDO.CREATE.LIMIT.ID
*---------------------------------------------------
*Description: This routine is to restrict the creation of
*             more than one child limit per parent.
*---------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.LIMIT


    GOSUB OPEN.FILES
    GOSUB PROCESS
RETURN
*----------------------------------------------------
OPEN.FILES:
*----------------------------------------------------

    FN.LIMIT = 'F.LIMIT'
    F.LIMIT  = ''
    CALL OPF(FN.LIMIT,F.LIMIT)

RETURN
*----------------------------------------------------
PROCESS:
*----------------------------------------------------
    Y.LIMIT.ID = COMI
    Y.LIMIT.ID =  FIELD(Y.LIMIT.ID,".",1):'.':FMT(FIELD(Y.LIMIT.ID,'.',2),"7'0'R"):'.':FMT(FIELD(Y.LIMIT.ID,'.',3),"2'0'R")
    CALL F.READ(FN.LIMIT,Y.LIMIT.ID,R.LIMIT,F.LIMIT,LIMIT.ERR)
    IF R.LIMIT THEN
        RETURN
    END
    GOSUB CHEC.IF.PARENT
    IF Y.PARENT.FLAG EQ 'YES' THEN
        RETURN
    END
    SEL.CMD = "SELECT ":FN.LIMIT:" WITH @ID NE ":Y.LIMIT.ID:" AND @ID NE ":Y.PARENT.ID:" AND @ID LIKE ":Y.CUS.ID:".":Y.LIMIT.PRODUCT[1,LEN(Y.LIMIT.PRODUCT)-2]:"...":Y.SEQ.NO
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
    IF SEL.LIST THEN
        E = 'EB-REDO.CHILD.EXIST':@FM:SEL.LIST
    END
RETURN
*----------------------------------------------------
CHEC.IF.PARENT:
*----------------------------------------------------

    Y.PARENT.FLAG = ''
    Y.CUS.ID = FIELD(Y.LIMIT.ID,".",1)
    Y.SEQ.NO = FIELD(Y.LIMIT.ID,".",3)
    Y.LIMIT.PRODUCT = FIELD(Y.LIMIT.ID,".",2)
    Y.LAST.PART = Y.LIMIT.PRODUCT[LEN(Y.LIMIT.PRODUCT)-1,2]
    IF Y.LAST.PART EQ "00" THEN
        Y.PARENT.FLAG = 'YES'
    END

    Y.PARENT.ID       = Y.CUS.ID:".":Y.LIMIT.PRODUCT[1,LEN(Y.LIMIT.PRODUCT)-2]:"00":".":Y.SEQ.NO

RETURN
END
