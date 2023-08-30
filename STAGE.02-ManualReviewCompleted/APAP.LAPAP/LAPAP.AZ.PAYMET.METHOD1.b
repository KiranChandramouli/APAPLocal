* @ValidationCode : MjoxMjA5MDI5MDYyOkNwMTI1MjoxNjgyMzM1OTQ2MTAyOklUU1M6LTE6LTE6LTI6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:26
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -2
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*----------------------------------------------------------------------------------------------------------------
SUBROUTINE LAPAP.AZ.PAYMET.METHOD1

    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT ;* AUTO R22 CODE CONVERSION END


    ID = COMI
    CALL APAP.LAPAP.LAPAP.MON.DEFINE.PAYMENT(ID,RS,RT) ;* MANUAL R22 CODE CONVERSION

    IF RS EQ "CASHDEPOSIT" THEN
        COMI = RT
    END ELSE
        COMI = ""
    END


*DEBUG

END
