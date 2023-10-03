
* @ValidationCode : MjoxNzI2MjE5NzIwOkNwMTI1MjoxNjkzODI1MzM3MjkxOjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 04 Sep 2023 16:32:17
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

SUBROUTINE REDO.OUT.ACRQ.REF.NUM(Y.CARD.NUM.IN,RET.VAL)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S SUDHARSANAN
* PROGRAM NAME: REDO.OUT.ACRQ.REF.NUM
* ODR NO      : ODR-2010-08-0469
*----------------------------------------------------------------------
*DESCRIPTION: This routine is will be attached to INRF.MAPPING record to generate
*ARN(Acquired Reference number) for the transaction.Id logic to store in ATM.REVERSAL
*for acquirer transaction has been modified with cardnumber.ARN
*IN PARAMETER : N/A
*OUT PARAMETER: N/A
*CALLED BY :
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE                   DESCRIPTION
*15.09.2010  S SUDHARSANAN    ODR-2010-08-0469            INITIAL CREATION
*09.07.2012  Balagurunathan  PACS00204001 & PACS00203771
*13.04.2023  Conversion Tool       R22                     Auto Conversion     - = Y.DIGIT.COUNT+ TO +=, = Y.DIGIT.SUM+ TO +=
*13.04.2023  Shanmugapriya M       R22                     Manual Conversion   - No changes
*
*----------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ATM.PARAMETER
    $INSERT I_F.ATM.REVERSAL
    $INSERT I_AT.ISO.COMMON

    GOSUB OPEN.FILES
    GOSUB PROCESS


RETURN

*--------------
OPEN.FILES:
*--------------

    FN.ATM.REVERSAL='F.ATM.REVERSAL'
    F.ATM.REVERSAL=''
    CALL OPF(FN.ATM.REVERSAL,F.ATM.REVERSAL)

    FN.REDO.TXN.REJECT='F.REDO.TXN.REJECT'
    F.REDO.TXN.REJECT=''
    CALL OPF(FN.REDO.TXN.REJECT,F.REDO.TXN.REJECT)

RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    FN.ATM.PARAMETER = 'F.ATM.PARAMETER'
    CALL CACHE.READ(FN.ATM.PARAMETER,'SYSTEM',R.ATM.PARAM,ATM.ERR)
    VAR.BANK.IMD = R.ATM.PARAM<ATM.PARA.BANK.IMD>


    VAR.TERMINAL.ID = AT$INCOMING.ISO.REQ(41)
    VAR.TERMINAL.ID=VAR.TERMINAL.ID[4,5]
    VAR.TERMINAL.ID=TRIM(VAR.TERMINAL.ID)
    Y.TODAY=TODAY
    CALL JULDATE(Y.TODAY,JULIAN.DATE)
    YDDD=JULIAN.DATE[4,4]

    IF AT$INCOMING.ISO.REQ(3)[1,2] EQ '00' THEN

        Y.FIELD.VALUE =2

    END ELSE

        Y.FIELD.VALUE =7
    END


    Y.ACRQ.REF.NUM = Y.FIELD.VALUE:VAR.BANK.IMD:YDDD:VAR.TERMINAL.ID
    GOSUB GET.UNIQUE.ID
*MOD.VALUE = MOD(Y.ACRQ.REF.NUM,10)

*    Y.FIELD.VALUE= Y.ACRQ.REF.NUM:MOD.VALUE


RETURN
*-------------------------------------------------------------------------------
*-------------------------------------------------------------------*
GET.UNIQUE.ID:
*------------*

    R.ATM.REVERSAL=''
    LOOP.BRK=1
    LOOP
    WHILE LOOP.BRK
        CALL ALLOCATE.UNIQUE.TIME(UNIQUE.TIME)
        CHANGE '.' TO '' IN UNIQUE.TIME
        LEN.UNIQUE.TIME = LEN(UNIQUE.TIME) -6
        Y.UNIQUE.ID = UNIQUE.TIME[LEN.UNIQUE.TIME,6]


        Y.ACRQ.REF.NUM1=Y.ACRQ.REF.NUM:Y.UNIQUE.ID

        GOSUB GET.CHK.DIG

        RET.VAL=AT$INCOMING.ISO.REQ(2):'.':Y.ACRQ.REF.NUM1


        CALL F.READ(FN.ATM.REVERSAL,RET.VAL,R.ATM.REVERSAL,F.ATM.REVERSAL,ATM.ERR)
        CALL F.READ(FN.REDO.TXN.REJECT,RET.VAL,R.REDO.ATM.REJECT,F.REDO.TXN.REJECT,ATM.ERR1)
        IF R.ATM.REVERSAL EQ '' AND R.REDO.ATM.REJECT EQ '' THEN
            LOOP.BRK=0
        END
    REPEAT

RETURN          ;*From GET.UNIQUE.ID

*------------------------
GET.CHK.DIG:
*------------------------

    Y.BIN.SEQ=Y.ACRQ.REF.NUM1
    Y.CHECK.DIGIT = ""
    Y.SUM.CHK = ""
    Y.DIGIT.COUNT = 1
    Y.DIGIT.SUM =0
    Y.LEN.DIGIT = LEN(Y.BIN.SEQ)
    Y.CONTINUE.FLAG=1

    LOOP
    WHILE Y.DIGIT.COUNT LE Y.LEN.DIGIT

        Y.DIGIT = Y.BIN.SEQ[Y.DIGIT.COUNT,1]
        Y.EVEN.DIGIT = MOD(Y.DIGIT.COUNT,2)

        IF Y.EVEN.DIGIT EQ 0 THEN       ;* Check the odd digit and mu
            Y.DIGIT = Y.DIGIT*2
            IF Y.DIGIT GE 10 THEN
                Y.DIGIT.SUM = Y.DIGIT.SUM+Y.DIGIT[1,1]+Y.DIGIT[2,1]
                Y.DIGIT.COUNT += 1                           ;** R22 Auto conversion - = Y.DIGIT.COUNT+ TO +=
                Y.CONTINUE.FLAG=0
            END

        END
        IF Y.CONTINUE.FLAG THEN
            Y.DIGIT.SUM += Y.DIGIT            ;** R22 Auto conversion - = Y.DIGIT.SUM+ TO +=
            Y.DIGIT.COUNT += 1                ;** R22 Auto conversion - = Y.DIGIT.COUNT+ TO +=
        END
        Y.CONTINUE.FLAG=1
    REPEAT
    Y.QUOTIENT = INT(Y.DIGIT.SUM/10)
    Y.REM.DIGIT = MOD(Y.DIGIT.SUM,10)

    IF Y.REM.DIGIT THEN
        Y.CHECK.DIGIT = ((Y.QUOTIENT+1)*10) - Y.DIGIT.SUM
    END ELSE
        Y.CHECK.DIGIT = Y.DIGIT.SUM[2,1]
    END
* PACS00767760 - START
    SESSION.NO = C$T24.SESSION.NO
*    Y.ACRQ.REF.NUM1=Y.ACRQ.REF.NUM1:SESSION.NO:Y.CHECK.DIGIT
    Y.ACRQ.REF.NUM1=Y.ACRQ.REF.NUM1:Y.CHECK.DIGIT:SESSION.NO
*  Y.ACRQ.REF.NUM1=Y.ACRQ.REF.NUM1:Y.CHECK.DIGIT
* PACS00767760 - END
RETURN

END
