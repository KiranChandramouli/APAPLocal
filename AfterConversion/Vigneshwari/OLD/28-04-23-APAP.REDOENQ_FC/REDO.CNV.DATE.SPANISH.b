* @ValidationCode : MjoxNDQyMzQ2NDc5OkNwMTI1MjoxNjgyNTEzODI4Mjg5OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 26 Apr 2023 18:27:08
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.CNV.DATE.SPANISH
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 06-APRIL-2023      Conversion Tool       R22 Auto Conversion - FM to @FM
* 06-APRIL-2023      Harsha                R22 Manual Conversion - Call rtn modified
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $USING APAP.TAM

    GOSUB PROCESS

RETURN
*--------------
PROCESS:
*-------------

    CHECK.DATE = O.DATA
    Y.DATE = CHECK.DATE[7,2]

    Y.MONTH = CHECK.DATE[5,2]
    Y.YEAR = CHECK.DATE[1,4]

    IN.DATE = Y.DATE
    CALL APAP.TAM.redoConvertNumToWords(IN.DATE, OUT.DATE, LINE.LENGTH, NO.OF.LINES, ERR.MSG);* R22 Manual Conversion
    Y.DATE.ES = UPCASE(OUT.DATE)
    Y.DATE.ES = FIELD(Y.DATE.ES,"PESO",1)

    Y.MONTH.SPANISH = "ENERO":@FM:"FEBRERO":@FM:"MARZO":@FM:"ABRIL":@FM:"MAYO":@FM:"JUNIO":@FM:"JULIO":@FM:"AGOSTO":@FM:"SEPTIEMBRE":@FM:"OCTUBRE":@FM:"NOVIEMBRE":@FM:"DICIEMBRE"
    Y.MONTH.ES = Y.MONTH.SPANISH<Y.MONTH>

    IN.YEAR = Y.YEAR
    CALL APAP.TAM.redoConvertNumToWords(IN.YEAR, OUT.YEAR, LINE.LENGTH, NO.OF.LINES, ERR.MSG) ;* R22 Manual Conversion
    Y.YEAR.ES = UPCASE(OUT.YEAR)
    Y.YEAR.ES = FIELD(Y.YEAR.ES,"PESO",1)

    Y.DATE.SPANISH = Y.DATE.ES:"-":Y.DATE:"##":Y.MONTH.ES:"-":Y.MONTH:"##":Y.YEAR.ES:"-":Y.YEAR

    O.DATA = Y.DATE.SPANISH

RETURN
*--------------------------
END
