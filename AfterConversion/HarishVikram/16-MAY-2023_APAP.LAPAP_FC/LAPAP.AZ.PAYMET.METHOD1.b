* @ValidationCode : MjotMTU1NDIzNzkzNjpDcDEyNTI6MTY4NDE1Mjg0OTk4NDpIYXJpc2h2aWtyYW1DOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 15 May 2023 17:44:09
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : HarishvikramC
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
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
    CALL APAP.LAPAP.lapapMonDefinePayment(ID,RS,RT) ;* MANUAL R22 CODE CONVERSION

    IF RS EQ "CASHDEPOSIT" THEN
        COMI = RT
    END ELSE
        COMI = ""
    END


*DEBUG

END
