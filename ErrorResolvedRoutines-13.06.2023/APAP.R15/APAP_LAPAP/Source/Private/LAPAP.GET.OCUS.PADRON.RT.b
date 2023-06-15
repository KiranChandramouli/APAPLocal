* @ValidationCode : MjotMjQ3MDE4MDMxOkNwMTI1MjoxNjg0MjIyODEwMDExOklUU1M6LTE6LTE6MDoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE LAPAP.GET.OCUS.PADRON.RT(P.CEDULA,P.OUT.ARR,P.ERROR)
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE            WHO               REFERENCE               DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion      BP is removed in Insert File
* 21-APR-2023    Narmadha V         R22 Manual Conversion    No Changes

*-----------------------------------------------------------------------------

    $INSERT I_COMMON ;*R22 Auto conversion -START
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON ;*R22 Auto conversion - END

    V.EB.API.ID = 'LAPAP.PADRON.INTERFACE'
    Y.PARAMETRO.ENVIO = P.CEDULA

    CALL EB.CALL.JAVA.API(V.EB.API.ID,Y.PARAMETRO.ENVIO,Y.RESPONSE,Y.CALLJ.ERROR)
    IF Y.CALLJ.ERROR NE '' THEN
        P.ERROR =Y.CALLJ.ERROR
        RETURN
    END
    Y.F.ARRAY = Y.RESPONSE

    CHANGE '::' TO @VM IN Y.F.ARRAY
    CHANGE '^^' TO @FM IN Y.F.ARRAY

    IF Y.F.ARRAY<1,3> EQ 'success' THEN
        P.OUT.ARR = Y.F.ARRAY<2>
    END ELSE
        Y.CALLJ.ERROR<-1> = Y.F.ARRAY<1,4>
        Y.CALLJ.ERROR<-1> = Y.F.ARRAY<1,5>
    END



END
