* @ValidationCode : MjotMjM2MTg4MjExOkNwMTI1MjoxNjk5MjcxNDc3MjQyOklUU1MxOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 06 Nov 2023 17:21:17
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>179</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE DR.REG.213IF01.RTE.EXTRACT.POST
*--------------------------------------------------------------------------------------------------------------------------
* Input  Arg: N/A
* Output Arg: N/A
* Deals With: TO write the report in the REG.REPORTS path for the RTE transactions which has exceeded the RTE limit.
*--------------------------------------------------------------------------------------------------------------------------
* Who           Date           Dev Ref                       Modification
* APAP          09 Mar 2018    24 hours RTE - IF report      Initial Draft
* 06-11-2023     HARISHVIKRAM C   R22 Manual Conversion
*--------------------------------------------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.DATES
    $INSERT I_F.REDO.CLEARING.PROCESS
    $INSERT I_F.DR.REG.213IF01.PARAM

    GOSUB OPEN.FILES

    GOSUB PROCESS

RETURN

OPEN.FILES:

    FN.REDO.RTE.IF.WORKFILE = 'F.REDO.RTE.IF.WORKFILE'
    F.REDO.RTE.IF.WORKFILE = ''
    CALL OPF(FN.REDO.RTE.IF.WORKFILE,F.REDO.RTE.IF.WORKFILE)

    FN.DR.REG.213IF01.PARAM = 'F.DR.REG.213IF01.PARAM'
    F.DR.REG.213IF01.PARAM = ''
    CALL OPF(FN.DR.REG.213IF01.PARAM, F.DR.REG.213IF01.PARAM)

    R.DR.REG.213IF01.PARAM = ''; DR.REG.213IF01.PARAM.ERR = ''
    CALL CACHE.READ(FN.DR.REG.213IF01.PARAM, "SYSTEM", R.DR.REG.213IF01.PARAM, DR.REG.213IF01.PARAM.ERR)

    FN.REDO.CLEARING.PROCESS = 'F.REDO.CLEARING.PROCESS'
    F.REDO.CLEARING.PROCESS = ''
    CALL OPF(FN.REDO.CLEARING.PROCESS, F.REDO.CLEARING.PROCESS)

    CALL F.READ(FN.REDO.CLEARING.PROCESS, 'AML.PROCESS', R.REDO.CLEARING.PROCESS, F.REDO.CLEARING.PROCESS, READ.ERR)

    FN.FILE = TRIM(R.REDO.CLEARING.PROCESS<PRE.PROCESS.OUT.PROCESS.PATH>, '', 'D')
    F.FILE = ''
    OPEN FN.FILE TO F.FILE ELSE
        CRT 'Unable to open path ':FN.FILE
        STOP
    END

    Y.CAL.TODAY = OCONV(DATE(),"DYMD")
    Y.CAL.TODAY = EREPLACE(Y.CAL.TODAY,' ', '')

RETURN

PROCESS:

    RTE.REP.ARR = ''; RTE.REPMTH.ARR = ''
    EXECUTE 'SSELECT ':FN.REDO.RTE.IF.WORKFILE CAPTURING SEL.OUT

    READLIST SEL.LIST ELSE SEL.LIST = ''
    LOOP
        REMOVE RTE.REP.ID FROM SEL.LIST SETTING RTE.POS
    WHILE RTE.REP.ID:RTE.POS
        READ R.REDO.RTE.IF.WORKFILE FROM F.REDO.RTE.IF.WORKFILE,RTE.REP.ID ELSE R.REDO.RTE.IF.WORKFILE = ''
        IF R.REDO.RTE.IF.WORKFILE THEN
            IF RTE.REP.ID[1,3] EQ 'MTH' THEN
                RTE.REPMTH.ARR<-1> = R.REDO.RTE.IF.WORKFILE
            END
            IF RTE.REP.ID[1,3] NE 'MTH' THEN
                RTE.REP.ARR<-1> = R.REDO.RTE.IF.WORKFILE
            END
        END
    REPEAT
    FINAL.RTE.REP.ID = 'RTEREPORTFILE':'.':Y.CAL.TODAY:'.csv'
    FINAL.RTE.REPMTH.ID = 'RTEREPORTFILE':'.Mensual.':Y.CAL.TODAY:'.csv'

    WRITE RTE.REP.ARR TO F.FILE, FINAL.RTE.REP.ID

    IF RTE.REPMTH.ARR THEN
        WRITE RTE.REPMTH.ARR TO F.FILE, FINAL.RTE.REPMTH.ID
    END

    R.DR.REG.213IF01.PARAM<DR.213IF01.REP.END.DATE> = ''
    R.DR.REG.213IF01.PARAM<DR.213IF01.REP.START.DATE> = ''
    CALL F.WRITE(FN.DR.REG.213IF01.PARAM,"SYSTEM",R.DR.REG.213IF01.PARAM)

RETURN

END
