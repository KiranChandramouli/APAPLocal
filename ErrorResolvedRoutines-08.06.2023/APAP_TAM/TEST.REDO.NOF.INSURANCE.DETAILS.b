* @ValidationCode : Mjo0NDkwNTcyNjY6Q3AxMjUyOjE2ODYxNDE4MTYyNzk6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 07 Jun 2023 18:13:36
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.TAM
SUBROUTINE TEST.REDO.NOF.INSURANCE.DETAILS
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE
* 06-JUNE-2023      Conversion Tool       R22 Auto Conversion - No changes
* 06-JUNE-2023      Harsha                R22 Manual Conversion - Inserted I_ENQUIRY.COMMON
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AA.ARRANGEMENT
    $INSERT I_F.AA.CHARGE
    $INSERT I_F.AA.ACCOUNT
    $INSERT I_F.AA.CUSTOMER
    $INSERT I_ENQUIRY.COMMON    ;*R22 Manual Conversion - Inserted I_ENQUIRY.COMMON

MAIN:

*   GOSUB OPENFILES
    GOSUB PROCESS
    GOSUB PROGRAM.END


    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)


RETURN

PROCESS:

    SEL.CMD = 'SELECT ':FN.AA.ARRANGEMENT

    LOCATE "POL.INTIAL.DATE" IN D.FIELDS<1> SETTING POSITION.ONE THEN
        POL.INTIAL.DATE   = D.RANGE.AND.VALUE<POSITION.ONE>

    END

    LOCATE "POL.TYPE" IN D.FIELDS<1> SETTING POSITION.TWO THEN
        POL.TYPE         = D.RANGE.AND.VALUE<POSITION.TWO>
    END

    LOCATE "POL.CLASS" IN D.FIELDS<1> SETTING POSITION.THREE THEN
        POL.CLASS        = D.RANGE.AND.VALUE<POSITION.THREE>
    END

    LOCATE "CLAIM.STATUS" IN D.FIELDS<1> SETTING POSITION.FOUR THEN
        CLAIM.STATUS     = D.RANGE.AND.VALUE<POSITION.FOUR>
    END


RETURN

PROGRAM.END:

END
