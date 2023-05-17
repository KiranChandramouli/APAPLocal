* @ValidationCode : MjoxODM5MTMzMzI3OkNwMTI1MjoxNjgyMzM1OTQ2MDg1OklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 24 Apr 2023 17:02:26
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
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                BP REMOVED, FM TO @FM
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*----------------------------------------------------------------------------------------------------------------------
SUBROUTINE LAPAP.AZ.CALCULATE.TERM

    $INSERT I_COMMON ;* AUTO R22 CODE CONVERSION START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON ;* AUTO R22 CODE CONVERSION END

    Y.VALUE.DATE.MATURITY = O.DATA;
    Y.FIELD.POS = CHANGE(Y.VALUE.DATE.MATURITY,',',@FM);

    Y.VALUE.DATE    = Y.FIELD.POS<1>
    Y.MATURITY.DATE = Y.FIELD.POS<2>
    Y.PLAZO.FORMAT = '';

    IF Y.VALUE.DATE NE '' AND  Y.MATURITY.DATE NE '' THEN
        DAYS = "C";
        CALL CDD("",Y.VALUE.DATE,Y.MATURITY.DATE,DAYS)
        Y.PLAZO.FORMAT = EREPLACE(DAYS,"D","")
    END

    O.DATA = Y.PLAZO.FORMAT;

RETURN

END
