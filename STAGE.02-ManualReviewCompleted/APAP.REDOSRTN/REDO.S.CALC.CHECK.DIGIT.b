* @ValidationCode : MjoyMTAyOTY3MDY6Q3AxMjUyOjE2ODA3NzU1NjIxMTE6OTE2Mzg6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:36:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 91638
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOSRTN
SUBROUTINE REDO.S.CALC.CHECK.DIGIT(Y.CHECK.DIGIT)
*******************************************************************************************************************
*Company   Name    : Asociaciopular de Ahorros y Pramos Bank
*Developed By      : P.ANAND(anandp@temenos.com)
*Date     : 26.10.2009
*Program   Name    : REDO.S.CALC.CHECK.DIGIT
*------------------------------------------------------------------------------------------------------------------
*Description       : This routine is to verify the check digit of the input number
*Linked With       : REDO.V.VAL.CED.IDENT,REDO.V.VAL.NO.UNICO,REDO.V.VAL.RNC
*In  Parameter     : Y.CHECK.DIGIT
*Out Parameter     : Y.CHECK.DIGIT
*------------------------------------------------------------------------------------------------------------------
*Modification Details:
* Name               Ref.ID            Date               Description
*Sudharsanan S     PACS00054288       25-04-2011      Check the Modular value if equal to '0'
*Modification history
*Date                Who               Reference                  Description
*06-04-2023      conversion tool     R22 Auto code conversion     No changes
*06-04-2023      Mohanraj R          R22 Manual code conversion   No changes

*------------------------------------------------------------------------------------------------------------------
    GOSUB INIT
    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------------------------------------------------
INIT:
*****
    VAL.CHECK = Y.CHECK.DIGIT[11,1]
    Y.INPUT.NUM = Y.CHECK.DIGIT[1,10]
RETURN
*------------------------------------------------------------------------------------------------------------------
PROCESS:
********
* The last digit of input indicates the check digit number that requires checking
* multiply the least significant digit with 2 and the next digit with 1 and again the next digit with 2
* and again the next digit with 1 and so on till the most significant digit
* Then add the digits of each multiplication products
* Then add all the multiplication products after the above step
* Use a modulo 10 on the summation note the reminder
* Subtract the reminder from 10, and the result should match the check digit verifier
* If it is equal then the check digit is verified. Else the check digit verification has failed
    VAR.FIRST.DIGIT = Y.INPUT.NUM[1,1] * 1
    IF VAR.FIRST.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.FIRST.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.FIRST.DIGIT[2,1]
        VAR.FIRST.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.SECOND.DIGIT = Y.INPUT.NUM[2,1] * 2
    IF VAR.SECOND.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.SECOND.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.SECOND.DIGIT[2,1]
        VAR.SECOND.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.THIRD.DIGIT = Y.INPUT.NUM[3,1] * 1
    IF VAR.THIRD.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.THIRD.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.THIRD.DIGIT[2,1]
        VAR.THIRD.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.FOURTH.DIGIT = Y.INPUT.NUM[4,1] * 2
    IF VAR.FOURTH.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.FOURTH.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.FOURTH.DIGIT[2,1]
        VAR.FOURTH.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.FIFITH.DIGIT = Y.INPUT.NUM[5,1] * 1
    IF VAR.FIFITH.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.FIFITH.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.FIFITH.DIGIT[2,1]
        VAR.FIFITH.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.SIXTH.DIGIT = Y.INPUT.NUM[6,1] * 2
    IF VAR.SIXTH.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.SIXTH.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.SIXTH.DIGIT[2,1]
        VAR.SIXTH.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.SEVENTH.DIGIT = Y.INPUT.NUM[7,1] * 1
    IF VAR.SEVENTH.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.SEVENTH.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.SEVENTH.DIGIT[2,1]
        VAR.SEVENTH.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.EIGHT.DIGIT = Y.INPUT.NUM[8,1] * 2
    IF VAR.EIGHT.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.EIGHT.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.EIGHT.DIGIT[2,1]
        VAR.EIGHT.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.NINTH.DIGIT = Y.INPUT.NUM[9,1] * 1
    IF VAR.NINTH.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.NINTH.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.NINTH.DIGIT[2,1]
        VAR.NINTH.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.TENTH.DIGIT = Y.INPUT.NUM[10,1] * 2
    IF VAR.TENTH.DIGIT GT 9 THEN
        SUB.VAR.DIGIT1 = VAR.TENTH.DIGIT[1,1]
        SUB.VAR.DIGIT2 = VAR.TENTH.DIGIT[2,1]
        VAR.TENTH.DIGIT = SUB.VAR.DIGIT1 + SUB.VAR.DIGIT2
    END
    VAR.TOT.SUM = VAR.FIRST.DIGIT + VAR.SECOND.DIGIT + VAR.THIRD.DIGIT + VAR.FOURTH.DIGIT + VAR.FIFITH.DIGIT + VAR.SIXTH.DIGIT + VAR.SEVENTH.DIGIT + VAR.EIGHT.DIGIT + VAR.NINTH.DIGIT + VAR.TENTH.DIGIT
    VAL.MOD.SUM = MOD(VAR.TOT.SUM,10)
*PACS00054288 - S
    IF VAL.MOD.SUM EQ '0' THEN
        VAR.CHECK.DIGIT = VAL.MOD.SUM
    END ELSE
        VAR.CHECK.DIGIT = 10 - VAL.MOD.SUM
    END
*PACS00054288 - E
    IF VAL.CHECK EQ VAR.CHECK.DIGIT THEN
        Y.CHECK.DIGIT = 'PASS'
    END ELSE
        Y.CHECK.DIGIT = 'FAIL'
    END
RETURN
*------------------------------------------------------------------------------------------------------------------
END
*------------------------------------------------------------------------------------------------------------------
