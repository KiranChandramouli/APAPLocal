* @ValidationCode : MjoxNzA3ODQyOTIxOkNwMTI1MjoxNjgxNzMzMTc3MTA0OnNhbWFyOi0xOi0xOjA6MDpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 17:36:17
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
SUBROUTINE REDO.V.VAL.RENEW.CARDS
*------------------------------------------------------------------------------
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: S KAVITHA
* PROGRAM NAME: REDO.V.VAL.RENEW.CARDS
* ODR NO      : ODR-2010-03-0400
*----------------------------------------------------------------------
* DESCRIPTION: This routine will be used for renewal card status validation
* IN PARAMETER: NONE
* OUT PARAMETER: NONE
* LINKED WITH: LATAM.CARD.ORDER,REDO.PRINCIPAL , LATAM.CARD.ORDER,REDO.ADDITIONAL,
* LATAM.CARD.ORDER,REDO.CARD.MAINTENANCE,LATAM.CARD.ORDER,REDO.CARD.ACTIVATION
*
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*09.08.2011   S KAVITHA     ODR-2010-03-0400    INITIAL CREATION
*----------------------------------------------------------------------
*Modification History
*DATE                WHO                         REFERENCE                DESCRIPTION
*17-04-2023       Conversion Tool        R22 Auto Code conversion          No Changes
*17-04-2023       Samaran T               R22 Manual Code Conversion       No Changes
*--------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.CARD.GENERATION
    $INSERT I_F.LATAM.CARD.ORDER



    GOSUB PROCESS
RETURN
*********
PROCESS:

    FN.REDO.CARD.GENERATION = 'F.REDO.CARD.GENERATION'
    F.REDO.CARD.GENERATION = ''
    CALL OPF(FN.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION)

    GET.RENEW.REQ.ID = ''
    GET.CARD.STATUS = ''
    GET.RENEW.STATUS = ''
    GET.OLD.CARD.STATUS = ''

    GET.RENEW.REQ.ID = R.NEW(CARD.IS.RENEW.REQ.ID)
    GET.CARD.STATUS =  R.NEW(CARD.IS.CARD.STATUS)
    GET.OLD.CARD.STATUS = R.OLD(CARD.IS.CARD.STATUS)
    GET.RENEW.STATUS = R.NEW(CARD.IS.RENEW.STATUS)
    GET.OLD.RENEW.STATUS = R.OLD(CARD.IS.RENEW.STATUS)
    GET.CURR.NO = R.NEW(CARD.IS.CURR.NO)

    GET.ISSUE.INDICATOR = R.OLD(CARD.IS.ISSUE.INDICATOR)
    GET.ISSUE.NUMBER = R.OLD(CARD.IS.ISSUE.NUMBER)


    IF GET.OLD.CARD.STATUS AND GET.ISSUE.INDICATOR NE "REISSUE" THEN
        IF GET.OLD.CARD.STATUS NE GET.CARD.STATUS AND GET.CARD.STATUS EQ 90 THEN
            IF R.NEW(CARD.IS.RENEW.STATUS) EQ "AVAILABLE" THEN
                CALL F.READU(FN.REDO.CARD.GENERATION,GET.RENEW.REQ.ID,R.REDO.CARD.GENERATION,F.REDO.CARD.GENERATION,GEN.ERR,"")
                EXPIRY.DATE = R.REDO.CARD.GENERATION<REDO.CARD.GEN.EXPIRY,1>
                R.NEW(CARD.IS.ISSUE.DATE) = TODAY
                R.NEW(CARD.IS.EXPIRY.DATE) = EXPIRY.DATE
                R.NEW(CARD.IS.ISSUE.INDICATOR) = "RENEWAL"
                R.NEW(CARD.IS.ISSUE.NUMBER) = "SAME"
            END ELSE
                AF = CARD.IS.CARD.STATUS
                ETEXT = "EB-NOT.ALLOW.RENEW"
                CALL STORE.END.ERROR
            END
        END
    END

RETURN
*-----------------------------------------------------------------------
END
