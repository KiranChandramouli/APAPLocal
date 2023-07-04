* @ValidationCode : MjotMjM2NzA5MzE1OkNwMTI1MjoxNjgyMzM1OTQ0MTQ5OklUU1M6LTE6LTE6LTE6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -1
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.V.CUS.ME.TIP.CLI.RT
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CUSTOMER
    $INSERT I_F.DATES


    Y.L.TIP.CLI = COMI        ;*L.TIP.CLI = 521 => Recibe Ingresos Familiares.
    Y.CUST.DATE.OF.BIRTH = R.NEW(EB.CUS.DATE.OF.BIRTH)
    Y.TODAY = R.DATES(EB.DAT.TODAY)
    C.DAYS = "C"

    IF Y.CUST.DATE.OF.BIRTH NE '' THEN
        CALL CDD("",Y.CUST.DATE.OF.BIRTH,Y.TODAY,C.DAYS)

        IF (C.DAYS LT 16 AND Y.L.TIP.CLI NE '521') THEN
            MESSAGE = "EDAD CLIENTE NO PERMITE SECTOR COMERCIAL DIFERENTE A <Recibe Ingresos Familiares>"
            E = MESSAGE
            ETEXT = E
            CALL ERR
        END

    END

RETURN

END
