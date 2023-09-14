* @ValidationCode : MjoxNjE5NTUzMzk4OkNwMTI1MjoxNjgxNzI3NDc2MzU5OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 16:01:16
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
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*17/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*17/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_AT.ISO.COMMON ;*AUTO R22 CODE CONVERSION
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
