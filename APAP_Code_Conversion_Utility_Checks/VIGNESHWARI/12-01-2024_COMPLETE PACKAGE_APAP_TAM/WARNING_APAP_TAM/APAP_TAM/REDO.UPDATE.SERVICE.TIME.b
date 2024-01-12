* @ValidationCode : MjoxMTg3OTgxOTI0OlVURi04OjE3MDQ5NzIxNjYxNDE6QWRtaW46LTE6LTE6MDowOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 11 Jan 2024 16:52:46
* @ValidationInfo : Encoding          : UTF-8
* @ValidationInfo : User Name         : Admin
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*---------------------------------------------------------------------------------------
*MODIFICATION HISTORY:
*DATE           WHO                 REFERENCE               DESCRIPTION
*24-APR-2023    CONVERSION TOOL     R22 AUTO CONVERSION     VM TO @VM
*24-APR-2023    VICTORIA S          R22 MANUAL CONVERSION   NO CHANGE
*----------------------------------------------------------------------------------------
SUBROUTINE REDO.UPDATE.SERVICE.TIME
**********************************************************************************************
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.TSA.WORKLOAD.PROFILE
    $INSERT I_F.REDO.APAP.CLEAR.PARAM
*---------------------------------------------------------------------------------------------
* Company Name : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By : GANESH R
* Program Name : TSA.WORKLOAD.PROFILE
*----------------------------------------------------------------------------------------------
* Description : This is a Auth routine to update the time of the Workload Profile REDO.CLEAR.ID record.
**********************************************************************************************
*Linked With :
*In parameter :
*Out parameter :
********************************************************************************************
    GOSUB INIT
    GOSUB PROCESS

RETURN
****
INIT:
*****
    FN.REDO.APAP.PARAM = 'F.REDO.APAP.CLEAR.PARAM'
    F.REDO.APAP.PARAM  = ''
    CALL OPF(FN.REDO.APAP.PARAM,F.REDO.APAP.PARAM)

    FN.TSA.PROFILE = 'F.TSA.WORKLOAD.PROFILE'
    F.TSA.PROFILE  = ''
    CALL OPF(FN.TSA.PROFILE,F.TSA.PROFILE)

    TSA.PROFILE.ID = 'REDO.CLEAR.ID'

RETURN
********
PROCESS:
*********
    Y.GET.TIME = R.NEW(CLEAR.PARAM.FUND.RELES.TIME)
    IF Y.GET.TIME THEN
        Y.UPD.HOUR = Y.GET.TIME[1,2] + 3
        Y.UPD.TIME = Y.UPD.HOUR : Y.GET.TIME[3,3]
        Y.TIME = Y.GET.TIME:@VM:Y.UPD.TIME ;*R22 AUTO CONVERSION
        Y.AGENTS = 5
    END
    ELSE
        Y.TIME = ''
        Y.AGENTS = ''
    END
*    CALL F.READ(FN.TSA.PROFILE,TSA.PROFILE.ID,R.TSA.PROFILE,F.TSA.PROFILE,TSA.PROF.ERR)
    CALL F.READU(FN.TSA.PROFILE,TSA.PROFILE.ID,R.TSA.PROFILE,F.TSA.PROFILE,TSA.PROF.ERR,'');* R22 UTILITY AUTO CONVERSION
    R.TSA.PROFILE<TS.WLP.TIME> = Y.TIME
    R.TSA.PROFILE<TS.WLP.AGENTS.REQUIRED> = Y.AGENTS
    CALL F.WRITE(FN.TSA.PROFILE,TSA.PROFILE.ID,R.TSA.PROFILE)
RETURN
****************************************************************************************************
END
