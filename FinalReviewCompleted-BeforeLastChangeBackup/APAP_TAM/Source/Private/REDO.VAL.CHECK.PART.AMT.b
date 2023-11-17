* @ValidationCode : MjoyMTIzMTM5Mzg6Q3AxMjUyOjE2ODExMjUyNzUxOTQ6SVRTUzotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 10 Apr 2023 16:44:35
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
$PACKAGE APAP.TAM
SUBROUTINE REDO.VAL.CHECK.PART.AMT
*-----------------------------------------------------------------------------
*---------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : TAM
* Program Name : REDO.VAL.CHECK.PART.AMT
*---------------------------------------------------------
* Description : This subroutine is attached input routine in REDO.AA.PART.DISBURSE.FC,PART.DISB
*
*----------------------------------------------------------
* Linked TO :
*----------------------------------------------------------
* Modification History:
* 28-11-2012          MARIMUTHU S            PACS00236823
*
* Date             Who                   Reference      Description
* 10.04.2023       Conversion Tool       R22            Auto Conversion     - No changes
* 10.04.2023       Shanmugapriya M       R22            Manual Conversion   - No changes
*
*----------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.AA.PART.DISBURSE.FC

    Y.AMT = COMI

    IF Y.AMT GT R.NEW(REDO.PDIS.PARTIAL.OS.AMT) THEN
        AF = REDO.PDIS.DIS.AMT.TOT
        ETEXT = 'EB-AMT.EXCEEDED'
        CALL STORE.END.ERROR
    END

RETURN

END
