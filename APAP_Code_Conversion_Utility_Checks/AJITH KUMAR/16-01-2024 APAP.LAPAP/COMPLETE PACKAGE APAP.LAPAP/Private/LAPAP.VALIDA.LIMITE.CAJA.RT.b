* @ValidationCode : Mjo0Njc4Njg1MDk6Q3AxMjUyOjE2ODQyMjI4MTkwMjc6SVRTUzotMTotMTotMjI6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:19
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -22
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.VALIDA.LIMITE.CAJA.RT
*----------------------------------------------------------------------------------------------
*Modification History
*DATE                       WHO                         REFERENCE                                   DESCRIPTION
*24-04-2023            Conversion Tool             R22 Auto Code conversion                FM TO @FM,VM TO @VM,SM TO @SM,++ to +=1,INSERT FILE MODIFIED
*24-04-2023              Samaran T                R22 Manual Code conversion                         No Changes
*---------------------------------------------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON    ;*R22 AUTO CODE CONVERSION.START
    $INSERT I_EQUATE
    $INSERT I_F.TELLER.ID     ;*R22 AUTO CODE CONVERSION.END
   $USING EB.LocalReferences
    GOSUB INIT
    GOSUB PROCESS

RETURN

***************
INIT:
***************
    Y.ARRAY.FINAL = ''

*    CALL GET.LOC.REF("TELLER.ID","L.TT.CURRENCY", Y.POS.L.TT.CURRENCY)
EB.LocalReferences.GetLocRef("TELLER.ID","L.TT.CURRENCY", Y.POS.L.TT.CURRENCY);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF("TELLER.ID","L.TT.TILL.LIM", Y.POS.TILL.LIM)
EB.LocalReferences.GetLocRef("TELLER.ID","L.TT.TILL.LIM", Y.POS.TILL.LIM);* R22 UTILITY AUTO CONVERSION
*    CALL GET.LOC.REF("TELLER.ID","L.CI.CATEG.CARD", Y.POS.CATEG.CARD)
EB.LocalReferences.GetLocRef("TELLER.ID","L.CI.CATEG.CARD", Y.POS.CATEG.CARD);* R22 UTILITY AUTO CONVERSION

RETURN
***************
PROCESS:
***************
    Y.CURRENCY = R.NEW(TT.TID.LOCAL.REF)<1,Y.POS.L.TT.CURRENCY>
    Y.CATEGORY = R.NEW(TT.TID.LOCAL.REF)<1,Y.POS.CATEG.CARD>
    Y.BAL = R.NEW(TT.TID.LOCAL.REF)<1,Y.POS.TILL.LIM>

    Y.CURRENCY = CHANGE(Y.CURRENCY, @SM, @VM)
    Y.CATEGORY = CHANGE(Y.CATEGORY, @SM, @VM)
    Y.BAL = CHANGE(Y.BAL, @SM, @VM)

    GOSUB GET.ARRAY
    Y.LIMITE.ARRAY = Y.ARRAY.FINAL

    Y.CURRENCY = R.NEW(TT.TID.CURRENCY)
    Y.CATEGORY = R.NEW(TT.TID.CATEGORY)
    Y.BAL = R.NEW(TT.TID.TILL.BALANCE)
    OVERRIDE.FIELD.VALUE = R.NEW(TT.TID.OVERRIDE)
    Y.CONT.OVERRIDE = DCOUNT(OVERRIDE.FIELD.VALUE,@VM)

    GOSUB GET.ARRAY
    Y.BALANCE.ARRAY = Y.ARRAY.FINAL

    Y.TOT.HEAD = DCOUNT(Y.LIMITE.ARRAY, @FM)
    Y.CNT.HEAD = 1

    LOOP
    WHILE Y.CNT.HEAD LE Y.TOT.HEAD

        Y.ID.LIM = Y.LIMITE.ARRAY<Y.CNT.HEAD,1>
        Y.BAL.LIM = Y.LIMITE.ARRAY<Y.CNT.HEAD,2>
* El tope limite es el limite definido mas un 10%
        Y.BAL.LIM = Y.BAL.LIM * (1.10)

        Y.TOT.DET = DCOUNT(Y.BALANCE.ARRAY, @FM)
        Y.CNT.DET = 1
        Y.MONEDA = FIELD(Y.ID.LIM,'*',1)

        IF Y.ID.LIM THEN
            LOOP
            WHILE Y.CNT.DET LE Y.TOT.DET
                Y.ID.BAL = Y.BALANCE.ARRAY<Y.CNT.DET,1>
                Y.BAL.SALDO = Y.BALANCE.ARRAY<Y.CNT.DET,2>

                IF Y.ID.LIM EQ Y.ID.BAL THEN
                    IF Y.BAL.SALDO GT Y.BAL.LIM THEN
                        Y.DIFERENCIA = 0
                        Y.DIFERENCIA = Y.BAL.SALDO - Y.BAL.LIM
                        Y.CONT.OVERRIDE += 1

                        TEXT="EXCEDE.LIMITE.CIERRE":@FM:Y.MONEDA:@VM:Y.DIFERENCIA
                        CURR.NO = Y.CONT.OVERRIDE
                        CALL STORE.OVERRIDE(CURR.NO)
                    END
                END

                Y.CNT.DET += 1
            REPEAT
        END

        Y.CNT.HEAD += 1
    REPEAT

RETURN

***************
GET.ARRAY:
***************
    Y.TOT.REC = DCOUNT(Y.BAL, @VM)
    Y.CNT = 1
    Y.ARRAY.FINAL = ''

    LOOP
    WHILE Y.CNT LE Y.TOT.REC
        Y.ARRAY.FINAL = Y.ARRAY.FINAL : Y.CURRENCY<1,Y.CNT> : '*' : Y.CATEGORY<1,Y.CNT> : @VM : Y.BAL<1,Y.CNT> : @FM
        Y.CNT += 1
    REPEAT

RETURN

END
