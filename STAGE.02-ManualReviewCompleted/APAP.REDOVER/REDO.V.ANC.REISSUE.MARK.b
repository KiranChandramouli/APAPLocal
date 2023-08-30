* @ValidationCode : MjotNzk2NjU4ODAwOkNwMTI1MjoxNjgwNzc2NDc2NDk2OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Apr 2023 15:51:16
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.ANC.REISSUE.MARK
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: KAVITHA
* PROGRAM NAME: REDO.V.ANC.REISSUE.MARK
* ODR NO      : ODR-2010-03-0400
*----------------------------------------------------------------------
*DESCRIPTION: This routine is authorisation routine to update LATAM CARD ORDER
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO                   REFERENCE                         DESCRIPTION
*10 JUN 2011   KAVITHA                PACS00079591                          FIX
*06-04-2023    Conversion Tool        R22 Auto Code conversion            No Changes
*06-04-2023   Samaran T               R22 Manual Code Conversion           No Changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.REQUEST
    $INSERT I_F.LATAM.CARD.ORDER


    FN.LATAM.CARD.ORDER = 'F.LATAM.CARD.ORDER'
    F.LATAM.CARD.ORDER = ''
    CALL OPF(FN.LATAM.CARD.ORDER,F.LATAM.CARD.ORDER)



    GET.CARD.STATUS = R.NEW(CARD.IS.CARD.STATUS)
    OLD.CARD.STATUS = R.OLD(CARD.IS.CARD.STATUS)

    IF GET.CARD.STATUS EQ 90 AND OLD.CARD.STATUS EQ 92 THEN
        R.NEW(CARD.IS.ISSUE.NUMBER) = ''
        R.NEW(CARD.IS.ISSUE.INDICATOR) = ''
    END

RETURN
END
