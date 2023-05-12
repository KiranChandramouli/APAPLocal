* @ValidationCode : Mjo2OTc1MTE4ODA6Q3AxMjUyOjE2ODExMDcxMTU4NTY6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 11:41:55
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.GET.AMOUNT.LETTER(Y.AMT)
*-----------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  : TAM
* Program Name  : REDO.GET.AMOUNT.LETTER
* ODR NUMBER    : ODR-2009-10-0795
*----------------------------------------------------------------------------------------------------
* Description   : This routine is used for Deal slip. Will return the amount in letters in spanish
* In parameter  :
* out parameter : Y.AMT
*----------------------------------------------------------------------------------------------------
* Modification History :
*----------------------------------------------------------------------------------------------------
*   DATE             WHO             REFERENCE         DESCRIPTION
* 14-01-2011      MARIMUTHU s       ODR-2009-10-0795  Initial Creation
* 05-08-2011      MARIMUTHU S       PACS00099482
** 10-04-2023 R22 Auto Conversion no changes
** 10-04-2023 Skanda R22 Manual Conversion line no 40
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    Y.AMT  = ''
    IN.AMT = R.NEW(FT.AMOUNT.CREDITED)
    IN.AMT = IN.AMT[4,LEN(IN.AMT)]
*CALL REDO.CONVERT.NUM.TO.WORDS(IN.AMT, OUT.AMT, LINE.LENGTH, NO.OF.LINES, ERR.MSG) ;* R22 Manual Conversion
    CALL APAP.TAM.redoConvertNumToWords(IN.AMT, OUT.AMT, LINE.LENGTH, NO.OF.LINES, ERR.MSG)
    Y.AMT = UPCASE(OUT.AMT)

RETURN
END
