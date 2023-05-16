* @ValidationCode : MjotMjcyMDIzMTEwOkNwMTI1MjoxNjg0MTUyMjI4MjIwOkhhcmlzaHZpa3JhbUM6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 15 May 2023 17:33:48
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
*21-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 INCLUDE TO INSERT
*21-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL RTN METHOD ADDED
*------------------------------------------------------------------------------------------------------------------
SUBROUTINE  L.APAP.TRANSL.OUTPUT.FIELD(Y.DYN.RESPONSE.KEY, Y.DYN.RESPONSE.VALUE, Y.DYN.RESPONSE.TYPE, Y.DYN.MAPPING.OUT, Y.ERROR)
    $INSERT I_COMMON ;*AUTO R22 CODE CONVERSION
    $INSERT I_EQUATE ;*AUTO R22 CODE CONVERSION

*Subroutine to Translate T24 Field name TO external field name.
*----------------------------------------------------------------------------------------------------------------------------------------------------
*CLEAR OUTPUTS VARIABLE
    Y.DYN.RESPONSE.TYPE = ''
    Y.ERROR = ''
    Y.ERROR<3> = 'L.APAP.TRANSL.OUTPUT.FIELD'

    Y.ITEM = ''

*DEBUG
    Y.CNT = DCOUNT(Y.DYN.RESPONSE.KEY, @FM)
    FOR V.I = 1 TO Y.CNT STEP 1
        Y.ITEM = Y.DYN.RESPONSE.KEY<V.I>

        IF Y.ITEM EQ 'ID' THEN
            Y.ITEM = '@ID'
        END

        LOCATE Y.ITEM IN Y.DYN.MAPPING.OUT<6,1> SETTING Y.POS THEN
            Y.DYN.RESPONSE.KEY<V.I> = Y.DYN.MAPPING.OUT<5,Y.POS>
            Y.DYN.RESPONSE.TYPE<V.I> = Y.DYN.MAPPING.OUT<7,Y.POS>

            Y.ITEM.MASK = Y.DYN.MAPPING.OUT<8,Y.POS>
            Y.ITEM.MASK = TRIM(Y.ITEM.MASK, ' ', 'R')
            IF Y.ITEM.MASK NE '' THEN
                Y.ITEM.VALUE = Y.DYN.RESPONSE.VALUE<V.I>
                CALL APAP.LAPAP.lApapMaskDynOut(Y.ITEM.VALUE, Y.ITEM.MASK, Y.ERROR) ;* MANUAL R22 CODE CONVERSION
                Y.DYN.RESPONSE.VALUE<V.I> = Y.ITEM.VALUE
            END

        END
        ELSE
            Y.DYN.RESPONSE.KEY<V.I> = '*' : Y.ITEM
            Y.DYN.RESPONSE.TYPE<V.I> = ''
        END
    NEXT V.I

RETURN
END
