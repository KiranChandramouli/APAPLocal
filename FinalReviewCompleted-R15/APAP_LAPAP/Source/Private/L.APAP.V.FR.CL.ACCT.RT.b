* @ValidationCode : MjoyMDk0MDU3NTM6Q3AxMjUyOjE2ODIzMzU5NDQxNzM6SVRTUzotMTotMTotNToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -5
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
*----------------------------------------------------------------------------------------------------------------
SUBROUTINE L.APAP.V.FR.CL.ACCT.RT
    $INSERT  I_COMMON
    $INSERT  I_EQUATE
    $INSERT  I_F.REDO.FRONT.CLAIMS
*------------------------------------------------------------------------------------------------------------
    Y.FR.CL.PRODUCT.TYPE = ""
    Y.FR.CL.ACCOUNT.ID = ""
*------------------------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------------------------
    Y.FR.CL.PRODUCT.TYPE = R.NEW(FR.CL.PRODUCT.TYPE)
    Y.FR.CL.ACCOUNT.ID = R.NEW(FR.CL.ACCOUNT.ID)
    TEST.VAR = R.OLD(FR.CL.ACCOUNT.ID)
* DEBUG
*------------------------------------------------------------------------------------------------------------
    IF Y.FR.CL.PRODUCT.TYPE EQ "CERTIFICADOS" OR Y.FR.CL.PRODUCT.TYPE EQ "CUENTA.DE.AHORROS" OR Y.FR.CL.PRODUCT.TYPE EQ "PRESTAMOS" THEN
        IF Y.FR.CL.ACCOUNT.ID EQ "" THEN
            MESSAGE = 'ESTE CAMPO ES REQUERIDO CUANDO EL PRODUCTO ES ' : Y.FR.CL.PRODUCT.TYPE
            E = MESSAGE
            ETEXT = E
            CALL ERR
        END
    END
*------------------------------------------------------------------------------------------------------------
RETURN

END
