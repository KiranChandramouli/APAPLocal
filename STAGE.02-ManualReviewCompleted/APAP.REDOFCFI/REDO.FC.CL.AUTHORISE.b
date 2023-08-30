* @ValidationCode : Mjo3NzQ3ODg5NDI6Q3AxMjUyOjE2ODA2NzE1NjEzMjE6SVRTUzotMTotMTotOToxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 10:42:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -9
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOFCFI
SUBROUTINE REDO.FC.CL.AUTHORISE
*-----------------------------------------------------------------------------
* Developer    : Luis Fernando Pazmino (lpazminodiaz@temenos.com)
* Date         : 15.06.2011
* Description  : Register the account entries for COLLATERAL before authorizing
*-----------------------------------------------------------------------------
* Modification History:
*
* Version   Date            Who               Reference      Description
* 1.0       11.07.2011      lpazmino          CR.180         Initial Version
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*04-04-2023           CONVERSION TOOL                AUTO R22 CODE CONVERSION                 NO CHANGES
*04-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION            CALL ROUTINE METHOD ADDED
*-----------------------------------------------------------------------------
* Input/Output:   NA/NA
* Dependencies: NA
*-----------------------------------------------------------------------------

* <region name="INCLUDES">
    $INSERT I_COMMON
    $INSERT I_EQUATE

    $INSERT I_F.COLLATERAL

* </region>

    GOSUB PROCESS

* <region name="PROCESS" description="Process">
RETURN

PROCESS:
    IF R.OLD(COLL.CURR.NO) EQ '' THEN
* Nueva Garantia registrada
        CALL APAP.REDOFCFI.REDO.FC.CL.ACCOUNTING('NEW') ;* MANUAL R22 CODE CONVERSION
    END
RETURN
* </region>
END
