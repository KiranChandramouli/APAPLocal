SUBROUTINE LAPAP.REG.PROCESS.CLOSE.AA

* Autor: Oliver Fermin
* Description: Count de los registros procesados en la rutina LAPAP.CLOSE.ARRANGEMENT
* Date: 21/06/2019
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE              WHO                REFERENCE                 DESCRIPTION

* 21-APR-2023     Conversion tool    R22 Auto conversion       BP is removed in Insert File

*-----------------------------------------------------------------------------


    $INSERT I_COMMON ;*R22 Auto conversion - START
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.H.REPORTS.PARAM ;*R22 Auto conversion - END

    GOSUB INITIALISE

INITIALISE:

    Y.NOMBRE.ARCHIVO = 'REG.PROCESS.CLOSE.ARRANGEMENT.txt'

    FN.REDO.H.REPORTS.PARAM = "F.REDO.H.REPORTS.PARAM"
    F.REDO.H.REPORTS.PARAM = ''
    CALL OPF(FN.REDO.H.REPORTS.PARAM,F.REDO.H.REPORTS.PARAM)

    GOSUB READ.FILE.POST

RETURN


READ.FILE.POST:

    Y.PARAM.ID = "LAPAP.ECB.BALANCES"
    Y.LIST = ''

    R.REDO.H.REPORTS.PARAM = '';  PARAM.ERR = '';
    CALL CACHE.READ(FN.REDO.H.REPORTS.PARAM,Y.PARAM.ID,R.REDO.H.REPORTS.PARAM,PARAM.ERR)

    IF R.REDO.H.REPORTS.PARAM NE '' THEN
        Y.DIRECTORIO.ARCHIVO = R.REDO.H.REPORTS.PARAM<REDO.REP.PARAM.OUT.DIR>
    END

    OPENSEQ Y.DIRECTORIO.ARCHIVO,Y.NOMBRE.ARCHIVO TO FV.PTR.FIN ELSE
        CREATE FV.PTR.FIN ELSE
            CRT "CANNOT OPEN DIR" : Y.DIRECTORIO.ARCHIVO
            STOP
        END
    END

    LOOP
        READSEQ Y.REC FROM FV.PTR.FIN ELSE EOF = 1
    WHILE NOT(EOF)
        Y.LIST<-1> = Y.REC
    REPEAT

    Y.DCOUNT = DCOUNT(Y.LIST,@FM)

    O.DATA =  Y.DCOUNT

END
