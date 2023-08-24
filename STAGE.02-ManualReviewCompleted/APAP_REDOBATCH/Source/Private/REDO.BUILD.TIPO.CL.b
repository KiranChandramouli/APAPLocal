* @ValidationCode : MjotNTEwOTU3NzQ6Q3AxMjUyOjE2ODA2OTA0NjE4Mjk6SVRTUzotMTotMTotNzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 05 Apr 2023 15:57:41
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BUILD.TIPO.CL(ENQ.DATA)
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.BUILD.TIPO.CL
* ODR NO      : ODR-2010-09-0142
*----------------------------------------------------------------------
*DESCRIPTION: It is neccessary to create a routine REDO.BUILD.TIPO.CL as
* a Build routine for Enquiry  REDO.CU.VINC.CUSPROF




*IN PARAMETER: ENQ.DATA
*OUT PARAMETER: ENQ.DATA
*LINKED WITH:  REDO.CU.VINC.CUSPROF
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE              WHO            REFERENCE           DESCRIPTION
*14.09.2010     H GANESH        ODR-2010-09-0142    INITIAL CREATION
*04-APR-2023  Conversion tool   R22 Auto conversion  SM to @SM
*04-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*----------------------------------------------------------------------


    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON


    GOSUB PROCESS
RETURN

*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------

    LOCATE 'L.CU.TIPO.CL' IN ENQ.DATA<2,1> SETTING POS1 THEN
        Y.TIPO.CL=ENQ.DATA<4,POS1>
        CHANGE @SM TO '' IN Y.TIPO.CL
        ENQ.DATA<4,POS1>="'":Y.TIPO.CL:"'"
    END
RETURN

END
