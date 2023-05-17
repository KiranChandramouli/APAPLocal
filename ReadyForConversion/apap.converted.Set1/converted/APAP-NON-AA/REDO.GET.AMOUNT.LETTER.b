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
*----------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER

    Y.AMT  = ''
    IN.AMT = R.NEW(FT.AMOUNT.CREDITED)
    IN.AMT = IN.AMT[4,LEN(IN.AMT)]
    CALL REDO.CONVERT.NUM.TO.WORDS(IN.AMT, OUT.AMT, LINE.LENGTH, NO.OF.LINES, ERR.MSG)
    Y.AMT = UPCASE(OUT.AMT)

RETURN
END
