* @ValidationCode : MjoxNTU5MzkzMjYxOkNwMTI1MjoxNjg1NTM1ODk5NzIyOnZpY3RvOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 31 May 2023 17:54:59
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : victo
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
SUBROUTINE REDO.DS.NO.OF.MONTH(Y.NO.OF.MONTH)
*-----------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.DS.NO.OF.MONTH
*------------------------------------------------------------------------------
*Description  : This is a conversion routine used to display the duration period of deposit
*               in words
*Linked With  :
*In Parameter : NA
*Out Parameter: Y.NO.OF.MONTH
*-------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 10.11.2011      SUDHARSANAN S           CR.18                  INITIAL CREATION
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*13-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*13-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION           CALL RTN METHOD ADDED

*--------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT
    $USING  APAP.TAM

*--------------------------------------------------------------------------------
**********
MAIN.PARA:
**********
    GOSUB PROCESS.PARA
RETURN
*--------------------------------------------------------------------------------
*************
PROCESS.PARA:
*************
    START.DATE= R.NEW(AZ.VALUE.DATE)
    END.DATE = R.NEW(AZ.MATURITY.DATE)
    NO.OF.MONTHS = ''
    CALL EB.NO.OF.MONTHS(START.DATE,END.DATE,NO.OF.MONTHS)

    Y.MONTH = NO.OF.MONTHS

    IF Y.MONTH LT '1' THEN
        REGION.CODE = ''
        Y.DIFF = 'C'
        CALL CDD(REGION.CODE,START.DATE,END.DATE,Y.DIFF)
        Y.MONTH = Y.DIFF
        GOSUB SPAN.LETTERS
        Y.NO.OF.MONTH= Y.MONTH:"(":TRIM(Y.OUT.MONTH,"",E):")":" DIAS"
    END ELSE
        GOSUB SPAN.LETTERS
        Y.NO.OF.MONTH= NO.OF.MONTHS:"(":TRIM(Y.OUT.MONTH,"",E):")"
    END
RETURN
*----------------
SPAN.LETTERS:
*----------------
*CALL APAP.TAM.REDO.CONVERT.NUM.TO.WORDS(Y.MONTH, OUT.MONTH, LINE.LENGTH, NO.OF.LINES, ERR.MSG)
    APAP.TAM.redoConvertNumToWords(Y.MONTH, OUT.MONTH, LINE.LENGTH, NO.OF.LINES, ERR.MSG) ;* MANUAL R22 CODE CONVERSION

    Y.OUT.MONTH= UPCASE(FIELD(OUT.MONTH,"peso",1))

RETURN
*-------------------
END
