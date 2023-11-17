* @ValidationCode : MjotNDY5Nzc5MDg3OkNwMTI1MjoxNjgwNjU4NDQ3ODA2OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 07:04:07
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
SUBROUTINE REDO.CHK.POST.REST

*--------------------------------------------------------------------------------------------------------
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.CHK.POST.REST
*--------------------------------------------------------------------------------------------------------
*Description  : This validation is to check the posting restriction on the account or not.this is a calling routine from
*               REDO.INITI.CARD.VAL
*In Parameter : N/A
*Out Parameter: N/A
*--------------------------------------------------------------------------------------------------------
*--------------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
*    Date            Who                  Reference               Description
*   ------          ------               -------------            -------------
* 1 FEB  2011     Balagurunathan         PACS00137917             * PACS00137917 FIX

* Date             Who                   Reference      Description
* 05.04.2023       Conversion Tool       R22            Auto Conversion     - F TO CACHE
* 05.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*--------------------------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.POSTING.RESTRICT

    $INSERT I_POST.COMMON

    IF V$FUNCTION NE 'I' THEN
        RETURN

    END
    GOSUB INITIALISE
    GOSUB PROCES





RETURN


INITIALISE:
    BLK.MARK.ACCT=''
    FN.POSTING.RESTRICT='F.POSTING.RESTRICT'
    F.POSTING.RESTRICT=''
    CALL OPF(FN.POSTING.RESTRICT,F.POSTING.RESTRICT)

RETURN


PROCES:

    CALL CACHE.READ(FN.POSTING.RESTRICT, Y.POST.ID, R.POSTING.RESTRICT, REST.ERR)  ;** R22 Auto conversion F to CACHE

    IF R.POSTING.RESTRICT<AC.POS.RESTRICTION.TYPE> EQ 'DEBIT' OR R.POSTING.RESTRICT<AC.POS.RESTRICTION.TYPE> EQ 'ALL' THEN

        BLK.MARK.ACCT = 'TRUE'
    END ELSE
        BLK.MARK.ACCT = 'FALSE'

    END

    IF (APPLICATION EQ 'FUNDS.TRANSFER' OR APPLICATION EQ 'AC.LOCKED.EVENTS') AND BLK.MARK.ACCT EQ 'TRUE' THEN

        ETEXT="EB-POSTING.RESTRICT"
        CALL STORE.END.ERROR
    END

RETURN




END
