* @ValidationCode : MjotNDg5MDUxODA4OkNwMTI1MjoxNjgxMTEyMDI1NDM0OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 10 Apr 2023 13:03:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*10/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION           SM TO @SM,FM TO @FM
*10/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.GET.COLLATERAL.ID(ENQ.DATA)
*
*
*--------------------------------------------------------------------------
* This routine fetches the Collateral IDs for the arrangement Specified
*
*---------------------------------------------------------------------------------------------------------
*
* Modification History
*
*
*---------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.TERM.AMOUNT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS

*---------------------------------------------------------------------------------------------------------
MAIN.LOGIC:
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*---------------------------------------------------------------------------------------------------------
INITIALISE:
    FN.AA.ARR.TERM.AMOUNT = 'F.AA.ARR.TERM.AMOUNT'
    F.AA.ARR.TERM.AMOUNT = ''
    R.AA.ARR.TERM.AMOUNT = ''

    CALL OPF (FN.AA.ARR.TERM.AMOUNT, F.AA.ARR.TERM.AMOUNT)

    CALL MULTI.GET.LOC.REF("AA.ARR.TERM.AMOUNT","L.AA.COL",LOC.REF.POS)
    Y.L.AA.COL = LOC.REF.POS<1,1>

RETURN

*---------------------------------------------------------------------------------------------------------
PROCESS:

    IF LEN(D.RANGE.AND.VALUE<1>) EQ 12 THEN
        RESERVED(2) = D.RANGE.AND.VALUE<1>
    END

    LOCATE "AA.ID" IN D.FIELDS<1> SETTING Y.POS.ID THEN
        Y.AA = D.RANGE.AND.VALUE<Y.POS.ID>
    END

    IF LEN(Y.AA) NE 12 THEN
        Y.AA = RESERVED(2)
    END

    SEL.CMD = 'SELECT ' : FN.AA.ARR.TERM.AMOUNT : ' WITH ID.COMP.1 EQ ': Y.AA
    CALL EB.READLIST(SEL.CMD,Y.LIST,'',NO.OF.REG,RET.CODE)
    LOOP
        REMOVE Y.AA.TERM FROM Y.LIST SETTING POS
    WHILE Y.AA.TERM:POS
        CALL F.READ(FN.AA.ARR.TERM.AMOUNT,Y.AA.TERM,R.AA.TERM,F.AA.ARR.TERM.AMOUNT,Y.ERR)
        Y.COL.ID = R.AA.TERM<AA.AMT.LOCAL.REF,Y.L.AA.COL>
        CHANGE @SM TO @FM IN Y.COL.ID
        ENQ.DATA = Y.COL.ID
    REPEAT


RETURN
*---------------------------------------------------------------------------------------------------------
END
