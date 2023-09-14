* @ValidationCode : MjoxNTU4NTUzMjgyOkNwMTI1MjoxNjgxOTA0NjI4MTU3OklUU1M6LTE6LTE6Njg0OjE6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 19 Apr 2023 17:13:48
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 684
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDORETAIL
* Modification History:
* Date                 Who                              Reference                            DESCRIPTION
*12-04-2023            CONVERSION TOOL                AUTO R22 CODE CONVERSION           VM TO @VM ,FM TO @FM SM TO @SM
*12-04-2023          jayasurya H                       MANUAL R22 CODE CONVERSION           CALL RTN METHOD ADDED
SUBROUTINE REDO.COL.POST.LOG

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.REDO.INTERFACE.PARAM
    $INSERT I_F.TSA.SERVICE
    GOSUB INITIALISE
    GOSUB PROCESS
RETURN

INITIALISE:

    FN.REDO.INTERFACE.PARAM='F.REDO.INTERFACE.PARAM'
    F.REDO.INTERFACE.PARAM=''
    CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
RETURN

PROCESS:

    CALL F.READ(FN.REDO.INTERFACE.PARAM,'COL001',R.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM,ERR)
    Y.FILE.PATH=R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.FI.REJECT.PATH>
    Y.FILE.NAME='job.status'
    OPEN Y.FILE.PATH TO F.FILE.PATH ELSE
        CALL COMO("FILE PATH FOR REJECTION NOT CONFIGURED")
    END
    SEL.FILE   ="SELECT ":Y.FILE.PATH:" WITH @ID EQ ":Y.FILE.NAME
    CALL EB.READLIST(SEL.FILE,Y.FILE.LIST,'',NO.SELL,SELL.ERR)

    IF Y.FILE.LIST EQ 'job.status' THEN

        READ Y.FILE.MSG FROM F.FILE.PATH,Y.FILE.NAME THEN
            GOSUB LOG.C22
        END
        Y.TSA.ID='BNK/REDO.COL.POST.LOG'
        FN.TSA.SERVICE='F.TSA.SERVICE'
        F.TSA.SERVICE =''
        CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)
        CALL F.READ(FN.TSA.SERVICE,Y.TSA.ID,R.TSA.SERVICE,F.TSA.SERVICE,ERR)
        R.TSA.SERVICE<TS.TSM.SERVICE.CONTROL>='STOP'
        CALL F.WRITE(FN.TSA.SERVICE,Y.TSA.ID,R.TSA.SERVICE)
    END

RETURN

LOG.C22:

    BAT.NO     = ''
    BAT.TOT    = ''
    INFO.OR    = ''
    INFO.DE    = ''
    Y.REC.CON  = ''
    EX.USER    = ''
    EX.PC      = ''
    MON.TP     = '04'
    INT.CODE   = 'COL001'
    INT.TYPE   = 'BATCH'
    ID.PROC    = 'COLLECTOR'
    CHANGE @FM TO " " IN Y.FILE.MSG
    Y.MESSAGE  = "Collector interface update":Y.FILE.MSG
    DESC       = Y.MESSAGE
    Y.REC.CON=Y.MESSAGE
    CALL APAP.REDOCHNLS.REDO.INTERFACE.REC.ACT(INT.CODE,INT.TYPE,BAT.NO,BAT.TOT,INFO.OR,INFO.DE,ID.PROC,MON.TP,DESC,Y.REC.CON,EX.USER,EX.PC) ;* MANUAL R22 CODE CONVERSION

RETURN
END
