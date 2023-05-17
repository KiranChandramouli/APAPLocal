SUBROUTINE REDO.CUS.AA.ARR2.RTN(ENQ.DATA)
*
*
*--------------------------------------------------------------------------
* This routine fetches the Collateral IDs for the arrangement Specified
*
*---------------------------------------------------------------------------------------------------------
*
* Modification History
*
*2011-10-27 ejijon@temenos.com
*---------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.APAP.H.INSURANCE.DETAILS
    $INSERT I_B02.COMMON

*---------------------------------------------------------------------------------------------------------
MAIN.LOGIC:
    GOSUB INITIALISE
    GOSUB PROCESS

RETURN
*---------------------------------------------------------------------------------------------------------
INITIALISE:
    FN.AA.ARR = 'F.AA.ARRANGEMENT'
    F.AA.ARR = ''
    R.AA.ARR = ''

    CALL OPF (FN.AA.ARR, F.AA.ARR)

RETURN
*---------------------------------------------------------------------------------------------------------
PROCESS:

*IF ISDIGIT(D.RANGE.AND.VALUE<1>) THEN
*   RESERVED(1) = D.RANGE.AND.VALUE<1>
*END
*
*LOCATE "CUS.ID" IN D.FIELDS<1> SETTING Y.POS.ID THEN
*   Y.CUS = D.RANGE.AND.VALUE<Y.POS.ID>
*END
*
*IF ISDIGIT(Y.CUS) THEN
*   *Y.AA = RESERVED(1)
*END ELSE
*   Y.CUS = RESERVED(1)
*END


    Y.TOT.CUS = DCOUNT(COMM.CUS,@VM)

    FOR I.VAR=1 TO Y.TOT.CUS
        Y.CUS = COMM.CUS<1,I.VAR>
        SEL.CMD = 'SELECT ' : FN.AA.ARR : ' WITH CUSTOMER EQ ': Y.CUS
        CALL EB.READLIST(SEL.CMD,Y.LIST,'',NO.OF.REG,RET.CODE)
        LOOP
            REMOVE Y.AA.ID FROM Y.LIST SETTING POS
        WHILE Y.AA.ID:POS
            CALL F.READ(FN.AA.ARR,Y.AA.ID,R.AA.ARR,F.AA.ARR,Y.ERR)
            ENQ.DATA<-1> = Y.AA.ID: '*' : R.AA.ARR<AA.ARR.LINKED.APPL.ID>: '*' :R.AA.ARR<AA.ARR.CUSTOMER>
        REPEAT

    NEXT I.VAR
*ENQ.DATA = Y.LIST


RETURN
*---------------------------------------------------------------------------------------------------------
END
