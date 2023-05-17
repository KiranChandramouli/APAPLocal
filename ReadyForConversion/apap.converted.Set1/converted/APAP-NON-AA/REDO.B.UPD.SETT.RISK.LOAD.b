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
    CALL CACHE.READ(FN.FX.PARAMETERS, 'FX.PARAMETERS', R.FX.PARAM, FX.ERR)
    Y.PARAMETER.DATE = R.FX.PARAM<FX.P.LOCAL.REF><1,Y.SETT.DATE.POS>
    Y.PARAMETER.TIMING = R.FX.PARAM<FX.P.LOCAL.REF><1,Y.SETT.LIM.POS>

RETURN

*--------------------------------------------------------------------------------------------------------
END
