* @ValidationCode : MjotMTU5OTIxMzgxMjpDcDEyNTI6MTY4MjA4MTcxMzM4NjpBZG1pbjotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 18:25:13
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
SUBROUTINE LAPAP.REG.PROCESS.CLOSE.AA

* Autor: Oliver Fermin
* Description: Count de los registros procesados en la rutina LAPAP.CLOSE.ARRANGEMENT
* Date: 21/06/2019
*-----------------------------------------------------------------------------

*MODIFICATION HISTORY:

*

* DATE               WHO             REFERENCE                DESCRIPTION

* 21-APR-2023   Conversion tool     R22 Auto conversion     BP is removed in Insert File
* 21-APR-2023   Narmadha V          R22 Manual Conversion    No Changes
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
