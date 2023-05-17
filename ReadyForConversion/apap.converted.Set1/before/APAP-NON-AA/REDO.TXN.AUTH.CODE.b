*-----------------------------------------------------------------------------
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
    SUBROUTINE REDO.TXN.AUTH.CODE(Y.CARD.NUM.IN,RET.VAL)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.TXN.AUTH.CODE
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION:  This routine is to create the authorisation code for the
* transaction and concat it with card number



*IN PARAMETER: NA
*OUT PARAMETER: NA
*LINKED WITH: ATM
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*09.12.2010  H GANESH     ODR-2010-08-0469    INITIAL CREATION
*19 JUL 2011 Balagurunathan ODR-2010-08-0469  Auth Code possition change
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT ATM.BP I_AT.ISO.COMMON
    GOSUB PROCESS
    RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


    FN.ATM.REVERSAL='F.ATM.REVERSAL'
    F.ATM.REVERSAL=''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)
    FN.REDO.TXN.REJECT='F.REDO.TXN.REJECT'
    F.REDO.TXN.REJECT=''
    CALL OPF(FN.REDO.TXN.REJECT,F.REDO.TXN.REJECT)

    Y.CARD.NUM=FIELD(Y.CARD.NUM.IN,'%',1)
    CARD.NUM=Y.CARD.NUM

    R.ATM.REVERSAL=''
    LOOP
        WHILE(1)
        Y.APPL=APPLICATION
        APPLICATION='REDO.AUTH.CODE'
        APP.PREFIX='ATM'
        CALL UNIQUE.ID(RETURN.REFERENCE,APP.PREFIX)
        APPLICATION=Y.APPL
        RET.VAL=CARD.NUM:'.':RETURN.REFERENCE[9,6]
        CALL F.READ(FN.ATM.REVERSAL,RET.VAL,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)
        CALL F.READ(FN.REDO.TXN.REJECT,RET.VAL,R.REDO.ATM.REJECT,F.REDO.TXN.REJECT,ATM.ERR1)
        IF R.ATM.REVERSAL EQ '' AND R.REDO.ATM.REJECT EQ '' THEN
            UNIQUE.ID=RETURN.REFERENCE[9,6]
            BREAK
        END
    REPEAT

    RETURN
END
