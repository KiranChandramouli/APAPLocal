* @ValidationCode : MjoxNzQzOTYxODE4OkNwMTI1MjoxNjgyMzMxMzIxODgxOklUU1M6LTE6LTE6LTEyOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 24 Apr 2023 15:45:21
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -12
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
SUBROUTINE L.APAP.ENQ.CHQ.SINGLE.MAND.F(ENQ.DATA)

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 21-APR-2023     Conversion tool    R22 Auto conversion      I to I.VAR, BP Removed in insert file
* 21-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_EQUATE ;*R22 Auto conversion - START
    $INSERT I_COMMON
    $INSERT I_ENQUIRY.COMMON ;*R22 Auto conversion - END

********************************************************************************************************
**DEBUG
    V.USR.F = "NULL"
    V.AUTH.F = "NULL"
********************************************************************************************************
**RECORRO EL ARREGLO ENQ.DATA  PARA BUSCAR LOS CAMPOS USER(DIGITALIZADOR) Y AUTHORISER
    FOR I.VAR = 1 TO 10
**SI LA POSICION 2,N REPRESENTA EL AUTORIZADOR, ENTONCES PASO SU VALOR QUE ES LA POSICION 4,N
        IF ENQ.DATA<2,I.VAR> EQ "AUTHORISER" THEN
            V.AUTH.F = ENQ.DATA<4,I.VAR>
        END
**SI LA POSICION 2,N REPRESENTA EL USUARIO, ENTONCES PASO SU VALOR QUE ES LA POSICION 4,N
        IF ENQ.DATA<2,I.VAR> EQ "USER" THEN
            V.USR.F = ENQ.DATA<4,I.VAR>
        END
    NEXT I.VAR
**DEBUG
**VALIDACION: RESTRINJO QUE ALMENOS UNO DE LOS DOS CAMPOS SEA RELLENADO.
    IF (V.USR.F EQ "NULL" AND V.AUTH.F EQ "NULL") THEN
**DEBUG
***CALL REM
***ETEXT = "CAMPOS DIGITADOR/AUTORIZADOR SIN VALOR, COMPLETAR AL MENOS UNO."
***CALL STORE.END.ERROR
        ENQ.ERROR = "CAMPOS DIGITADOR/AUTORIZADOR SIN VALOR, COMPLETAR AL MENOS UNO."
        ENQ.ERROR<1,2> = 2
*** ENQ.ERROR<2,1> = "CAMPOS DIGITADOR/AUTORIZADOR SIN VALOR, COMPLETAR AL MENOS UNO."
**DEBUG
    END
RETURN
END
