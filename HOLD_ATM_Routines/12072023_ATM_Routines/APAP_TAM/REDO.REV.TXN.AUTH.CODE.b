SUBROUTINE REDO.REV.TXN.AUTH.CODE(Y.CARD.NUM.IN,RET.VAL)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: BALAGURUNATHAN B
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
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AT.ISO.COMMON

    GOSUB PROCESS

RETURN

PROCESS:

    IF Y.ATM.TXN.REF EQ '' OR  Y.ATM.TXN.REF EQ 0 THEN


        Y.CARD.NUM=FIELD(Y.CARD.NUM.IN,'%',1)
        Y.TXN.AUTH.CODE=FIELD(Y.CARD.NUM.IN,'%',2)
        RET.VAL=Y.CARD.NUM:'.':Y.TXN.AUTH.CODE

    END ELSE

        RET.VAL=Y.ATM.TXN.REF
    END
RETURN

END
