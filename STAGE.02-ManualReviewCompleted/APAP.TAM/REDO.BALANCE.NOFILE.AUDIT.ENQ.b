$PACKAGE APAP.TAM
SUBROUTINE REDO.BALANCE.NOFILE.AUDIT.ENQ(Y.ARRAY)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: RIYAS
* PROGRAM NAME: REDO.BALANCE.NOFILE.AUDIT.ENQ
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Routine for NOFILE enquiry to REDO.BALANCE.NOFILE.AUDIT.ENQ
* it fetches all prodcut for the customer
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*18.03.2010  H GANESH     ODR-2009-10-0838   INITIAL CREATION
** 21-04-2023 R22 Auto Conversion no changes
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*----------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.ARRANGEMENT
    GOSUB INIT
    GOSUB GET.VALUES
    GOSUB PROCESS
RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------

    Y.CUS.ID = ''
    FN.AA.ARRANGEMENT='F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT=''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)
RETURN
*----------------------------------------------------------------------
GET.VALUES:
*----------------------------------------------------------------------

    LOCATE 'CUSTOMER' IN D.FIELDS<1> SETTING Y.POS1 THEN
        Y.CUS.ID = FIELD(D.RANGE.AND.VALUE<Y.POS1>,'-',1)
    END
    LOCATE 'LETTER.TYPE' IN D.FIELDS<1> SETTING Y.POS2 THEN
        Y.LETTER.TYPE=FIELD(D.RANGE.AND.VALUE<Y.POS2>,'-',1)
    END
RETURN
*----------------------------------------------------------------------
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    IF Y.LETTER.TYPE EQ 'BALANCE' THEN
        SEL.CMD= 'SELECT ':FN.AA.ARRANGEMENT:' WITH CUSTOMER EQ ':Y.CUS.ID:' AND (ARR.STATUS EQ MATURED OR ARR.STATUS EQ EXPIRED)'
        CALL EB.READLIST(SEL.CMD,SEL.LIST,'',SEL.NOR,SEL.RET)
        LOOP
            REMOVE IN.ARR.ID FROM SEL.LIST SETTING Y.BAL.POS
        WHILE IN.ARR.ID:Y.BAL.POS
            CALL REDO.CONVERT.ACCOUNT(Y.ARR.ID,IN.ARR.ID,OUT.ID,ERR.TEXT)
            Y.ARRAY<-1> = OUT.ID
        REPEAT

    END
RETURN
***********************************************************************
