* @ValidationCode : MjoxMjY0NzEwMTM5OlVURi04OjE2ODU1Mjk4NDI5MTE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 31 May 2023 16:14:02
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
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
    APAP.TAM.redoConvertNumToWords(IN.DATE, OUT.DATE, LINE.LENGTH, NO.OF.LINES, ERR.MSG);* R22 Manual Conversion
    Y.DATE.ES = UPCASE(OUT.DATE)
    Y.DATE.ES = FIELD(Y.DATE.ES,"PESO",1)

    Y.MONTH.SPANISH = "ENERO":@FM:"FEBRERO":@FM:"MARZO":@FM:"ABRIL":@FM:"MAYO":@FM:"JUNIO":@FM:"JULIO":@FM:"AGOSTO":@FM:"SEPTIEMBRE":@FM:"OCTUBRE":@FM:"NOVIEMBRE":@FM:"DICIEMBRE"
    Y.MONTH.ES = Y.MONTH.SPANISH<Y.MONTH>

    IN.YEAR = Y.YEAR
    APAP.TAM.redoConvertNumToWords(IN.YEAR, OUT.YEAR, LINE.LENGTH, NO.OF.LINES, ERR.MSG) ;* R22 Manual Conversion
    Y.YEAR.ES = UPCASE(OUT.YEAR)
    Y.YEAR.ES = FIELD(Y.YEAR.ES,"PESO",1)

    Y.DATE.SPANISH = Y.DATE.ES:"-":Y.DATE:"##":Y.MONTH.ES:"-":Y.MONTH:"##":Y.YEAR.ES:"-":Y.YEAR

    O.DATA = Y.DATE.SPANISH

RETURN
*--------------------------
END
