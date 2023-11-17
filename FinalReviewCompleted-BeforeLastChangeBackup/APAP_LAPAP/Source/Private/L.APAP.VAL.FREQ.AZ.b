* @ValidationCode : Mjo1OTY1MTc3NDg6Q3AxMjUyOjE2ODIzMzU5NDUwNzM6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:25
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
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
SUBROUTINE L.APAP.VAL.FREQ.AZ
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.AZ.ACCOUNT

    VAR.FREQ.ACT  =  R.NEW(AZ.FREQUENCY)<1,1>

    VAR.FREQ.UNO = R.OLD(AZ.FREQUENCY)<1,1>

    IF  VAR.FREQ.ACT NE VAR.FREQ.UNO AND LEN(VAR.FREQ.ACT) NE 8 THEN

        AF = AZ.FREQUENCY
        ETEXT = "1 PARA CAMBIO DE DIA DE PAGO, INGRESAR DIA EN CAMPO *DIA PAGO INTERESES*"
        CALL STORE.END.ERROR

    END


END
