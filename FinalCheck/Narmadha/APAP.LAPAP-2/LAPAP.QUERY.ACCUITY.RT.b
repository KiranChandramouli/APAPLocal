* @ValidationCode : MjotMjAyMTExODQ4MjpDcDEyNTI6MTY4MjA4MDQyMDk3ODpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 18:03:40
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.QUERY.ACCUITY.RT(P.IDENTITY,P.NAME,P.NATIONALITY,P.GENDER,P.DOB,O.DATA)
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE               WHO                REFERENCE                   DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion       BP is removed in Insert File
* 21-APR-2023    Narmadha V         R22 Manual Conversion     No Changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON ;*R22 Auto conversion - END

    V.EB.API.ID = 'LAPAP.ACCUITY.ITF'
    Y.PARAMETRO.ENVIO = P.IDENTITY:'::NORMAL::':P.NAME:'::':P.IDENTITY:'::':P.NATIONALITY:'::':P.GENDER:'::':P.DOB

    CALL EB.CALL.JAVA.API(V.EB.API.ID,Y.PARAMETRO.ENVIO,Y.RESPONSE,Y.CALLJ.ERROR)
    IF Y.CALLJ.ERROR NE '' THEN
        P.ERROR =Y.CALLJ.ERROR
        RETURN
    END
    Y.RESULT = Y.RESPONSE

    CHANGE '&' TO @FM IN Y.RESULT

    O.DATA = Y.RESULT

END
