* @ValidationCode : MjotNjkyMDg3MzE4OkNwMTI1MjoxNjgwNzkwMTEwMDgwOklUU1M6LTE6LTE6MTgxOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 06 Apr 2023 19:38:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 181
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.UPD.SETT.RISK.LOAD
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.B.UPD.SETT.RISK.LOAD
*--------------------------------------------------------------------------------------------------------
*Description       : The routine is the .LOAD routine for the multithreade batch routine
*                    REDO.B.UPD.SETT.RISK. The files are opened in this section
*In Parameter      : NA
*Out Parameter     : NA
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*    Date            Who                            Reference                      Description
*   ------         ------                         -------------                    -------------
*  11/11/2010   A.SabariKumar                     ODR-2010-07-0075                Initial Creation
* 04-APR-2023     Conversion tool                 R22 Auto conversion      VM to @VM, F.READ to CACHE.READ, F.FX.PARAMETERS to R.FX.PARAM
* 04-APR-2023      Harishvikram C                Manual R22 conversion      No changes
*
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FX.PARAMETERS
    $INSERT I_F.REDO.APAP.FX.LIMIT
    $INSERT I_REDO.B.UPD.SETT.RISK.COMMON

    GOSUB INITIALISE
    GOSUB GET.LT.POS

RETURN

*--------------------------------------------------------------------------------------------------------
INITIALISE:
*-------------
* Initialise/Open all necessary variables/files

    FN.REDO.APAP.FX.LIMIT = 'F.REDO.APAP.FX.LIMIT'
    F.REDO.APAP.FX.LIMIT = ''
    CALL OPF(FN.REDO.APAP.FX.LIMIT,F.REDO.APAP.FX.LIMIT)

    FN.FX.PARAMETERS = 'F.FX.PARAMETERS'
    F.FX.PARAMETERS = ''
    CALL OPF(FN.FX.PARAMETERS,F.FX.PARAMETERS)
RETURN

*--------------------------------------------------------------------------------------------------------
GET.LT.POS:
*-------------
* Calls the core routine MULTI.GET.LOC.REF and gets the position of the
* required local reference fields

    APPL.NAME = 'FX.PARAMETERS'
    FLD.NAME = 'L.FX.SETT.LIMIT':@VM:'L.FX.SETT.DATE'
    FLD.POS = ''
    CALL MULTI.GET.LOC.REF(APPL.NAME,FLD.NAME,FLD.POS)
    Y.SETT.LIM.POS = FLD.POS<1,1>
    Y.SETT.DATE.POS = FLD.POS<1,2>
    CALL CACHE.READ(FN.FX.PARAMETERS, 'FX.PARAMETERS', R.FX.PARAM, FX.ERR) ;*R22 Auto conversion
    Y.PARAMETER.DATE = R.FX.PARAM<FX.P.LOCAL.REF><1,Y.SETT.DATE.POS>
    Y.PARAMETER.TIMING = R.FX.PARAM<FX.P.LOCAL.REF><1,Y.SETT.LIM.POS>

RETURN

*--------------------------------------------------------------------------------------------------------
END
