* @ValidationCode : Mjo3MzgwMTA1NTE6Q3AxMjUyOjE2ODExMzUxNjQwMDc6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 19:29:24
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
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FEECOLLECT.VALIDATE
*---------------------------------------------------------------------------------------------------------
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
*---------------------------------------------------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.FEECOLLECT

    RES.COD=R.NEW(REDO.FEE.REASON.CODE)
    CTRY.CDE=R.NEW(REDO.FEE.COUNTRY.CODE)

    BEGIN CASE

        CASE RES.COD EQ '0100' OR RES.COD EQ '0190'
            IF CTRY.CDE EQ '' THEN
                AF=REDO.FEE.COUNTRY.CODE
                ETEXT='EB-INP.MISS'
                CALL STORE.END.ERROR
            END
        CASE RES.COD EQ '0300'

            IF CTRY.CDE NE 'CA' AND CTRY.CDE NE 'BR' THEN
                AF=REDO.FEE.COUNTRY.CODE
                ETEXT='EB-INP.CA.OR.BR'
                CALL STORE.END.ERROR

            END

        CASE OTHERWISE


            IF CTRY.CDE NE '' THEN

                AF=REDO.FEE.COUNTRY.CODE
                ETEXT='EB-INP.BLANK'
                CALL STORE.END.ERROR

            END

    END CASE

RETURN

END
