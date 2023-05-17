*-----------------------------------------------------------------------------
* <Rating>-23</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.CHK.DEBIT.CARD.NUMBER
**************************************************************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Ganesh R
* PROGRAM NAME: REDO.CHK.DEBIT.CARD.NUMBER
* ODR NO      : ODR-2011-03-0150
*-----------------------------------------------------------------------------------------------------
*DESCRIPTION: This routine is to get the card number and check whether it is Valid or not.
*******************************************************************************************************
*linked with :
*In parameter:
*Out parameter:
*****************************************************************************************************
*Modification History
*  Date       Who                 Reference           Description
* 20 jan 2012 Ganesh R            ODR-2011-03-0150    Will Raise the Error message
* 10 MAY 2013 Vignesh Kumaar R    PACS00251021        DO NOT ALLOW REUSE THE AUTHORIZATION OF POS
* 24 AUG 2017 PACS00618031 Authorization issue
*-------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_GTS.COMMON
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_F.REDO.CARD.BIN
    $INSERT I_REDO.DEBIT.CARD.COMMON
    $INSERT I_System

    IF OFS$HOT.FIELD EQ 'L.TT.CR.CARD.NO' THEN
        GOSUB OPEN.FILES
        GOSUB PROCESS
    END
    RETURN

OPEN.FILES:
    FN.ATM.REVERSAL = 'F.ATM.REVERSAL'
    F.ATM.REVERSAL  = ''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.FUNDS.TRANSFER = 'F.FUNDS.TRANSFER'
    F.FUNDS.TRANSFER = ''
    CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

    FN.REDO.CARD.BIN = 'F.REDO.CARD.BIN'
    F.REDO.CARD.BIN = ''
    CALL OPF(FN.REDO.CARD.BIN,F.REDO.CARD.BIN)

    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)

    RETURN

PROCESS:
*Get the card number
    LOC.APPLICATION = 'TELLER'
    LOC.FIELDS      = 'L.TT.CR.CARD.NO':VM:'L.TT.CR.ACCT.NO'
    LOC.POS         = ''
    CALL MULTI.GET.LOC.REF(LOC.APPLICATION,LOC.FIELDS,LOC.POS)
    YL.TT.CR.ACCT.NO = LOC.POS<1,2>

    PRIN.CARD.NO = COMI
    Y.VALID = ''
    Y.BIN  = PRIN.CARD.NO[1,6]
    CALL F.READ(FN.REDO.CARD.BIN,Y.BIN,R.REDO.CARD.BIN,F.REDO.CARD.BIN,Y.ERR)
    Y.Y.CARD.NUMBER.PRI = R.REDO.CARD.BIN<REDO.CARD.BIN.CARD.TYPE>
    Y.COUNT = DCOUNT(Y.Y.CARD.NUMBER.PRI,VM)
    TEMP.VAR = COMI

    R.NEW(TT.TE.LOCAL.REF)<1,YL.TT.CR.ACCT.NO> = PRIN.CARD.NO
* Fix for PACS00251021 [DO NOT ALLOW REUSE THE AUTHORIZATION OF POS]

    CALL System.setVariable("CURRENT.CARD.NUM",COMI)

* End of Fix

    Y.FIRST.PART  = Y.BIN
    Y.SECOND.PART = '******'
    Y.THIRD.PART  = PRIN.CARD.NO[13,4]
    Y.MASK.CARD.NUM = Y.FIRST.PART:Y.SECOND.PART:Y.THIRD.PART
    COMI = Y.MASK.CARD.NUM
    Y.CNT =1
    LOOP
    WHILE Y.CNT LE Y.COUNT
        Y.Y.CARD.NUMBER.PRIMARY = Y.Y.CARD.NUMBER.PRI<1,Y.CNT>
        Y.PRIMARY = Y.Y.CARD.NUMBER.PRIMARY:'.':PRIN.CARD.NO
        CALL F.READ(FN.LATAM.CARD.ORDER,Y.PRIMARY,R.LATAM.CARD.ORDER.PRI,F.LATAM.CARD.ORDER,LATAM.ERR)
        IF R.LATAM.CARD.ORDER.PRI THEN
            Y.VALID = 1
            RETURN
        END
        Y.CNT = Y.CNT + 1
    REPEAT
    IF NOT(Y.VALID) THEN
        ETEXT = "ST-INVALID.CARD.NUM"
        CALL STORE.END.ERROR
    END
    RETURN
