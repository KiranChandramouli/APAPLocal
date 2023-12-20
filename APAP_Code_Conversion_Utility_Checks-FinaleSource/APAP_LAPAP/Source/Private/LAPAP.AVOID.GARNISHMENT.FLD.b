* @ValidationCode : MjotMzQ5MTA1MjkyOkNwMTI1MjoxNjgyMzM1OTQ2MDc1OklUU1M6LTE6LTE6OTk6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 99
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.

$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED, M TO M.VAR
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*-----------------------------------------------------------------------------------------------------------------------
SUBROUTINE LAPAP.AVOID.GARNISHMENT.FLD

    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.APAP.H.GARNISH.DETAILS ;* AUTO R22 CODE CONVERSION END


    FN.GARNISH ="F.APAP.H.GARNISH.DETAILS"
    F.GARNISH = ""

    CALL OPF(FN.GARNISH,F.GARNISH)

    GRAMT = R.NEW(APAP.GAR.GARNISH.AMT)

    M.VAR = DCOUNT(GRAMT,@VM) ;* AUTO R22 CODE CONVERSION M TO M.VAR
    FOR A = 1 TO M.VAR STEP 1
        IF GRAMT ! '' THEN

            R.NEW(APAP.GAR.GARNISH.AMT)<1,A> = 0.00
            R.NEW(APAP.GAR.AMOUNT.LOCKED)<1,A> = 0
        END
    NEXT A

END
