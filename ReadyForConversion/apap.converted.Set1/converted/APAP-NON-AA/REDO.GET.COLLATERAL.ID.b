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
