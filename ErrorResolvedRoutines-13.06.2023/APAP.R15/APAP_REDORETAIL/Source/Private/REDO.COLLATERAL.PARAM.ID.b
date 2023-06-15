* @ValidationCode : MjotMTE4NDA2OTM1OTpDcDEyNTI6MTY4MTgyOTA4NzI1ODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6REVWXzIwMjEwOC4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 20:14:47
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
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            NO CHANGES
SUBROUTINE REDO.COLLATERAL.PARAM.ID
*-------------------------------------------------------------------------
*----------------------------------------------------------------------------------------------------
* DESCRIPTION : * TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-----------------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN Parameter    : NA
* OUT Parameter   : NA
*-----------------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : ArulPrakasam
* PROGRAM NAME : REDO.COLLATERAL.PARAM.ID
*-----------------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* Date             Author             Reference         Description
* 04-May-2010      ArulPrakasam   ODR-2010-01-        Initial creation
*------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
*-------------------------------------------------------------------------
* TODO Add logic to validate the id
* TODO Create an EB.ERROR record if you are creating a new error code
*-------------------------------------------------------------------------

    IF COMI NE 'SYSTEM' THEN
        E = 'EB-NOT.VALID.ID'
        CALL STORE.END.ERROR
    END

RETURN

END
