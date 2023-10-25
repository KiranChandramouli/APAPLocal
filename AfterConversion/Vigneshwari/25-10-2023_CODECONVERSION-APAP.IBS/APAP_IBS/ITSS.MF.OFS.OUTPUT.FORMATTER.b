* @ValidationCode : MjotOTcxOTE0MDA5OkNwMTI1MjoxNjk4MjMwNzg3MDkyOnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Oct 2023 16:16:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.IBS
*-----------------------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE                          AUTHOR                   Modification                            DESCRIPTION
*25/10/2023                VIGNESHWARI        MANUAL R23 CODE CONVERSION                VM TO @VM,SM TO @SM,FM TO @FM
*-----------------------------------------------------------------------------------------------------------------------------------

    SUBROUTINE ITSS.MF.OFS.OUTPUT.FORMATTER(REQUEST, RESPONSE)
*------------------------------------------------------------------------------------
* Description:
*------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*------------------------------------------------------------------------------------

    GOSUB INITIALISE

    GOSUB PROCESS

    RETURN

*------------------------------------------------------------------------------------
INITIALISE:

    IF REQUEST[1,14] NE 'ENQUIRY.SELECT' THEN
        APPL.HEADER = '@ID':@FM:'MESSAGE.ID':@FM:'SUCCESS'
    END

    RETURN

*------------------------------------------------------------------------------------
PROCESS:

    IF REQUEST[1,14] NE 'ENQUIRY.SELECT' THEN
        CONVERT ',' TO @FM IN RESPONSE
        HEADER.RESPONSE = FIELDS(RESPONSE, '=', 1)
        HEADER.RESPONSE<1> = APPL.HEADER
        VALUE.RESPONSE = FIELDS(RESPONSE, '=', 2)
        VALUE.ID.RESPONSE = RESPONSE<1>
        CONVERT '/' TO @FM IN VALUE.ID.RESPONSE
        VALUE.RESPONSE<1> = VALUE.ID.RESPONSE

        HEADER.RESPONSE = LOWER(LOWER(HEADER.RESPONSE))
        VALUE.RESPONSE = LOWER(LOWER(VALUE.RESPONSE))

        CONVERT ':' TO '-' IN HEADER.RESPONSE

        NEW.RESPONSE = HEADER.RESPONSE:@VM:VALUE.RESPONSE
    END ELSE
        NEW.RESPONSE = RESPONSE
        CHANGE '",' TO '"':@VM IN NEW.RESPONSE
        IF RESPONSE[1,1] EQ ',' THEN
            CONVERT '/' TO @SM IN NEW.RESPONSE<1,1>
        END ELSE
            CONVERT '/' TO @SM IN NEW.RESPONSE<1,2>
        END
        CONVERT CHAR(09) TO @SM IN NEW.RESPONSE
    END

    RESPONSE = NEW.RESPONSE

    RETURN

*------------------------------------------------------------------------------------
END
